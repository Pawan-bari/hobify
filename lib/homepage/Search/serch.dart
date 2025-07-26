import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as Spoti;
import 'package:spotify_clone/Audio%20page/player.dart';
import 'package:spotify_clone/controller/apicontroller/controller.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController controllersearch = TextEditingController();
  late Spoti.SpotifyApi spotify;
 List<Spoti.Track> result = [];
  bool isloading =false;

Future<void> searchsong(String que) async{
  if (que.isEmpty)return;


      setState(() =>
        isloading = true        
      );
      final credentials = Spoti.SpotifyApiCredentials(
        Controller.clienid, Controller.clienttoken
        );
final spotify = Spoti.SpotifyApi(credentials);

final Search = await spotify.search.get(que).first(10);
List<Spoti.Track> tracks =[];


for (var page in Search) {
  for(var item in page.items!){
    if(item is Spoti.Track){
      tracks.add(item);
    }
  }
  
}
    setState(() {
      result = tracks;
      isloading = false;
    });


}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: 
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10,right: 20),
              child: TextField(
                controller: controllersearch,
                style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                 hintText: 'Search song',
                 fillColor: Color.fromRGBO(44, 42, 42, 1)
                 ,filled: true,
                 contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 20,vertical: 20)
                 ,border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none
                 ),
              suffixIcon: IconButton(onPressed: (){
                  searchsong(controllersearch.text);
              }, icon: Icon(Icons.search,color: Colors.white,))
                ),
              onSubmitted: searchsong,),
              
            ),
            if(isloading)
            const CircularProgressIndicator(),
            Expanded(child: ListView.builder(
              itemCount: result.length,
              itemBuilder: (context,index){
                final track = result[index];
                return ListTile(
                  leading: track.album?.images?.isNotEmpty == true
                      ? Image.network(track.album!.images!.first.url!)
                      : const Icon(Icons.music_note, color: Colors.white),
                  title: Text(track.name ?? "Unknown", style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    track.artists?.map((a) => a.name).join(", ") ?? "Unknown Artist",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => Player(trackId: track.id!), 
  ),
);
                  },
                );
              }
              )
              ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                
                children: [
                  SizedBox(height: 40,),
                  Align(
                    alignment: Alignment.centerLeft
                        ,child:
              Text('',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20,),)
                      )]),
            )],
        ),
    );
  }
}