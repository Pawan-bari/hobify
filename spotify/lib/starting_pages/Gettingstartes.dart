import 'package:flutter/material.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({super.key,});

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Images/Gettingstarted.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
            appBar: AppBar(backgroundColor: Colors.transparent,toolbarHeight: 4,),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                       
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('Images/Spotify.png'),
                    height: 70,),
                    Text('Spotify', style: TextStyle(
                        fontSize: 40, color: Colors.green, 
                        fontWeight: FontWeight.bold),),
                    ],
                  ),
              SizedBox(height: 470,),
              Text('Enjoy Listening to Music', style: TextStyle(
                  fontSize: 30, color: Colors.white,fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),
                Text('           Lorem ipsum dolor sit amet,'
                ' consectetur adipiscing elit. Sagittis enim '
                '         purus sed phasellus. Cursus ornare id scelerisque aliquam.',style: TextStyle(fontSize: 16,color: Colors.white,),)
                ,SizedBox(height: 50,),
                ElevatedButton(onPressed: () {
                  Navigator.of(context).pushNamed('login');
                }, child: Text(
                  "Get Started",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  
                  minimumSize: Size(400, 80),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                
              )
                ],
              ),
            )
        )
        ),
    );
  }
}