import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spotify/spotify.dart' as spoti;
import 'package:spotify_clone/services/likedservices.dart';
import 'package:spotify_clone/services/recentlyplayed.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:spotify_clone/controller/apicontroller/controller.dart';
import 'package:spotify_clone/widget/addtoplaylist.dart';

class Player extends StatefulWidget {
  final String trackId;
  final List<String>? playlist;
  final int? currentIndex;
  
  const Player({
    super.key, 
    required this.trackId,
    this.playlist,
    this.currentIndex,
  });

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  String? songName = 'Loading...';
  String? artistName = "Loading...";
  String? imageurl;
  final player = AudioPlayer();
  
  // Enhanced player controls
  late List<String> currentPlaylist;
  int currentTrackIndex = 0;
  bool isShuffleEnabled = false;
  LoopMode currentLoopMode = LoopMode.off;
  bool isLoading = false;
  bool _isLiked = false;
  
  // Add these variables for better state management
  Duration _totalDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    currentPlaylist = widget.playlist ?? [widget.trackId];
    currentTrackIndex = widget.currentIndex ?? 0;
    _setupAudioListeners();
    _initLikeState();
    _loadTrack(widget.trackId);
  }

  Future<void> _initLikeState() async {
    _isLiked = await LikedService.isLiked(widget.trackId);
    if (mounted) setState(() {});
  }

  Future<void> _toggleLike() async {
    _isLiked = await LikedService.toggleLike(widget.trackId);
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(_isLiked ? 'Added to Liked Songs' : 'Removed from Liked Songs'),
        ),
      );
    }
  }

  // Add recently played tracking method
  void _trackRecentlyPlayed() {
    RecentlyPlayedService.addToRecentlyPlayed(widget.trackId);
  }

  void _setupAudioListeners() {
    // Listen to duration changes
    player.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          _totalDuration = duration ?? Duration.zero;
          _isLoading = false;
        });
      }
    });

    // Listen to position changes
    player.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    // Listen to player state changes
    player.playerStateStream.listen((state) {
      if (mounted) {
        if (state.processingState == ProcessingState.loading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state.processingState == ProcessingState.ready) {
          setState(() {
            _isLoading = false;
          });
        } else if (state.processingState == ProcessingState.completed) {
          _handleTrackCompletion();
        }
      }
    });
  }

  void _handleTrackCompletion() {
    switch (currentLoopMode) {
      case LoopMode.off:
        _playNext();
        break;
      case LoopMode.one:
        player.seek(Duration.zero);
        player.play();
        _trackRecentlyPlayed(); // Track when replaying
        break;
      case LoopMode.all:
        _playNext();
        break;
    }
  }

  Future<void> _loadTrack(String trackId) async {
    if (isLoading) return;
    
    setState(() {
      isLoading = true;
      songName = 'Loading...';
      artistName = 'Loading...';
      imageurl = null;
    });

    try {
      final credentials = spoti.SpotifyApiCredentials(
        Controller.clienid,
        Controller.clienttoken,
      );
      final spotify = spoti.SpotifyApi(credentials);
      
      final fetchedTrack = await spotify.tracks.get(trackId);
      
      if (mounted) {
        setState(() {
          songName = fetchedTrack.name ?? "Unknown Song";
          artistName = (fetchedTrack.artists != null && fetchedTrack.artists!.isNotEmpty)
              ? fetchedTrack.artists!.first.name
              : "Unknown Artist";
          imageurl = fetchedTrack.album?.images?.first.url;
        });
      }

      final yt = YoutubeExplode();
      final spotifyDuration = Duration(milliseconds: fetchedTrack.durationMs ?? 0);
      final searchResults = await yt.search.search("$songName $artistName");
      
      if (searchResults.isNotEmpty) {
        final bestMatch = searchResults
            .where((video) => video.duration != null)
            .reduce((a, b) =>
                (a.duration! - spotifyDuration).abs() < (b.duration! - spotifyDuration).abs() ? a : b);

        final manifest = await yt.videos.streamsClient.getManifest(bestMatch.id.value);
        final audio = manifest.audioOnly.first.url;
        
        await player.setUrl(audio.toString());
      }
      
      yt.close();
    } catch (e) {
      print('Error loading track: $e');
      if (mounted) {
        setState(() {
          songName = 'Error loading track';
          artistName = 'Please try again';
          isLoading = false;
        });
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _playNext() {
    if (currentPlaylist.isEmpty || currentPlaylist.length <= 1) return;
    
    int nextIndex;
    if (isShuffleEnabled) {
      List<int> availableIndices = List.generate(currentPlaylist.length, (i) => i)
          .where((i) => i != currentTrackIndex)
          .toList();
      if (availableIndices.isEmpty) return;
      nextIndex = availableIndices[DateTime.now().millisecondsSinceEpoch % availableIndices.length];
    } else {
      nextIndex = (currentTrackIndex + 1) % currentPlaylist.length;
    }
    
    setState(() {
      currentTrackIndex = nextIndex;
    });
    _loadTrack(currentPlaylist[nextIndex]);
  }

  void _playPrevious() {
    if (currentPlaylist.isEmpty || currentPlaylist.length <= 1) return;
    
    int previousIndex;
    if (isShuffleEnabled) {
      List<int> availableIndices = List.generate(currentPlaylist.length, (i) => i)
          .where((i) => i != currentTrackIndex)
          .toList();
      if (availableIndices.isEmpty) return;
      previousIndex = availableIndices[DateTime.now().millisecondsSinceEpoch % availableIndices.length];
    } else {
      previousIndex = (currentTrackIndex - 1 + currentPlaylist.length) % currentPlaylist.length;
    }
    
    setState(() {
      currentTrackIndex = previousIndex;
    });
    _loadTrack(currentPlaylist[previousIndex]);
  }

  void _toggleShuffle() {
    setState(() {
      isShuffleEnabled = !isShuffleEnabled;
    });
  }

  void _toggleRepeat() {
    setState(() {
      switch (currentLoopMode) {
        case LoopMode.off:
          currentLoopMode = LoopMode.all;
          break;
        case LoopMode.all:
          currentLoopMode = LoopMode.one;
          break;
        case LoopMode.one:
          currentLoopMode = LoopMode.off;
          break;
      }
    });
    player.setLoopMode(currentLoopMode);
  }

  void _shareTrack() {
    if (songName != null && artistName != null) {
      Share.share(
        'Check out this song: $songName by $artistName',
        subject: 'Great music recommendation!',
      );
    }
  }

  void _showAddToPlaylistDialog() {
    if (songName != null) {
      showDialog(
        context: context,
        builder: (context) => AddToPlaylistDialog(
          trackId: widget.trackId,
          trackName: songName!,
        ),
      );
    }
  }

  void _showLyricsDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color.fromRGBO(28, 27, 27, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lyrics',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                songName ?? 'Unknown Song',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Lyrics feature coming soon!',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getRepeatIcon() {
    switch (currentLoopMode) {
      case LoopMode.off:
        return Icons.repeat;
      case LoopMode.all:
        return Icons.repeat;
      case LoopMode.one:
        return Icons.repeat_one;
    }
  }

  Color _getRepeatColor() {
    return currentLoopMode != LoopMode.off ? Colors.green : Colors.white;
  }

  // Helper method to format duration
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        children: [
          ProgressBar(
            progress: _currentPosition,
            total: _totalDuration,
            baseBarColor: Colors.grey,
            progressBarColor: Colors.white,
            bufferedBarColor: Colors.grey.shade400,
            thumbColor: Colors.white,
            timeLabelTextStyle: const TextStyle(color: Colors.white),
            barHeight: 5,
            onSeek: (duration) {
              player.seek(duration);
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_currentPosition),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                _formatDuration(_totalDuration),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(28, 27, 27, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
        title: const Text(
          'Now Playing',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: const Color.fromRGBO(44, 42, 42, 1),
            onSelected: (value) {
              switch (value) {
                case 'add_to_playlist':
                  _showAddToPlaylistDialog();
                  break;
                case 'share':
                  _shareTrack();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add_to_playlist',
                child: Row(
                  children: [
                    Icon(Icons.playlist_add, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Add to Playlist', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Share', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // Album Art
            Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: imageurl != null
                    ? Image.network(
                        imageurl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'Images/bb.jpg',
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'Images/bb.jpg',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Song Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Text(
                    songName ?? 'Unknown Song',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    artistName ?? 'Unknown Artist',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Progress Bar
            _isLoading 
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : _buildProgressBar(),
            
            const SizedBox(height: 20),
            
            // Control Buttons Row 1 (Shuffle, Favorite, Repeat)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _toggleShuffle,
                    icon: Icon(
                      Icons.shuffle,
                      color: isShuffleEnabled ? Colors.green : Colors.white,
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleLike,
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.white,
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleRepeat,
                    icon: Icon(
                      _getRepeatIcon(),
                      color: _getRepeatColor(),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            
            // Control Buttons Row 2 (Main Controls)
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Lyrics Button
                  IconButton(
                    onPressed: _showLyricsDialog,
                    icon: const Icon(Icons.lyrics_outlined, color: Colors.white),
                  ),
                  
                  // Previous Button
                  IconButton(
                    onPressed: currentPlaylist.length > 1 ? _playPrevious : null,
                    icon: Icon(
                      Icons.skip_previous,
                      color: currentPlaylist.length > 1 ? Colors.white : Colors.grey,
                      size: 40,
                    ),
                  ),
                  
                  // Play/Pause Button with Recently Played Tracking
                  StreamBuilder<bool>(
                    stream: player.playingStream,
                    builder: (context, snapshot) {
                      final isPlaying = snapshot.data ?? false;
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.green.shade400, Colors.green.shade600],
                          ),
                        ),
                        child: IconButton(
                          onPressed: _isLoading ? null : () async {
                            if (isPlaying) {
                              await player.pause();
                            } else {
                              await player.play();
                              _trackRecentlyPlayed(); // Add recently played tracking when song starts playing
                            }
                          },
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 50,
                                ),
                        ),
                      );
                    },
                  ),
                  
                  // Next Button
                  IconButton(
                    onPressed: currentPlaylist.length > 1 ? _playNext : null,
                    icon: Icon(
                      Icons.skip_next,
                      color: currentPlaylist.length > 1 ? Colors.white : Colors.grey,
                      size: 40,
                    ),
                  ),
                  
                  // Add to Playlist Button
                  IconButton(
                    onPressed: _showAddToPlaylistDialog,
                    icon: const Icon(Icons.playlist_add, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
