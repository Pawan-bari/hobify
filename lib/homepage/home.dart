import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as spoti;
import 'package:spotify_clone/controller/apicontroller/controller.dart';
import 'package:spotify_clone/Audio%20page/player.dart';
import 'package:spotify_clone/controller/Authentication/auth_services.dart';
import 'package:spotify_clone/services/likedservices.dart';

import 'package:spotify_clone/homepage/homepage.dart';
import 'package:spotify_clone/modal/playlist.dart';
import 'package:spotify_clone/pages/playlist_view.dart';
import 'package:spotify_clone/services/playlistservices.dart';
import 'package:spotify_clone/services/recentlyplayed.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late spoti.SpotifyApi spotify;
  List<spoti.Track> popularTracks = [];
  List<spoti.Album> featuredAlbums = [];
  List<spoti.Artist> topArtists = [];
  List<String> recentlyPlayedIds = [];
  List<PlaylistModel> userPlaylists = [];
  List<String> likedTrackIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeSpotify();
    _loadHomeContent();
    _loadUserData();
  }

  void _initializeSpotify() {
    final credentials = spoti.SpotifyApiCredentials(
      Controller.clienid,
      Controller.clienttoken,
    );
    spotify = spoti.SpotifyApi(credentials);
  }

  Future<void> _loadHomeContent() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Future.wait([
        _loadPopularTracks(),
        _loadFeaturedAlbums(),
        _loadTopArtists(),
        _loadRecentlyPlayed(),
      ]);

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading home content: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadPopularTracks() async {
    try {
      final searchQueries = [
        'popular hits 2024',
        'trending songs',
        'top charts',
        'viral music',
        'new releases'
      ];
      
      List<spoti.Track> allTracks = [];
      
      for (String query in searchQueries) {
        try {
          final search = await spotify.search.get(query).first(4);
          for (var page in search) {
            for (var item in page.items!) {
              if (item is spoti.Track && allTracks.length < 15) {
                allTracks.add(item);
              }
            }
          }
        } catch (e) {
          print('Error with search query "$query": $e');
          continue;
        }
      }
      
      popularTracks = allTracks.take(12).toList();
    } catch (e) {
      print('Error loading popular tracks: $e');
    }
  }

  Future<void> _loadFeaturedAlbums() async {
    try {
      final albumQueries = [
        'album year:2024',
        'new album releases',
        'popular albums'
      ];
      
      List<spoti.Album> allAlbums = [];
      
      for (String query in albumQueries) {
        try {
          final search = await spotify.search.get(query).first(3);
          for (var page in search) {
            for (var item in page.items!) {
              if (item is spoti.Album && allAlbums.length < 8) {
                allAlbums.add(item);
              }
            }
          }
        } catch (e) {
          print('Error with album query "$query": $e');
          continue;
        }
      }
      
      featuredAlbums = allAlbums.take(6).toList();
    } catch (e) {
      print('Error loading featured albums: $e');
    }
  }

  Future<void> _loadTopArtists() async {
    try {
      final artistQueries = [
        'popular artists',
        'trending artists',
        'top artists 2024'
      ];
      
      List<spoti.Artist> allArtists = [];
      
      for (String query in artistQueries) {
        try {
          final search = await spotify.search.get(query).first(3);
          for (var page in search) {
            for (var item in page.items!) {
              if (item is spoti.Artist && allArtists.length < 10) {
                allArtists.add(item);
              }
            }
          }
        } catch (e) {
          print('Error with artist query "$query": $e');
          continue;
        }
      }
      
      topArtists = allArtists.take(8).toList();
    } catch (e) {
      print('Error loading top artists: $e');
    }
  }

  Future<void> _loadRecentlyPlayed() async {
    try {
      final recentIds = await RecentlyPlayedService.getRecentlyPlayed();
      setState(() {
        recentlyPlayedIds = recentIds.take(5).toList();
      });
    } catch (e) {
      print('Error loading recently played: $e');
    }
  }

  Future<void> _loadUserData() async {
    try {
      PlaylistService.getUserPlaylists().listen((playlists) {
        if (mounted) {
          setState(() {
            userPlaylists = playlists.take(3).toList();
          });
        }
      });

      LikedService.likedTracksStream().listen((likedIds) {
        if (mounted) {
          setState(() {
            likedTrackIds = likedIds.take(5).toList();
          });
        }
      });

      RecentlyPlayedService.getRecentlyPlayedStream().listen((recentIds) {
        if (mounted) {
          setState(() {
            recentlyPlayedIds = recentIds.take(5).toList();
          });
        }
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  void _navigateToTab(int tabIndex) {
    final homepageState = context.findAncestorStateOfType<HomepageState>();
    if (homepageState != null) {
      homepageState.changeTab(tabIndex);
    }
  }

  void _navigateToLikedSongs() {
    _navigateToTab(2); // Library tab
  }

  void _navigateToPlaylists() {
    _navigateToTab(2); // Library tab
  }

  void _navigateToSearch() {
    _navigateToTab(1); // Search tab
  }

  void _navigateToDiscover() {
    _navigateToSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.green),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await _loadHomeContent();
                await _loadUserData();
              },
              color: Colors.green,
              backgroundColor: const Color.fromRGBO(28, 27, 27, 1),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreetingSection(),
                    _buildQuickAccessSection(),
                    
                    if (recentlyPlayedIds.isNotEmpty) ...[
                      _buildSectionHeader('Recently Played', onSeeAll: _navigateToSearch),
                      _buildRecentlyPlayedSection(),
                    ],
                    
                    if (userPlaylists.isNotEmpty) ...[
                      _buildSectionHeader('My Playlists', onSeeAll: _navigateToPlaylists),
                      _buildMyPlaylistsSection(),
                    ],
                    
                    if (likedTrackIds.isNotEmpty) ...[
                      _buildSectionHeader('Your Liked Songs', onSeeAll: _navigateToLikedSongs),
                      _buildLikedSongsSection(),
                    ],
                    
                    _buildSectionHeader('Popular Right Now', onSeeAll: _navigateToSearch),
                    _buildPopularTracksSection(),
                    
                    if (featuredAlbums.isNotEmpty) ...[
                      _buildSectionHeader('Featured Albums', onSeeAll: _navigateToSearch),
                      _buildFeaturedAlbumsSection(),
                    ],
                    
                    if (topArtists.isNotEmpty) ...[
                      _buildSectionHeader('Popular Artists', onSeeAll: _navigateToSearch),
                      _buildTopArtistsSection(),
                    ],
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildGreetingSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getGreeting(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            authServices.value.currentUser?.displayName ?? 'User',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              _buildQuickAccessCard(
                'Liked Songs',
                Icons.favorite,
                Colors.purple,
                _navigateToLikedSongs,
              ),
              const SizedBox(width: 10),
              _buildQuickAccessCard(
                'My Playlists',
                Icons.playlist_play,
                Colors.green,
                _navigateToPlaylists,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildQuickAccessCard(
                'Recently Played',
                Icons.history,
                Colors.orange,
                _navigateToSearch,
              ),
              const SizedBox(width: 10),
              _buildQuickAccessCard(
                'Discover',
                Icons.explore,
                Colors.blue,
                _navigateToDiscover,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(44, 42, 42, 1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text(
                'See all',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMyPlaylistsSection() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: userPlaylists.length,
        itemBuilder: (context, index) {
          final playlist = userPlaylists[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaylistView(playlist: playlist),
                ),
              );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140,
                    height: 135,
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.playlist_play,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    playlist.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${playlist.trackIds.length} songs',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLikedSongsSection() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: likedTrackIds.length,
        itemBuilder: (context, index) {
          final trackId = likedTrackIds[index];
          
          return FutureBuilder<spoti.Track?>(
            future: _getTrackById(trackId),
            builder: (context, snapshot) {
              final track = snapshot.data;
              
              return GestureDetector(
                onTap: () {
                  if (track != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Player(
                          trackId: trackId,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 135,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: track?.album?.images?.isNotEmpty == true
                              ? Image.network(
                                  track!.album!.images!.first.url!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.purple.shade700,
                                      child: const Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.purple.shade700,
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        track?.name ?? 'Loading...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        track?.artists?.map((a) => a.name).join(', ') ?? 'Loading...',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRecentlyPlayedSection() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: recentlyPlayedIds.length,
        itemBuilder: (context, index) {
          final trackId = recentlyPlayedIds[index];
          
          return FutureBuilder<spoti.Track?>(
            future: _getTrackById(trackId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 135,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final track = snapshot.data;
              if (track == null) {
                return const SizedBox.shrink();
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Player(
                        trackId: trackId,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 135,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: track.album?.images?.isNotEmpty == true
                                  ? Image.network(
                                      track.album!.images!.first.url!,
                                      fit: BoxFit.cover,
                                      width: 140,
                                      height: 135,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.orange.shade700,
                                          child: const Icon(
                                            Icons.history,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: Colors.orange.shade700,
                                      child: const Icon(
                                        Icons.history,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                            ),
                            // Recently played indicator
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.history,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        track.name ?? 'Unknown',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        track.artists?.map((a) => a.name).join(', ') ?? 'Unknown Artist',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPopularTracksSection() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: popularTracks.length,
        itemBuilder: (context, index) {
          final track = popularTracks[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Player(
                    trackId: track.id!,
                  ),
                ),
              );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140,
                    height: 135,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: track.album?.images?.isNotEmpty == true
                          ? Image.network(
                              track.album!.images!.first.url!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade800,
                                  child: const Icon(
                                    Icons.music_note,
                                    color: Colors.white54,
                                    size: 40,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey.shade800,
                              child: const Icon(
                                Icons.music_note,
                                color: Colors.white54,
                                size: 40,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    track.name ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    track.artists?.map((a) => a.name).join(', ') ?? 'Unknown Artist',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedAlbumsSection() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: featuredAlbums.length,
        itemBuilder: (context, index) {
          final album = featuredAlbums[index];
          return GestureDetector(
            onTap: () {
              print('Tapped on album: ${album.name}');
            },
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: album.images?.isNotEmpty == true
                          ? Image.network(
                              album.images!.first.url!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade800,
                                  child: const Icon(
                                    Icons.album,
                                    color: Colors.white54,
                                    size: 40,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey.shade800,
                              child: const Icon(
                                Icons.album,
                                color: Colors.white54,
                                size: 40,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    album.name ?? 'Unknown Album',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    album.artists?.map((a) => a.name).join(', ') ?? 'Unknown Artist',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopArtistsSection() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: topArtists.length,
        itemBuilder: (context, index) {
          final artist = topArtists[index];
          return GestureDetector(
            onTap: () {
              print('Tapped on artist: ${artist.name}');
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: artist.images?.isNotEmpty == true
                          ? Image.network(
                              artist.images!.first.url!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade800,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white54,
                                    size: 40,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey.shade800,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white54,
                                size: 40,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    artist.name ?? 'Unknown Artist',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<spoti.Track?> _getTrackById(String trackId) async {
    try {
      return await spotify.tracks.get(trackId);
    } catch (e) {
      print('Error fetching track $trackId: $e');
      return null;
    }
  }
}
