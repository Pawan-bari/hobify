

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotify/controller/Authentication/auth_services.dart';
import 'package:spotify/login&registerpages/loginui.dart';
import 'package:spotify/controller/databa/firestore.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override

  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPass = TextEditingController();
  TextEditingController controllername = TextEditingController();
  final String url ='https://i.pinimg.com/736x/2b/bc/47/2bbc47578113791e42e1063d39acd9e3.jpg';
  final formKey = GlobalKey<FormState>();
  String errmsg ='';
  

  @override
  void dispose(){
    controllerEmail.dispose();
    controllerPass.dispose();
    controllername.dispose();
    super.dispose();
  }

 

  
void registerUserAndCreateProfile() async {
  
  String name = controllername.text.trim();
  String email = controllerEmail.text.trim();
  String password = controllerPass.text.trim();

  if (name.isEmpty || email.isEmpty || password.isEmpty) {
    
    return;
  }

  try {
    
    UserCredential userCredential = await authServices.value.createuser(
      email: email,
      pass: password,
    );

    User? newUser = userCredential.user;

    if (newUser != null) {
      
      await newUser.updateDisplayName(name);

      
      
      await Storedata().saveUserData(uid: newUser.uid, name: name, email: email);
      
      
      if (mounted) {
        Navigator.pushNamed(context, 'homepage');
      }
    }
  } on FirebaseAuthException catch (e) {
    
    print(e.message);
  }
}
void push()async{
  Navigator.pushNamed(context, 'homepage');
}


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 27, 27, 1),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.popAndPushNamed(context, 'login');
        }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
        centerTitle: true, 
      title: Image(image: Image.asset('Images/Vector.png').image),
      backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
               SizedBox(height: 50,),
            Text('Register',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
            SizedBox(height: 0,),
            Row(children: [
              SizedBox(width: 100,),
              Align(
                alignment: Alignment.center,
               child:  Text('if you Need any Support',style: TextStyle(color: Colors.white),)
               
              ),
              TextButton(onPressed: (){}, child: Text('Click here',style: 
              TextStyle(color: Color.fromRGBO(66, 200, 60, 1)),),)
            ],),
            
              SizedBox(height: 20,),
            Padding(padding: 
            const EdgeInsets.only(left: 25, right: 25),
            child: TextField(controller:  controllername,
              style: TextStyle(color: Colors.white,height: 3),
              
              decoration: InputDecoration(
                               
                hintText:   '     Name',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white)
                )
              ),
            )
            ),
            
            SizedBox(height: 20,),
             Padding(
             padding: const EdgeInsets.only(left: 25, right: 25),
             child: TextField(
              controller: controllerEmail,
              style: TextStyle(color: Colors.white,height: 3),
              decoration: InputDecoration(
                hintText: '    Enter Email',
                hintStyle: TextStyle(color:  Colors.white),
              border: OutlineInputBorder(
                  
                  borderRadius: BorderRadius.circular(30),
                  
                  borderSide: BorderSide(color: Colors.white)

                )
             
              ),
             ),
             
           ),
           
            SizedBox(height: 20,),
            Padding(padding: 
            const EdgeInsets.only(left: 25, right: 25),
            child: TextField(controller:  controllerPass,
              style: TextStyle(color: Colors.white,height: 3),
              obscureText: true,
              decoration: InputDecoration(
                               
                hintText:   '    Password',
                hintStyle: TextStyle(color: Colors.white,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white)
                )
              ),
            )
            ),
            Text(errmsg,style: TextStyle(color: Colors.red),),
             SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: ElevatedButton(onPressed: (){
                registerUserAndCreateProfile();
              }, child: Text('Create Account',
              style: TextStyle(
                color: Colors.white,fontSize: 25,
                fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(400, 80),
                  backgroundColor: Color.fromRGBO(66, 200, 60, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                ),
            ),
            SizedBox(height: 20,),
            Text('Or',style:  TextStyle(color: Colors.white),),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 25,right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: (){}, icon: Image.asset('Images/Group 26.png')),
                  
                  SizedBox(width: 25,),
                  IconButton(onPressed: (){}, icon: Image.asset('Images/Vector (1).png')),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an Account ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, 'loginui');
                }, child: Text('Login Now',style: TextStyle(color: Color.fromRGBO(40, 140, 233, 1)),))
              ],
            )

            ],
          ),
        ),
      ),
    );
  }
  

  
}