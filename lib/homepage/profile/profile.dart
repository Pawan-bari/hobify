import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotify/controller/Authentication/auth_services.dart';
import 'package:spotify/controller/databa/firestore.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
 Uint8List? _pickedImageBytes;
 TextEditingController controllername = TextEditingController();
  
  // This future fetches the user's profile from Firestore
  Future<Map<String, dynamic>?>? _userProfileFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the profile data when the screen loads
    _userProfileFuture = _getUserProfile();
  }

  // --- Main onTap Method ---
  
  /// This is called when the user taps the profile picture.
  Future<void> onprofiletao() async {
    // 1. Pick an image from the gallery
    final ImagePicker pic = ImagePicker();
    final XFile? image = await pic.pickImage(source: ImageSource.gallery, imageQuality: 70);
    
    // If the user doesn't pick an image, do nothing
    if (image == null) return;

    // 2. Call the new method to handle the upload and database update
    await _uploadAndSaveImage(image);
  }

  // --- New Method for Uploading and Saving ---

  /// This new method contains all the logic for uploading and saving the image.
  Future<void> _uploadAndSaveImage(XFile imageFile) async {
    final userId = authServices.value.currentUser?.uid;
    if (userId == null) return; // Make sure user is logged in

    try {
      final imageBytes = await imageFile.readAsBytes();

      // Show the picked image in the UI immediately
      setState(() {
        _pickedImageBytes = imageBytes;
      });

      // Create a unique path using the user's UID
      final ref = FirebaseStorage.instance.ref('profile_pictures/$userId.jpg');
      await ref.putData(imageBytes);

      // Get the public download URL
      final imageUrl = await ref.getDownloadURL();

      // Save the URL to the user's profile in Firestore
          await Storedata().updateUserProfileImage(uid: userId, imageUrl: imageUrl);


    } catch (e) {
      print("Error uploading image: $e");
      // If something goes wrong, remove the locally picked image
      setState(() {
        _pickedImageBytes = null;
      });
    }
  }

  // --- Helper Method to Fetch Data ---

  Future<Map<String, dynamic>?> _getUserProfile() async {
    final uid = authServices.value.currentUser?.uid;
    if (uid == null) return null;
    try {
      final doc = await FirebaseFirestore.instance.collection('userprofile').doc(uid).get();
      return doc.data();
    } catch (e) {
      print("Error fetching profile: $e");
      return null;
    }
  }
  
  
  
@override
  Widget build(BuildContext context) {
   
  
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(28, 27, 27, 1),
        body: Center ( 
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
              child: 
            Text('My Profile',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold,),textAlign: TextAlign.start,),
              )
              ,SizedBox(height: 5,)
              ,Align(
                alignment: Alignment.topLeft
            ,child: Container(
                height: 5,
                    width:50,
                    
                    
            )
              ),
              SizedBox(height: 10,),

              Container(
                height: 200,
                width: 380,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 5
                ),
                borderRadius: BorderRadius.circular(20),
                
              ),
              
                
                child: Column
                (
                  
                 children: [
                  Column(
                    children: [
                      GestureDetector(
                      onTap: onprofiletao, // The onTap still calls your original method
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade800,
                        backgroundImage: _pickedImageBytes != null
                            ? MemoryImage(_pickedImageBytes!)
                            : null,
                        child: _pickedImageBytes == null
                            ? FutureBuilder<Map<String, dynamic>?>(
                                future: _userProfileFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator(color: Colors.green);
                                  }
                                  final imageUrl = snapshot.data?['profile_image_url'];
                                  if (imageUrl != null && imageUrl.isNotEmpty) {
                                    return CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(imageUrl),
                                    );
                                  }
                                  return const Icon(Icons.person, size: 50, color: Colors.white70);
                                },
                              )
                            : null,
                      ),
                    ),
                                     Text(authServices.value.currentUser!.displayName ?? 'Default'
                                    ,style: TextStyle(color: Colors.white,fontSize: 30),),
                                   
                                   Text(authServices.value.currentUser!.email ?? 'email' ,style: TextStyle(color: Colors.white70),)
                           
                    ],
                  )]
            )
              ),
              
              SizedBox(height: 10,)
              ,Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft
                  ,child: 
                Text('SETTING',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),)
                          ),
              
              ),
              SizedBox(height: 10,),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: ListTile(
                             title: Text('Update username',style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255),fontWeight: FontWeight.bold,fontSize: 20),),
                         
                             selected: true,
                             onTap: (){
                              Navigator.pushNamed(context, 'updateusername');
                             },
                             
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(20)
                             ),
                           ),
               ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: ListTile(
                               title: Text('Delete Account',style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255),fontWeight: FontWeight.bold,fontSize: 20),),
                           
                               selected: true,
                               onTap: (){
                                Navigator.pushNamed(context, 'delete');
                               },
                               
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(20)
                               ),
                             ),
               ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text('Logout',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),),
            selectedColor: Colors.red,
            selected: true,
            onTap: (){
              popup();
            },
            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
          ),
          
        ),
         
              ]
        ))
      ),
    );
  }
  void popup(){
     showDialog(
        context: context,
        useSafeArea: true,
        barrierDismissible: false,
        builder: (context) {
        return AlertDialog(
           title: Text('Logout'),
           content: Text('Are u sure you want to logout?'),
           buttonPadding: EdgeInsets.all(8),
           actions: [
            Row(
              children: [
                
                ElevatedButton(onPressed: (){
                  logout22();
                }, child: Text('Logout'),
                
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                foregroundColor: Colors.black), ),
                SizedBox(width: 30,),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child:  Text('cancle'),
                
                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,
                foregroundColor: Colors.green), )],
              
            )
           
           ],
           );
         },
       );
  }
  
  void logout22()async{
    try  {
      await authServices.value.signout();
      
      poppage();
    } on FirebaseException catch (e) {
       print(e.message);
    }
  }
  
  void poppage() {
    Navigator.popAndPushNamed(context,'/getting-started');
  }
  



}