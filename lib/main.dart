import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Counters/itemQuantity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  EcommerceApp.auth =FirebaseAuth.instance; // define in config ...
  EcommerceApp.sharedPreferences = await  SharedPreferences.getInstance();
  // intilization of firestore instance
  EcommerceApp.firestore = Firestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return   MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (C) =>CartItemCounter()),

       ChangeNotifierProvider(create: (C) =>CartItemCounter()),

        ChangeNotifierProvider(create: (C) =>AddressChanger()),

        ChangeNotifierProvider(create: (C) =>TotalAmount()),



      ],
      child:  MaterialApp(

          title: "e-Shop",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.green,
          ),
          home: SplashScreen()
      )
    );
  }
}
class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>
{ @override
void initState() {
  // TODO: implement initState
  super.initState();
  displaySplash();
}
displaySplash()
{
  Timer(Duration(seconds: 5),() async{
    if(await EcommerceApp.auth.currentUser()
        !=null){
      // this means this user is already  have login  and  already logged in that case we have to send user to home

      Route route = MaterialPageRoute(builder: (_) => StoreHome());
      Navigator.pushReplacement(context, route);
    }

    else{


      Route route = MaterialPageRoute(builder: (_) => AuthenticScreen()); // if user not logged in send him  to authentication screen
      Navigator.pushReplacement(context, route);


    }

  });
}



@override
Widget build(BuildContext context) {
  return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.blue,Colors.tealAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const  FractionalOffset(1.1, 0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/welcome.png"),   // this will be our welcome screen
              SizedBox(height: 20.0,),
              Text("welcome to e shop",
                  style: TextStyle(color: Colors.white,fontSize: 30)
              ),
            ],

          ) ,
        ),
      )
  );
}
}
