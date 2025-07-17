import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final String url ='https://i.pinimg.com/736x/2b/bc/47/2bbc47578113791e42e1063d39acd9e3.jpg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 27, 27, 1),
      appBar: AppBar(
          
        centerTitle: true, 
      title: Image(image: Image.asset('Images/Vector.png').image),
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.more_vert, color: Color.fromRGBO(255, 255, 255, 1),))
      ],
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: GNav(
            rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
            backgroundColor: Colors.transparent,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            padding: EdgeInsets.all(8.0),
            tabs: [
          
            GButton(icon: Icons.home
                    ,text: 'Home',),
            GButton(icon: Icons.search,
                    text: 'Search',),
            GButton(icon: Icons.library_books,
                    text: 'Library',),
                    GButton(leading: CircleAvatar(
                      backgroundImage: NetworkImage(url),
                    ),icon: Icons.abc_outlined,
                    text: 'Profile',
                    onPressed: (){
                      
                    },)
          ]),
        ),
      ),
      
    );
    
  }
  
}