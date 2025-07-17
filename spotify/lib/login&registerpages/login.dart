import 'package:flutter/material.dart';
import 'package:spotify/login&registerpages/loginui.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      
     backgroundColor: Color.fromRGBO(28, 27, 27, 1),
      body: Stack(
  children: [
    Align(
      alignment: Alignment.bottomLeft,
      child: Image.asset(
        'Images/15mag-billie-03-master675-v3 1.png',
        fit: BoxFit.cover, // Ensures it covers the full screen
      ),
    ),
    Align(
      alignment: Alignment.bottomRight,
      child: Image.asset('Images/Union.png'),
    ),
    SingleChildScrollView( // Ensures content is scrollable on smaller screens
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Image.asset('Images/Union (1).png'),
          ),
          SizedBox(height: 80,),
          Align(
            alignment: Alignment.center,
            child: 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [  
          Image.asset('Images/Spotify.png',height: 100,),
          Text('Spotify',
          style: TextStyle(color: Colors.green,fontSize:60,fontWeight: FontWeight.bold ),
          )
          ] )
          ),
          SizedBox(height: 50,),
          Column(
            children: [
              Text('Enjoy Listening To Music',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),),
            ],
          ),
           SizedBox(height: 20,),
          Column(
            children: [
              Text('Spotify is a proprietary Swedish audio streaming and media services provider',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,),
            ],
          )
          ,SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: (
                                
                ){Navigator.pushNamed(context, 'register');
  
                  setState(() {
                  isPressed = !isPressed;
                });

                }, child: Text(
                      "Register",
                      style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      
                       minimumSize: Size(150,80 ),
                      backgroundColor: isPressed ?  Color.fromRGBO(66, 200, 60, 1) : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    ),
                    SizedBox(width: 80,),
                    
                    ElevatedButton(onPressed: (){
                      Navigator.pushNamed(context, 'loginui');
                    }, child: Text(
                      "Login",
                      style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      
                      minimumSize: Size(150,80 ),
                      backgroundColor: Color.fromRGBO(28, 27, 27, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    elevation: 0
                    ),
                  ),
              ],
            )
          ],          
          
        ),

    )])
  );}
}