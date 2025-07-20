import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/spotify.dart' as spoti;
import 'package:spotify_clone/controller/apicontroller/controller.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {

  String? songName = 'SongName';
  String? artistName = "Artist";
  String? imageurl;
  String track= '5ayTQo5gOcvPq44csmBODm?si=8d5f7d43c7ec4e6f';
  final player = AudioPlayer();
  Duration? duration;


  @override
void initState() {
  super.initState();

  final credentials = spoti.SpotifyApiCredentials(
    Controller.clienid,
    Controller.clienttoken,
  );
  final spotify = spoti.SpotifyApi(credentials);

  spotify.tracks.get(track).then((fetchedTrack) async {
    // ✅ Update state variables instead of creating new ones
    setState(() {
  songName = fetchedTrack.name ?? "Unknown Song";
  artistName = (fetchedTrack.artists != null && fetchedTrack.artists!.isNotEmpty)
      ? fetchedTrack.artists!.first.name
      : "Unknown Artist";

          imageurl = fetchedTrack.album?.images?.first.url;  

     
});

    // Search on YouTube by song name + artist
    final yt = YoutubeExplode();
      final spotifyDuration = Duration(milliseconds: fetchedTrack.durationMs ?? 0);
    final video = (await yt.search.search("$songName $artistName"));
    final bestMatch = video
      .where((video) => video.duration != null)
      .reduce((a, b) =>
          (a.duration! - spotifyDuration).abs() < (b.duration! - spotifyDuration).abs() ? a : b);


    setState(() {});

  var manifest = await yt.videos.streamsClient.getManifest(bestMatch.id.value);
  var audio = manifest.audioOnly.first.url;

  await player.setUrl(audio.toString());
    
  });
}

@override
void dispose() {
  player.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color.fromRGBO(28, 27, 27, 1),
       appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: (){
                Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        centerTitle: true 
        ,title: Text('Now Playing',style: TextStyle(fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.white),),
        actions: [
          IconButton(onPressed: (){

          }, icon: Icon(Icons.more_vert,color: Colors.white,))
        ],
       ),
       body: 
       Center(
        child: Column(
          children: [
           imageurl != null
    ? Image.network(
        imageurl!,
        height: 500,
        width: 500,
        fit: BoxFit.cover,
      )
    : Image.asset(
        'Images/bb.jpg',
        height: 500,
        width: 500,
        fit: BoxFit.cover,
      ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Align(
                alignment: Alignment.centerLeft
               , child: 
              Text(songName ?? 'Unknow name',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white,),),
                      ),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(artistName ?? 'unknown name',style: TextStyle(fontSize: 25,color: Colors.white,)),
              ),
            ),
            SizedBox(height: 30,),
            Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: StreamBuilder<Duration?>(
                        stream: player.durationStream,
                        builder: (context, snapshot) {
                          final total = snapshot.data ?? Duration.zero;
                          return StreamBuilder<Duration>(
                            stream: player.positionStream,
                            builder: (context, data) {
                              return ProgressBar(
                                progress: data.data ?? Duration.zero,
                                total: total,
                                baseBarColor: Colors.grey,
                                progressBarColor: Colors.white,
                                bufferedBarColor: Colors.grey.shade400,
                                thumbColor: Colors.white,
                                timeLabelTextStyle: const TextStyle(color: Colors.white),
                                barHeight: 5,
                                onSeek: (duration) {
                                  player.seek(duration);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 25,right: 25,top: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.lyrics_outlined,color: Colors.white,),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.skip_previous,color:  Colors.white,),
                      ),
                      StreamBuilder<bool>(
                                stream: player.playingStream,
                                builder: (context, snapshot) {
                                  final isPlaying = snapshot.data ?? false;
                                  return IconButton(
                                    onPressed: () async {
                                      if (isPlaying) {
                                        await player.pause();
                                      } else {
                                        await player.play();
                                      }
                                    },
                                    icon: Icon(
                                      isPlaying ? Icons.pause : Icons.play_circle,
                                      color: Colors.white,
                                      size: 80,
                                    ),
                                  );
                                },
                              ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.skip_next ,color: Colors.white,),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.replay ,color: Colors.white,),
                      ),
                     
                    ],

                  ),
                )
            ],
        ),
       ),
    );
  }
}