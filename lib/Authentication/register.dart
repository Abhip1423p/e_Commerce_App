import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}




class _RegisterState extends State<Register> {
  //_ is used here to make it private
  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _confirmpasswordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // we will need a string type variable to store image inside database
  String userImageUrl = "";

  //now we need file type variable for image so we will make  file type variable
  File _imageFile;


  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double _screenHeight = MediaQuery
        .of(context)
        .size
        .height; // to get height


    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [


            SizedBox(height: 10.0,),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage: _imageFile == null ? null : FileImage(
                    _imageFile),
                child: _imageFile == null
                    ? Icon(Icons.add_photo_alternate, size: _screenWidth * 0.15,
                  color: Colors.grey,) :
                // FileImage is used to display image    // it is if statement
                // : indicates else statement strt
                null,

              ),
            ),


            SizedBox(height: 8.0,),
            Form(
              key: _formKey,
              child: Column(
                  children: [


                    CustomTextField( // 4 parameter will passed
                      controller: _nameTextEditingController,
                      data: Icons.person,
                      hintText: "Name",
                      isObsecure: false, // as it is hint so name will be visible for that we need it to make it fasle

                    ),
                    CustomTextField( // 4 parameter will pased
                      controller: _emailTextEditingController,
                      data: Icons.email,
                      hintText: "email",
                      isObsecure: false, // as it is hint so name will be visible for that we need it to make it fasle

                    ),
                    CustomTextField( // 4 parameter will pased
                      controller: _passwordTextEditingController,
                      data: Icons.person,
                      hintText: "Password",
                      isObsecure: true, // as it is hint so name will be visible for that we need it to make it fasle

                    ),
                    CustomTextField( // 4 parameter will pased
                      controller: _confirmpasswordTextEditingController,
                      data: Icons.person,
                      hintText: "Confirm Password",
                      isObsecure: true, // as it is hint so name will be visible for that we need it to make it fasle

                    ),
                  ]
              ),
            ),
            RaisedButton(
              onPressed: () { // create a function to implement save and upload image when pressed button
                uploadAndSaveImage();
              },
              color: Colors.blue,
              child: Text("Sign up",
                style: TextStyle(color: Colors.white)
                ,),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.white,
            )
          ],
        ),

      ),

    );
  }
    Future<void> _selectAndPickImage() async
    {
      _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      // this will send user to his gallery where he can pick and uplood image
      // store in _imageFile
    }


    Future<void> uploadAndSaveImage() async
    {
      //  first check if image is present or not
      if (_imageFile == null) {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(message: "upload slecect an Image File",);
            }

        );
      }
      else {
        _passwordTextEditingController.text ==
            _confirmpasswordTextEditingController.text ?
        _emailTextEditingController.text.isNotEmpty &&
            _passwordTextEditingController.text
                .isNotEmpty && // nested if else statement
            _confirmpasswordTextEditingController.text.isNotEmpty &&
            _nameTextEditingController.text
                .isNotEmpty // if this true  perform upload operation will cal

            ? uploadToStorage() //implement this  function to upload data to database


            : displayDailog("Fill up Complete Details")
// if above condition id failed  display error dialog lets create different function for this


            : displayDailog("Password do not match");
      }
    }


  displayDailog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(message: "upload slecect an Image File",);
        }

    );
  }

  uploadToStorage() async
  {
    showDialog(
        context: context,

        builder: (c) {
          return LoadingAlertDialog(message: " Registering ,Please Wait...",);
        }


    ); // we need unique file name to store data in data base
    // in order to give unique name that  we use data time..
    String imageFileName = DateTime
        .now()
        .microsecondsSinceEpoch
        .toString();

    // storage reference
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        imageFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl =
          urlImage; // here we downloaded image url and assign to userImageIRL
      // NOW along side this data and user name,password and all to store in data base i.e firestore  for that we make a function called register user

      _registerUser();
    }
    );
  }

// firebase authentication
  FirebaseAuth _auth = FirebaseAuth.instance;

  void _registerUser() async
  {
    FirebaseUser firebaseUser;


    await _auth.createUserWithEmailAndPassword(


      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),).then((auth) {
      // if authentication is true or we can say vaild then assing user with thier respective details
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);

      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(message: error.message.toString(),);
          }
      );
    });
    if (firebaseUser != null) { // if below is true send to main home page
      saveInfoToFirebase(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveInfoToFirebase(FirebaseUser fUser) async
  {
    Firestore.instance.collection("users").document(fUser.uid).setData({
      "uid": fUser.uid,
      "email": _emailTextEditingController.text.trim(),
      "name": _nameTextEditingController.text.trim(),
      "url": userImageUrl, //to store url of user image
      EcommerceApp.userCartList: ["garbageValue"],
    }); // create seprate collection data of different users ans store in "users"

    await EcommerceApp.sharedPreferences.setString("uid", fUser.uid);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, fUser.displayName);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,["garbageValue"]);

  }

}
