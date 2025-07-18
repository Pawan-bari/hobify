import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotify/controller/Authentication/auth_services.dart';

class Updateusername extends StatefulWidget {
  const Updateusername({super.key});

  @override
  State<Updateusername> createState() => _UpdateusernameState();
}

class _UpdateusernameState extends State<Updateusername> {
  TextEditingController controllerUsername = TextEditingController();

  final formkey = GlobalKey<FormState>();
  String errmsg = '';
  
  
   @override
 
  void dispose() { 
    controllerUsername.dispose();
    super.dispose();
    
  }
  void username()async{
     if (controllerUsername.text.trim().isEmpty ) {
    setState(() {
      errmsg = "username fields cannot be empty";
    });
    return;
  }
    try {
       await authServices.value.updateusername(username: controllerUsername.text);
       snakebar();
       setState(() {
         
         errmsg = '';
       });
    } on FirebaseAuthException catch (e) {
      setState(() {
      errmsg = e.message ?? 'This is not working';  
      });
      
    }
  }


void snakebar(){
    ScaffoldMessenger.of(context).clearMaterialBanners();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Theme.of(context).colorScheme.primary,
    content: Text('username updated'), 
    showCloseIcon: true,)
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color.fromRGBO(28, 27, 27, 1),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.popAndPushNamed(context, 'homepage');
        }, icon: Icon( Icons.arrow_back_ios_new,color: Colors.white,))
        ,backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80,),
            Text('Update Username',style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),)
            ,SizedBox(height: 5,)
            ,Image.asset('Images/2541991.png',height: 100,),
            SizedBox(height: 50,)
            ,Padding(
              padding: const EdgeInsets.only(left: 25 , right: 25),
              child: TextField(controller: controllerUsername,
                style: TextStyle(color: Colors.white) ,
                decoration: InputDecoration(
                                 
                  hintText:   'Enter new Username',
                  hintStyle: TextStyle(color: Colors.white,height: 3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white)
                    
                  )
                ),
              ),
            ),
            Text(errmsg,style: TextStyle(color:  Colors.red),)

            ,SizedBox(height: 100,),
            Padding(
              padding: const EdgeInsets.only(top: 240,left: 25,right: 25),
              child: ElevatedButton(onPressed: (){
                        username();
                }, child: Text('Update Username',
                style: TextStyle(
                  color: Colors.white,fontSize: 25,
                  fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(400, 80),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}