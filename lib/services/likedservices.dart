import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_clone/controller/Authentication/auth_services.dart';

/// All reads & writes for the user’s liked tracks live here.
/// Firestore layout used:
/// users/{uid}/liked/{trackId} → { createdAt : Timestamp }
class LikedService {
  static final _db = FirebaseFirestore.instance;

  static String? get _uid => authServices.value.currentUser?.uid;

  /// Real-time list of liked track IDs for the signed-in user.
  static Stream<List<String>> likedTracksStream() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _db
        .collection('users')
        .doc(uid)
        .collection('liked')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((q) => q.docs.map((d) => d.id).toList());
  }

  /// Returns true ↔ false if the track is already liked.
  static Future<bool> isLiked(String trackId) async {
    final uid = _uid;
    if (uid == null) return false;
    final doc = await _db
        .collection('users')
        .doc(uid)
        .collection('liked')
        .doc(trackId)
        .get();
    return doc.exists;
  }

  /// Toggles the like state and returns the *new* state.
  static Future<bool> toggleLike(String trackId) async {
    final uid = _uid;
    if (uid == null) throw Exception('User not logged-in');
    final ref =
        _db.collection('users').doc(uid).collection('liked').doc(trackId);

    return _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (snap.exists) {
        tx.delete(ref);
        return false;
      } else {
        tx.set(ref, {'createdAt': FieldValue.serverTimestamp()});
        return true;
      }
    });
  }
}
