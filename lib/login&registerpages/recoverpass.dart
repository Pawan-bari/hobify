import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/controller/Authentication/auth_services.dart';

class Recoverpass extends StatefulWidget {
  const Recoverpass({super.key});

  @override
  State<Recoverpass> createState() => _RecoverpassState();
}

class _RecoverpassState extends State<Recoverpass> {
  TextEditingController controlleremail = TextEditingController();
  final formkey = GlobalKey<FormState>();
  String errmsg = '' ;
  @override

  void initstate(){
    super.initState();
    

  }
  @override
 
  void dispose() { 
    controlleremail.dispose();
    super.dispose();
    
  }
  void resetpass()async{
    if (controlleremail.text.trim().isEmpty ) {
    setState(() {
      errmsg = "Email fields cannot be empty";
    });
    return;
  }
    try {
       await authServices.value.resetpass(email: controlleremail.text);
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
    content: Text('please check email'), 
    showCloseIcon: true,)
    );
  }



  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 27, 27, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: (){
            Navigator.popAndPushNamed(context, 'loginui');
        }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80,),
            Text('Reset PassWord',style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),)
            ,SizedBox(height: 5,)
            ,Image.asset('Images/lock.png',height: 100,),
            SizedBox(height: 50,)
            ,Padding(
              padding: const EdgeInsets.only(left: 25 , right: 25),
              child: TextField(controller:  controlleremail,
                style: TextStyle(color: Colors.white) ,
                decoration: InputDecoration(
                                 
                  hintText:   'Enter your Password',
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
                        resetpass();
                }, child: Text('Reset Password',
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