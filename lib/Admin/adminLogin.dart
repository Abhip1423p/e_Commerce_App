import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';



class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.blue, Colors.tealAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.1, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text(
            "E-Shop",
            style: TextStyle(
                fontSize: 55.0,
                color: Colors.white,
                fontFamily: ""
                    "Signatra"),
          ),
          centerTitle: true, //
          // add two tab bar one for login and registration
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                text: "Login",
              ),
              Tab(
                icon: Icon(
                  Icons.perm_contact_calendar,
                  color: Colors.white,
                ),
                text: "Register",
              )
            ], // a line which tells us when we swap between it act as an indicater
            indicatorColor: Colors.white38,
            indicatorWeight: 5.0, // thickness we can say
          ),
        ),
        body: AdminSignInScreen(),
      ),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _adminIDTextEditingController =
  TextEditingController();
  final TextEditingController _passwordTextEditingController =
  TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.blue, Colors.tealAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.1, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "images/admin.png",
              height: 240.0,
              width: 240.0,
            ),
          ),

          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Admin ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // we need to now add our form widget which contain email and password

          Form(
            key: _formKey,
            child: Column(children: [
              CustomTextField(
                // 4 parameter will pased
                controller: _adminIDTextEditingController,
                data: Icons.person,
                hintText: "id",
                isObsecure:
                false, // as it is hint so name will be visible for that we need it to make it fasle
              ),
              CustomTextField(
                // 4 parameter will pased
                controller: _passwordTextEditingController,
                data: Icons.person,
                hintText: "password",
                isObsecure:
                false, // as it is hint so name will be visible for that we need it to make it fasle
              ),
            ]),
          ),

// login button raised button
          RaisedButton(
            onPressed: () {
              // create a function to login on pressed button
              _adminIDTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty
                  ? loginAdmin()
                  : showDialog(
                  context: context,
                  builder: (c) {
                    return ErrorAlertDialog(
                      message: "Please write id or password.",
                    );
                  });
            },
            color: Colors.blue,
            child: Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Container(
            height: 4.0,
            width: _screenWidth * 0.8,
            color: Colors.white,
          ),
          SizedBox(
            height: 20.0,
          ),

          FlatButton.icon(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => AuthenticScreen())),
            icon: (Icon(
              Icons.nature_people,
              color: Colors.blue,
            )),
            label: Text(
              "I am not Admin",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
        ]),
      ),
    );
  }

  loginAdmin() {
    // i made an admin in firebase now here i need just an instance   in our firestore i have made an folder called admins where i have store all the information about admins

    Firestore.instance.collection("admins").getDocuments().then((snapshot) {
      // this we get all the Docouments from the firestore and store in result now check all things
      snapshot.documents.forEach((result) {

        if (result.data["id"] != _adminIDTextEditingController.text.trim())
        {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("your id is incorrect."),
          ));
        } else if (result.data["password"] !=
            _passwordTextEditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("your password is incorrect."),
          ));
        }
        else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Welcome Dear Admin," + result.data["name"]),
          ));
          setState(() {
            _adminIDTextEditingController.text = " ";
            _passwordTextEditingController.text = " ";
          });

          // after seting sate i will send user to upload page // crated for admim to upload items
          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
