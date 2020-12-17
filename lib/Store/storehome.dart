import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';


double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
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
                fontSize: 55.0,color: Colors.white,fontFamily: ""
                "Signatra"),

          ),
          centerTitle: true, //
          // icon for cart in side of appbar by "action" stack
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
                        Icons.brightness_1, size: 20.0,
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

          ],
        ),
        // drawer a drop down menu
        drawer: MyDrawer( ) , // Mydrawer in wigets where we can edit),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true,  delegate: SearchBoxDelegate()), // this searchboxdekigate is presnt in serach box .dart

            StreamBuilder<QuerySnapshot>(

                stream: Firestore.instance.collection("items").limit(15).orderBy("publishedDate",descending: true).snapshots(),  // which item to showed first first acc to publish date in descending order
                builder:(context,dataSnapshot){
                  return ! dataSnapshot.hasData
                      ? SliverToBoxAdapter(child: Center( child: circularProgress(),),)

                      : SliverStaggeredGrid.countBuilder(
                    crossAxisCount:1,
                    staggeredTileBuilder: (c) =>StaggeredTile.fit(1),

                    itemBuilder:(context, index){
                      ItemModel model = ItemModel.fromJson(dataSnapshot.data.documents[index].data);
                      return sourceInfo(model, context);
                    } ,

                    itemCount: dataSnapshot.data.documents.length,

                  );
                }
            ),



          ],

        ),
      ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: (){
      // when tab on product..send to product details ..route this


      Route route = MaterialPageRoute(builder: (c) =>ProductPage( itemModel: model));// we pass information to product page as we want particular product info)
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.blueAccent,
    child: Padding(padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: width,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl, width: 140.0,height: 140.0,),
            SizedBox(width: 4.0,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.0,),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(model.title,style: TextStyle(color:Colors.black,fontSize : 14.0),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0,),
















                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(

                        child: Text(model.price.toString() ,style: TextStyle(color:Colors.black,fontSize : 14.0),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0,),














                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(model.shortInfo,style: TextStyle(color:Colors.black54,fontSize : 12.0),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0,),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.blueAccent,


                      ),
                      alignment: Alignment.topLeft,
                      width: 40.0,
                      height: 43.0,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              " 50%",style: TextStyle(
                              color: Colors.white,fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                            ),

                            ),
                            Text(
                              " OF",style: TextStyle(
                              color: Colors.white,fontSize: 12.0,
                              fontWeight: FontWeight.normal,
                            ),

                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding:
                        EdgeInsets.only(top: 0.0),
                          child: Row(
                            children: [
                              Text(
                                r"Original Price: ₹  ",

                                style: TextStyle(
                                  fontSize:14.0,
                                  color: Colors.grey,
                                  // decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                (model.price.toString() + model.price.toString()),

                                style: TextStyle(
                                  fontSize:15.0,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),

                        )  ,



                        Padding(padding:
                        EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Text(
                                r"new Price :",
                                style: TextStyle(
                                  fontSize:14.0,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "₹ ",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 16.0
                                ),
                              ),

                              Text(

                                (model.price).toString(),
                                style: TextStyle(
                                  fontSize:15.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                        )  ,




                      ],
                    )


                  ],
                ),
                Flexible(
                  child:Container(
                  ),
                )
                // to implement cart item remove feature

               


              ],

            ),),
          ],
        ),
      ),
    ),

  );
}



Widget card({Color primaryColor = Colors.green, String imgPath}) {
  return Container();
}



void checkItemInCart(String productID, BuildContext context)
{
}
