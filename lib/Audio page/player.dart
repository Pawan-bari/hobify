import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spotify/spotify.dart' as spoti;
import 'package:soundcloud_explode_dart/soundcloud_explode_dart.dart';
import 'package:spotify_clone/services/likedservices.dart';
import 'package:spotify_clone/services/recentlyplayed.dart';
import 'package:spotify_clone/controller/apicontroller/controller.dart';
import 'package:spotify_clone/widget/addtoplaylist.dart';
import 'dart:math';

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
  SoundcloudClient? soundCloudClient;
  
  late List<String> currentPlaylist;
  int currentTrackIndex = 0;
  bool isShuffleEnabled = false;
  LoopMode currentLoopMode = LoopMode.off;
  bool isLoading = false;
  bool _isLiked = false;
  
  Duration _totalDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    soundCloudClient = SoundcloudClient();
    currentPlaylist = widget.playlist ?? [widget.trackId];
    currentTrackIndex = widget.currentIndex ?? 0;
    _setupAudioListeners();
    _initLikeState();
    _loadTrack(currentPlaylist[currentTrackIndex]);
  }

  Future<void> _initLikeState() async {
    _isLiked = await LikedService.isLiked(currentPlaylist[currentTrackIndex]);
    if (mounted) setState(() {});
  }

  void _setupAudioListeners() {
    player.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          _totalDuration = duration ?? Duration.zero;
          _isLoading = false;
        });
      }
    });

    player.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    player.playerStateStream.listen((state) {
      if (mounted) {
        if (state.processingState == ProcessingState.loading) {
          setState(() => _isLoading = true);
        } else if (state.processingState == ProcessingState.ready) {
          setState(() => _isLoading = false);
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
        break;
      case LoopMode.all:
        _playNext();
        break;
    }
  }

  // FIXED TRACK LOADING
  Future<void> _loadTrack(String trackId) async {
    if (isLoading) return;
    
    setState(() {
      isLoading = true;
      songName = 'Searching for music...';
      artistName = 'Please wait...';
      imageurl = null;
    });

    try {
      print('🎵 Loading track: $trackId');

      // Step 1: Get Spotify track info
      final credentials = spoti.SpotifyApiCredentials(
        Controller.clienid,
        Controller.clienttoken,
      );
      final spotify = spoti.SpotifyApi(credentials);
      final fetchedTrack = await spotify.tracks.get(trackId);
      
      final trackName = fetchedTrack.name ?? "Unknown Song";
      final artistNames = fetchedTrack.artists?.map((a) => a.name).join(', ') ?? "Unknown Artist";
      
      if (mounted) {
        setState(() {
          songName = trackName;
          artistName = artistNames;
          imageurl = fetchedTrack.album?.images?.first.url;
        });
      }

      print('📋 Searching for: "$trackName" by "$artistNames"');

      // Step 2: Search SoundCloud with improved method
      String? audioUrl = await _searchSoundCloudMusic(trackName, artistNames);

      if (audioUrl != null) {
        print('✅ REAL MUSIC FOUND ON SOUNDCLOUD!');
        
        if (mounted) {
          setState(() {
            songName = '🎵 $trackName';
            artistName = '🎧 $artistNames (Real Music!)';
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('🎧 Real music found on SoundCloud!'),
            duration: Duration(seconds: 2),
          ),
        );

        await player.setUrl(audioUrl);
        await player.setLoopMode(currentLoopMode);
        
      } else {
        // Fallback to sample
        print('⚠️ Real music not found, using sample');
        String sampleUrl = _getQualitySample(trackName, artistNames);
        
        if (mounted) {
          setState(() {
            songName = '📻 $trackName (Sample)';
            artistName = '⚠️ $artistNames (Sample Audio)';
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            content: Text('Using sample audio - real music not available'),
            duration: Duration(seconds: 2),
          ),
        );

        await player.setUrl(sampleUrl);
        await player.setLoopMode(currentLoopMode);
      }

      // Track recently played
      RecentlyPlayedService.addToRecentlyPlayed(trackId);
      
    } catch (e) {
      print('💥 Error: $e');
      _handleLoadError(trackId);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // SIMPLIFIED SOUNDCLOUD SEARCH
  // CORRECTED SOUNDCLOUD SEARCH METHOD
Future<String?> _searchSoundCloudMusic(String trackName, String artistNames) async {
  if (soundCloudClient == null) return null;
  
  try {
    List<String> searchQueries = [
      '$trackName $artistNames',
      '$trackName by $artistNames',
      '$artistNames $trackName',
      '$trackName $artistNames official',
      trackName, // Sometimes just the track name works better
    ];

    for (String searchQuery in searchQueries) {
      print('🔍 SoundCloud search: "$searchQuery"');

      try {
        // CORRECT METHOD: Use search() not searchTracks()
        final searchStream = soundCloudClient!.search(
          searchQuery,
          searchFilter: SearchFilter.tracks,
          limit: 10,
        );

        await for (final results in searchStream) {
          for (final result in results) {
            if (result is TrackSearchResult) {
              final track = result;
              
              double matchScore = _calculateSimpleMatchScore(
                track.title, 
                track.user.username, 
                trackName, 
                artistNames
              );
              
              print('📊 "${track.title}" by "${track.user.username}" - Score: ${(matchScore * 100).toStringAsFixed(1)}%');

              if (matchScore > 0.4) { // Lower threshold for more matches
                try {
                  // Get streams for the track
                  final streams = await soundCloudClient!.tracks.getStreams(track.id);
                  
                  if (streams.isNotEmpty) {
                    // Find best quality stream
                    final bestStream = streams.firstWhere(
                      (stream) => stream.container == 'mp3',
                      orElse: () => streams.first,
                    );
                    
                    print('✅ Found SoundCloud stream: ${bestStream.url}');
                    return bestStream.url;
                  }
                } catch (streamError) {
                  print('⚠️ Stream extraction failed: $streamError');
                  continue;
                }
              }
            }
          }
          // Only process first batch of results
          break;
        }
      } catch (queryError) {
        print('❌ Query "$searchQuery" failed: $queryError');
        continue;
      }
    }
  } catch (e) {
    print('❌ SoundCloud search failed: $e');
  }
  
  return null;
}


  // SIMPLE MATCHING ALGORITHM (NO ERRORS)
  double _calculateSimpleMatchScore(String trackTitle, String trackArtist, String searchTrack, String searchArtist) {
    String normalize(String input) {
      return input.toLowerCase()
          .replaceAll(RegExp(r'[^\w\s]'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
    }

    String normTrackTitle = normalize(trackTitle);
    String normTrackArtist = normalize(trackArtist);
    String normSearchTrack = normalize(searchTrack);
    String normSearchArtist = normalize(searchArtist);

    double titleScore = 0.0;
    double artistScore = 0.0;

    // Simple title matching
    List<String> searchWords = normSearchTrack.split(' ');
    List<String> titleWords = normTrackTitle.split(' ');

    int matches = 0;
    for (String searchWord in searchWords) {
      if (searchWord.length > 2) {
        for (String titleWord in titleWords) {
          if (titleWord.contains(searchWord) || searchWord.contains(titleWord)) {
            matches++;
            break;
          }
        }
      }
    }

    if (searchWords.isNotEmpty) {
      titleScore = matches / searchWords.length;
    }

    // Simple artist matching
    if (normTrackTitle.contains(normSearchArtist) || normTrackArtist.contains(normSearchArtist)) {
      artistScore = 1.0;
    } else {
      List<String> artistWords = normSearchArtist.split(' ');
      for (String artistWord in artistWords) {
        if (artistWord.length > 2) {
          if (normTrackTitle.contains(artistWord) || normTrackArtist.contains(artistWord)) {
            artistScore = 0.7;
            break;
          }
        }
      }
    }

    return (titleScore * 0.6) + (artistScore * 0.4);
  }

  // QUALITY SAMPLE SELECTOR
  String _getQualitySample(String trackName, String artistNames) {
    final Map<String, String> samples = {
      'devil': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'elvis': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'queen': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      'ed sheeran': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
      'weeknd': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
      'billie eilish': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
    };

    String searchKey = '$trackName $artistNames'.toLowerCase();
    
    for (String key in samples.keys) {
      if (searchKey.contains(key)) {
        return samples[key]!;
      }
    }

    // Default samples
    final List<String> defaultSamples = [
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    ];

    int hash = searchKey.hashCode.abs();
    return defaultSamples[hash % defaultSamples.length];
  }

  void _handleLoadError(String trackId) {
    if (mounted) {
      setState(() {
        songName = 'Error loading track';
        artistName = 'Please try again';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load track'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => _loadTrack(trackId),
          ),
        ),
      );
    }
  }

  Future<void> _toggleLike() async {
    final trackId = currentPlaylist[currentTrackIndex];
    _isLiked = await LikedService.toggleLike(trackId);
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

  void _playNext() {
    if (currentPlaylist.length <= 1) return;
    
    int nextIndex = (currentTrackIndex + 1) % currentPlaylist.length;
    setState(() {
      currentTrackIndex = nextIndex;
    });
    _loadTrack(currentPlaylist[nextIndex]);
  }

  void _playPrevious() {
    if (currentPlaylist.length <= 1) return;
    
    int previousIndex = (currentTrackIndex - 1 + currentPlaylist.length) % currentPlaylist.length;
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
      Share.share('Check out this song: $songName by $artistName');
    }
  }

  void _showAddToPlaylistDialog() {
    if (songName != null) {
      showDialog(
        context: context,
        builder: (context) => AddToPlaylistDialog(
          trackId: currentPlaylist[currentTrackIndex],
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
          onPressed: () => Navigator.pop(context),
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
                          return Container(
                            color: Colors.grey.shade800,
                            child: const Icon(Icons.music_note, color: Colors.white54, size: 100),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey.shade800,
                        child: const Icon(Icons.music_note, color: Colors.white54, size: 100),
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
            
            // Control Buttons Row 1
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
            
            // Control Buttons Row 2
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: _showLyricsDialog,
                    icon: const Icon(Icons.lyrics_outlined, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: currentPlaylist.length > 1 ? _playPrevious : null,
                    icon: Icon(
                      Icons.skip_previous,
                      color: currentPlaylist.length > 1 ? Colors.white : Colors.grey,
                      size: 40,
                    ),
                  ),
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
                              RecentlyPlayedService.addToRecentlyPlayed(currentPlaylist[currentTrackIndex]);
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
                  IconButton(
                    onPressed: currentPlaylist.length > 1 ? _playNext : null,
                    icon: Icon(
                      Icons.skip_next,
                      color: currentPlaylist.length > 1 ? Colors.white : Colors.grey,
                      size: 40,
                    ),
                  ),
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
