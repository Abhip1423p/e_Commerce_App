import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}





class _LoginState extends State<Login>
{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController =TextEditingController();
  final TextEditingController _passwordTextEditingController =TextEditingController();



  Widget build(BuildContext context)
  {
    double _screenWidth = MediaQuery.of(context).size.width;


    return SingleChildScrollView(
      child: Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  "images/login.png",
                  height: 240.0,
                  width: 240.0,

                ),
              ),

              Padding(padding: EdgeInsets.all(8.0),
                child: Text(

                  "Login ",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              // we need to now add our form widget which contain email and password





              Form(
                key: _formKey,
                child: Column(
                    children: [

                      CustomTextField(   // 4 parameter will pased
                        controller: _emailTextEditingController,
                        data: Icons.email,
                        hintText: "email",
                        isObsecure: false,// as it is hint so name will be visible for that we need it to make it fasle

                      ),
                      CustomTextField(   // 4 parameter will pased
                        controller: _passwordTextEditingController,
                        data: Icons.person,
                        hintText: "Password",
                        isObsecure: false ,// as it is hint so name will be visible for that we need it to make it fasle

                      ),

                    ]
                ),
              ),

// login button raised button
              RaisedButton(
                onPressed: () {        // create a function to login on pressed button
                  _emailTextEditingController.text.isNotEmpty &&
                      _passwordTextEditingController.text.isNotEmpty
                      ? loginUser()
                      : showDialog(
                      context:context,
                      builder: (c){
                        return ErrorAlertDialog(message: "Please write email or password.",);
                      }
                  );
                },
                color: Colors.blue,
                child: Text("Login",
                  style: TextStyle(color: Colors.white)
                  ,),
              ),
              SizedBox(
                height: 50.0,
              ),
              Container(
                height: 4.0,
                width: _screenWidth *0.8,
                color: Colors.white,
              ),
              SizedBox(
                height: 10.0,
              ),

              FlatButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminSignInPage())),
                icon:(Icon (Icons.nature_people, color: Colors.blue,)),
                label: Text("I am Admin",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]
        ),

      ),


    );


  }
  FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser() async
  {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Authentication, Please Wait..",);
        }
    );

    FirebaseUser firebaseUser; // instance for firebase user
    await _auth.signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    ).then((authUser){
      firebaseUser =authUser.user;
    }) .catchError((error) {
      Navigator.pop(context);

      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(message: error.message.toString(),);
          }
      );
    });
// after this we have to read data from data base who is sign in  using firebase authentication
    if(firebaseUser !=null){

      readData(firebaseUser).then((s){
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      }) ;

    }

  }


  Future readData(FirebaseUser fUser) async
  {
    Firestore.instance.collection("users").document(fUser.uid).get().then((dataSnapshot)   // get is used to get data from database
    async {
      await EcommerceApp.sharedPreferences.setString("uid", dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, dataSnapshot.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, dataSnapshot.data[EcommerceApp.userAvatarUrl]);


      //    List<String> CartList = dataSnapshot.data[EcommerceApp.userCartList].cast<String>();

      //   await EcommerceApp.sharedPreferences.setString(EcommerceApp.userCartList, CartList);   //[] is used for list in dart

    });
  }
}
