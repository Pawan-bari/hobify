import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotify/controller/Authentication/auth_services.dart';
import 'package:spotify/login&registerpages/loginui.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override

  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPass = TextEditingController();
  TextEditingController controllername = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String errmsg ='';
  
  @override
  void dispose(){
    controllerEmail.dispose();
    controllerPass.dispose();
    controllername.dispose();
    super.dispose();
  }

  
void register() async {

  if (controllerEmail.text.trim().isEmpty || controllerPass.text.trim().isEmpty) {
    setState(() {
      errmsg = "Email and password fields cannot be empty";
    });
    return;
  }

  try {
    await authServices.value.createuser(
      email: controllerEmail.text.trim(),
      pass: controllerPass.text.trim(),
    );
    await authServices.value.updateusername(username: controllername.text);
    push();
  } on FirebaseAuthException catch (e) {
    setState(() {
      errmsg = e.message ?? "There is an error";
    });
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
            //Name
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
            // email
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
           //password
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
                register();
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