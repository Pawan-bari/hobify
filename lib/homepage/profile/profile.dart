import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spotify/controller/Authentication/auth_services.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String url ='https://i.pinimg.com/736x/2b/bc/47/2bbc47578113791e42e1063d39acd9e3.jpg';
  @override
  


  Widget build(BuildContext context) {
   
  
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(28, 27, 27, 1),
        body: Center ( 
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
              child: 
            Text('My Profile',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold,),textAlign: TextAlign.start,),
              )
              ,SizedBox(height: 5,)
              ,Align(
                alignment: Alignment.topLeft
            ,child: Container(
                height: 5,
                    width:50,
                    
                    
            )
              ),
              SizedBox(height: 10,),

              Container(
                height: 200,
                width: 380,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 5
                ),
                borderRadius: BorderRadius.circular(20),
                
              ),
              child: Center(
                
                child: Column
                (
                 children: [  CircleAvatar(radius: 50,
                backgroundImage: NetworkImage(url),
                 
                
                ),
            Text('Pawan',style: TextStyle(color: Colors.white,fontSize: 30),)
            ,Text('Email',style: TextStyle(color: Colors.white70),)
            ]
            )
              ),
              
              ),SizedBox(height: 10,)
              ,Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft
                  ,child: 
                Text('SETTING',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),)
                          ),
              
              ),
              SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text('Logout',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),),
            selectedColor: Colors.red,
            selected: true,
            onTap: (){
              popup();
            },
            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
          ),
        )
              ]
        ))
      ),
    );
  }
  void popup(){
     showDialog(
        context: context,
        useSafeArea: true,
        barrierDismissible: false,
        builder: (context) {
        return AlertDialog(
           title: Text('Logout'),
           content: Text('Are u sure you want to logout?'),
           buttonPadding: EdgeInsets.all(8),
           actions: [
            Row(
              children: [
                
                ElevatedButton(onPressed: (){
                  logout22();
                }, child: Text('Logout'),
                
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                foregroundColor: Colors.black), ),
                SizedBox(width: 30,),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child:  Text('cancle'),
                
                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,
                foregroundColor: Colors.green), )],
              
            )
           
           ],
           );
         },
       );
  }
  
  void logout22()async{
    try  {
      await authServices.value.signout();
      
      poppage();
    } on FirebaseException catch (e) {
       print(e.message);
    }
  }
  
  void poppage() {
    Navigator.pop(context);
  }

}