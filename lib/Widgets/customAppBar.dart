import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      // for back button
        iconTheme : IconThemeData(
          color: Colors.white,

        ),
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

        centerTitle: true, //
        title: Text("E-Shop",
          style: TextStyle(
              fontSize: 55.0,color: Colors.white,fontFamily: ""
              "Signatra"),

        ),
        //
        bottom: bottom,


        actions: [
          Stack(
            children: [
              IconButton(

                icon: Icon(Icons.add_shopping_cart,color: Colors.green,
                ),
                onPressed:(){

                  Route route = MaterialPageRoute(builder: (c) => CartPage());
                  Navigator.pushReplacement(context, route);
                } ,
              ),
              // WE add a postion wiget which will tells us how maney items in our cart

              Positioned(
                child:Stack(
                  children: [
                    Icon(   // round
                      Icons.brightness_1_outlined, size: 20.0,
                      color:Colors.white,
                    ),
                    Positioned(
                      top: 3.0,
                      bottom: 4.0,
                      left: 5.0,
                      child:
                      Consumer<CartItemCounter>(
                        builder: (context, counter, _){
                          return Text(
                            counter.count.toString(),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500,fontSize: 12.0),
                          );

                        },
                      ),
                    )




                  ],
                ),
              ),



            ],
          ),
        ]
    );
  }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
