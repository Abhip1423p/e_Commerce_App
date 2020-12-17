import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:e_shop/Config/config.dart';


class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length:  2,    // as here we have to tabs login and register
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.blue,Colors.tealAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const  FractionalOffset(1.1, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text("E-Shop",
            style: TextStyle(
                fontSize: 50.0,color: Colors.white
            ),


          ),

          centerTitle: true, //
          // add two tab bar one for login and registration
          bottom: TabBar(tabs: [

            Tab(
              icon : Icon(Icons.lock, color: Colors.white,),
              text: "Login",

            ),
            Tab(
              icon : Icon(Icons.perm_contact_calendar, color: Colors.white,),
              text: "Register",

            )

          ],  // a line which tells us when we swap between it act as an indicater
            indicatorColor: Colors.white38,
            indicatorWeight: 5.0 , // thickness we can say

          ),

        ),
        // app bar end here now we will add container  login and register page
        body: Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.blue,Colors.tealAccent],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,

              ),
            ),
            child: TabBarView(
              children: [
                Login(),
                Register(),
              ],
            )
        ),
      ),
    );
  }
}