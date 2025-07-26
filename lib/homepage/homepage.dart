import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spotify_clone/controller/Authentication/auth_services.dart';
import 'package:spotify_clone/homepage/Library/Library.dart';
import 'package:spotify_clone/homepage/Search/serch.dart';
import 'package:spotify_clone/homepage/home.dart';
import 'package:spotify_clone/homepage/profile/profile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => HomepageState(); // Remove underscore
}

class HomepageState extends State<Homepage> { // Make it public
  String _profileImageUrl = '';
  int _selectindex = 0;
  List _pages = [
    Home(),
    Search(),
    Library(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    _pages = [Home(), Search(), Library(), Profile()];
    _fetchProfileImageUrl();
  }

  // Add a public method for navigation
  void changeTab(int index) {
    setState(() {
      _selectindex = index;
    });
  }

  Future<void> _fetchProfileImageUrl() async {
    final uid = authServices.value.currentUser?.uid;
    if (uid == null) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('userprofile').doc(uid).get();
      if (mounted && doc.exists) {
        setState(() {
          _profileImageUrl = doc.data()?['profile_image_url'] ?? '';
        });
      }
    } catch (e) {
      print("Error fetching profile image URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 27, 27, 1),
      appBar: AppBar(
        centerTitle: true,
        title: Image(image: Image.asset('Images/Vector.png').image),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          )
        ],
      ),
      body: _pages[_selectindex],
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            backgroundColor: Colors.transparent,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            selectedIndex: _selectindex,
            onTabChange: (index) {
              setState(() {
                _selectindex = index;
              });
            },
            padding: EdgeInsets.all(8.0),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: HugeIcons.strokeRoundedLibraries,
                text: 'Library',
              ),
              GButton(
                leading: CircleAvatar(
                  backgroundImage: _profileImageUrl.isNotEmpty
                      ? NetworkImage(_profileImageUrl)
                      : null,
                  child: _profileImageUrl.isEmpty
                      ? const Icon(Icons.person, size: 18, color: Colors.white70)
                      : null,
                ),
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
