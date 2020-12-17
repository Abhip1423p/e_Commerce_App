import 'dart:ui';

import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0,bottom: 10.0),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.blue,Colors.tealAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const  FractionalOffset(1.1, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  elevation: 8.0,
                  child: Container(
                    height: 160.0,
                    width: 160.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl)
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),


                Text(
                EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                  style: TextStyle(
                    color: Colors.teal, fontSize: 30.0, fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),  // THIS WILL OUR DRAWER HEADER
          // now add our button which we need in our drawe for that we we take sized box
          SizedBox(height: 12.0,),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.blue,Colors.tealAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const  FractionalOffset(1.1, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.home,color: Colors.white,),
                    title: Text("Home",style: TextStyle(
                        color: Colors.white
                    ),
                    ),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (c) => StoreHome());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  // a divider horizontal line
                  Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
                  // by the here i have completed for home .
                  // for new option
                  ListTile(
                    leading: Icon(Icons.reorder,color: Colors.white,),
                    title: Text("My Oders",style: TextStyle(
                        color: Colors.white
                    ),
                    ),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (c) => MyOrders());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  // a divider horizontal line
                  Divider(height: 10.0,color: Colors.white,thickness: 6.0,),



                  ListTile(
                    leading: Icon(Icons.shopping_bag,color: Colors.white,),
                    title: Text("My Cart",style: TextStyle(
                        color: Colors.white
                    ),
                    ),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (c) => CartPage());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  // a divider horizontal line
                  Divider(height: 10.0,color: Colors.white,thickness: 6.0,),








                  ListTile(
                    leading: Icon(Icons.search,color: Colors.white,),
                    title: Text(" Search",style: TextStyle(
                        color: Colors.white
                    ),
                    ),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (c) => SearchProduct());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  // a divider horizontal line
                  Divider(height: 10.0,color: Colors.white,thickness: 6.0,),


                  // FOR LOG OUT
                  ListTile(
                    leading: Icon(Icons.exit_to_app,color: Colors.white,),
                    title: Text(" Logout ",style: TextStyle(
                        color: Colors.white
                    ),
                    ),
                    onTap: (){
                      EcommerceApp.auth.signOut().then((c){
                        Route route = MaterialPageRoute(builder: (c) => AuthenticScreen());
                        Navigator.pushReplacement(context, route);




                      } );

                    },
                  ),
                  // a divider horizontal line
                  Divider(height: 10.0,color: Colors.white10,thickness: 6.0,),



                ]
            ),

          )

        ],

      ),
    );
  }
}
