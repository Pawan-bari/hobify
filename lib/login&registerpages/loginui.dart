import 'package:flutter/material.dart';

class Loginui extends StatefulWidget {
  const Loginui({super.key});

  @override
  State<Loginui> createState() => _LoginuiState();
}

class _LoginuiState extends State<Loginui> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Color.fromRGBO(28, 27, 27, 1),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.popAndPushNamed(context ,'login');
        }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
        centerTitle: true, 
      title: Image(image: Image.asset('Images/Vector.png').image),
      backgroundColor: Colors.transparent,
      ),
      
      body: Center(
        child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100,),
            Text('Sign In',style: TextStyle(color: Colors.white,fontSize: 50,fontWeight: FontWeight.bold),),
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
           Padding(
             padding: const EdgeInsets.only(left: 25, right: 25),
             child: TextField(
              style: TextStyle(color: Colors.white,height: 3),
              decoration: InputDecoration(
                hintText: 'Enter your Email',
                hintStyle: TextStyle(color:  Colors.white),
              border: OutlineInputBorder(
                  
                  borderRadius: BorderRadius.circular(20),
                  
                  borderSide: BorderSide(color: Colors.white)

                )
             
              ),
             ),
             
           ),
            SizedBox(height: 20,),
            Padding(padding: 
            const EdgeInsets.only(left: 25, right: 25),
            child: TextField(
              style: TextStyle(color: Colors.white,height: 3),
              obscureText: true,
              decoration: InputDecoration(
                               
                hintText:   'Enter your Password',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white)
                )
              ),
            )
            ),
            SizedBox(height: 15,),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(padding: EdgeInsets.only(left: 25),
              child: TextButton(onPressed: () {}, child: Text( 'Recovery password',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),),)
              )
            ,
            
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: ElevatedButton(onPressed: (){}, child: Text('Sign In',
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
                Text('Not A Member ? ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                TextButton(onPressed: (){

                  Navigator.pushNamed(context, 'register');
                }, child: Text('Register Now',style: TextStyle(color: Color.fromRGBO(40, 140, 233, 1)),))
              ],
            )

            ],
          
        ),

      ),



      )
    );
  }
}