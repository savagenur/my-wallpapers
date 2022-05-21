import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_wallpapers/views/home.dart';
import 'package:my_wallpapers/widgets/info_widget.dart';
import 'package:my_wallpapers/widgets/widget.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({ Key? key }) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();




  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xff4B4453),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Home()));
              },
            );
          },
        ),
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: BrandName(
          account: true,
        ),
        elevation: 0,
      ),
      body: Container(
alignment: Alignment.topCenter,

margin: EdgeInsets.all(30),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoWidget(title: "Name", text: FirebaseAuth.instance.currentUser!.displayName.toString()),
            SizedBox(height: 10,),
            InfoWidget(title: "Uid", text: FirebaseAuth.instance.currentUser!.uid.toString()),
            SizedBox(height: 10,),
            InfoWidget(title: "Email", text: FirebaseAuth.instance.currentUser!.email.toString()),
            SizedBox(height: 10,),
            
          ],
        ),
      ),
    );
  }
}