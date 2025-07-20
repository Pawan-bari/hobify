import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Pawan',style: TextStyle(fontSize: 50,color: Colors.white),)
          ,ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, 'player');
          }, child: Icon(Icons.arrow_back)) 
        ],
      ) ,
    );
  }
}