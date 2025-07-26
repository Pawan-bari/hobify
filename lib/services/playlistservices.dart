import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_clone/controller/Authentication/auth_services.dart';
import 'package:spotify_clone/modal/playlist.dart';

class PlaylistService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get user's playlists
  static Stream<List<PlaylistModel>> getUserPlaylists() {
    final userId = authServices.value.currentUser?.uid;
    if (userId == null) return Stream.value([]);
    
    return _firestore
        .collection('playlists')
        .where('createdBy', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PlaylistModel.fromMap(doc.data()))
            .toList());
  }
  
  // Create new playlist
  static Future<String> createPlaylist({
    required String name,
    String? imageUrl,
  }) async {
    try {
      final userId = authServices.value.currentUser?.uid;
      if (userId == null) throw Exception('User not logged in');
      
      final playlistId = _firestore.collection('playlists').doc().id;
      final playlist = PlaylistModel(
        id: playlistId,
        name: name,
        createdBy: userId,
        createdAt: DateTime.now(),
        trackIds: [],
        imageUrl: imageUrl,
      );
      
      await _firestore
          .collection('playlists')
          .doc(playlistId)
          .set(playlist.toMap());
      
      return playlistId;
    } catch (e) {
      throw Exception('Failed to create playlist: $e');
    }
  }
  
  // Add track to playlist
  static Future<void> addTrackToPlaylist({
    required String playlistId,
    required String trackId,
  }) async {
    try {
      await _firestore
          .collection('playlists')
          .doc(playlistId)
          .update({
        'trackIds': FieldValue.arrayUnion([trackId]),
      });
    } catch (e) {
      throw Exception('Failed to add track to playlist: $e');
    }
  }
  
  // Remove track from playlist
  static Future<void> removeTrackFromPlaylist({
    required String playlistId,
    required String trackId,
  }) async {
    try {
      await _firestore
          .collection('playlists')
          .doc(playlistId)
          .update({
        'trackIds': FieldValue.arrayRemove([trackId]),
      });
    } catch (e) {
      throw Exception('Failed to remove track from playlist: $e');
    }
  }
  
  // Delete playlist
  static Future<void> deletePlaylist(String playlistId) async {
    try {
      await _firestore.collection('playlists').doc(playlistId).delete();
    } catch (e) {
      throw Exception('Failed to delete playlist: $e');
    }
  }
  
  // Get playlist by ID
  static Future<PlaylistModel?> getPlaylistById(String playlistId) async {
    try {
      final doc = await _firestore
          .collection('playlists')
          .doc(playlistId)
          .get();
      
      if (doc.exists) {
        return PlaylistModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get playlist: $e');
    }
  }
}
