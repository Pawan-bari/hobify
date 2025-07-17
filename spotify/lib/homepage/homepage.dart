import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 27, 27, 1),
      appBar: AppBar(
          leading: IconButton(onPressed: (){
          Navigator.pop(context , 'login');
        }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
        centerTitle: true, 
      title: Image(image: Image.asset('Images/Vector.png').image),
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.more_vert, color: Color.fromRGBO(255, 255, 255, 1),))
      ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

          ],
        ),
      ),
      
    );
    
  }
}