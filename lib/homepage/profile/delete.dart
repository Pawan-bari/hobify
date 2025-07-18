import 'package:flutter/material.dart';
import 'package:spotify/controller/Authentication/auth_services.dart';

class Delete extends StatefulWidget {
  const Delete({super.key});

  @override
  State<Delete> createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  TextEditingController contolleremail = TextEditingController();
  TextEditingController contollerepass = TextEditingController();
  final formkey = GlobalKey<FormState>();
  String errmsg = '';
  
  
   @override
 
  void dispose() { 
    contolleremail.dispose();
    contollerepass.dispose();
    super.dispose();
    
  }

void delete()async{
  try {
     await authServices.value.deleteaccount(email: contolleremail.text, pass: contollerepass.text);
     
   
     snakebar();
     poppage();
  } catch (e) {
    print(e.toString()); 
  }
}
 void snakebar(){
    ScaffoldMessenger.of(context).clearMaterialBanners();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,
    content: Text('Accout Deleted'), 
    showCloseIcon: true,)
    );
  }
  void poppage(){
    Navigator.popAndPushNamed(context, 'loginui');

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 27, 27, 1),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.popAndPushNamed(context, 'homepage');
        }, icon: Icon( Icons.arrow_back_ios_new,color: Colors.white,))
        ,backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80,),
            Text('Delete Account',style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),)
            ,SizedBox(height: 5,)
            ,Image.asset('Images/re.png',height: 100,),
            SizedBox(height: 50,)
            ,Padding(
              padding: const EdgeInsets.only(left: 25 , right: 25),
              child: TextField(
                controller: contolleremail,
                style: TextStyle(color: Colors.white) ,
                decoration: InputDecoration(
                                 
                  hintText:   'Enter new email',
                  hintStyle: TextStyle(color: Colors.white,height: 3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white)
                    
                  )
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 25 , right: 25),
              child: TextField(
                controller: contollerepass,
                  style: TextStyle(color: Colors.white) ,
                  decoration: InputDecoration(
                                   
                    hintText:   'Enter new Passeord',
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
              padding: const EdgeInsets.only(top: 120,left: 25,right: 25),
              child: ElevatedButton(onPressed: (){
                       delete();
                }, child: Text('Delete Account',
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