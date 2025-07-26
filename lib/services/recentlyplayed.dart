import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_clone/controller/Authentication/auth_services.dart';

class RecentlyPlayedService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  static String? get _uid => authServices.value.currentUser?.uid;

  /// Add a track to recently played
  static Future<void> addToRecentlyPlayed(String trackId) async {
    final uid = _uid;
    if (uid == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('recently_played')
          .doc(trackId)
          .set({
        'trackId': trackId,
        'playedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      // Keep only last 20 recently played tracks
      await _cleanupOldTracks();
    } catch (e) {
      print('Error adding to recently played: $e');
    }
  }

  /// Get recently played tracks stream
  static Stream<List<String>> getRecentlyPlayedStream() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('recently_played')
        .orderBy('playedAt', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data()['trackId'] as String)
            .toList());
  }

  /// Get recently played tracks as a future (for initial load)
  static Future<List<String>> getRecentlyPlayed() async {
    final uid = _uid;
    if (uid == null) return [];
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('recently_played')
          .orderBy('playedAt', descending: true)
          .limit(10)
          .get();
      
      return snapshot.docs
          .map((doc) => doc.data()['trackId'] as String)
          .toList();
    } catch (e) {
      print('Error getting recently played: $e');
      return [];
    }
  }

  /// Clean up old tracks (keep only last 20)
  static Future<void> _cleanupOldTracks() async {
    final uid = _uid;
    if (uid == null) return;
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('recently_played')
          .orderBy('playedAt', descending: true)
          .get();
      
      if (snapshot.docs.length > 20) {
        final batch = _firestore.batch();
        for (int i = 20; i < snapshot.docs.length; i++) {
          batch.delete(snapshot.docs[i].reference);
        }
        await batch.commit();
      }
    } catch (e) {
      print('Error cleaning up old tracks: $e');
    }
  }
}
