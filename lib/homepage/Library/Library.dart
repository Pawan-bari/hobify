import 'package:flutter/material.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
      children: [
          Text('Pawan',style: TextStyle(fontSize: 50,color: Colors.white),)
          ,ElevatedButton(onPressed: (){
           
          }, child: Icon(Icons.arrow_back)) 
        ],),
    );
  }
}