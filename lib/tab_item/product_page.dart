import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_switch/flutter_switch.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:seip_day50/http/custome_http_request.dart';
import 'package:seip_day50/provider/category_provider.dart';
import 'package:seip_day50/provider/product_provider.dart';
import 'package:seip_day50/screen/add_product.dart';
import 'package:seip_day50/screen/edit_product.dart';
import 'package:seip_day50/widget/brand_colors.dart';
import 'package:seip_day50/widget/widget.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  bool? visible;
  bool? available;
  bool onProgress = false;
  bool showFav = true;



  Future<void> availabilityUpdate(int id) async {
    setState(() {
      onProgress = true;
    });
    final uri = Uri.parse(
        "https://apihomechef.antopolis.xyz/api/admin/product/update/available/status/$id");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequest().getHeaderWithToken());
    var response = await request.send();
    if (response.statusCode == 200) {
      showInToast("Product Status Update Successfull");
      setState(() {
        onProgress = false;
      });
    } else {
      showInToast("Something wrong, Pls try again");
      setState(() {
        onProgress = false;
      });
    }
  }




  Future<void> visibilityUpdate(BuildContext context, int id) async {
    setState(() {
      onProgress = true;
    });
    print(id);
    final uri = Uri.parse(
        "https://apihomechef.antopolis.xyz/api/admin/product/update/visible/status/$id");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequest().getHeaderWithToken());
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("responseBody " + responseString);
    print('responseStatus ${response.statusCode}');
    if (response.statusCode == 200) {
      print("responseBody1 " + responseString);
      var data = jsonDecode(responseString);
      print('oooooooooooooooooooo');
      print(data['message']);
      showInToast(data['message']);
      setState(() {
        onProgress = false;
      });
    } else {
      setState(() {
        onProgress = false;
      });
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    //fetchOrderData();
    //Provider.of<ProductProvider>(context, listen: false).getProductData();
    final productsData = Provider.of<ProductProvider>(context, listen: false);
    productsData.getProductData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final product  = Provider.of<ProductProvider>(context);
    /////
    //final category  = Provider.of<CategoryProvider>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,

        child: product.productList.isNotEmpty ?
        GridView.builder(
            itemCount: product.productList.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 6,mainAxisSpacing: 14),
            itemBuilder: (context,index){
              //var items = grid_item[index];

              ///////
              String productVisible = product.productList[index].isVisible.toString();
              String productAvailable = product.productList[index].isAvailable.toString();
              print('product discount type:  ${product.productList[index].price![0].discountType}');

              visible = productVisible == '1'
                  ? true
                  : productVisible == '0'
                  ? false
                  : false;
              available = productAvailable == '1'
                  ? true
                  : productAvailable == '0'
                  ? false
                  : false;

              ////////



              return Padding(
                padding: const EdgeInsets.only(left: 14,right: 14),
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[400],
                  ),


                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Stack(
                          children: [
                            Image.network("https://apihomechef.antopolis.xyz/images/${product.productList[index].image ?? ""}",
                              height: 122,width: double.infinity,fit: BoxFit.cover,),


                            Positioned(
                              right: 0,
                              child: IconButton(onPressed: (){

                                //showModalBottomSheet
                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: Colors.white,
                                    context: context, builder: (context){
                                  return Container(
                                    height: 250,
                                    child: Column(
                                      children: [

                                        Icon(Icons.remove,size: 50,),
                                        SizedBox(height: 20,),

                                        InkWell(
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProduct(
                                              //categoryModel: category.categoryList[index],
                                              productModel: product.productList[index],
                                              //////
                                              //categoryModel: category.categoryList[index],
                                            )));
                                          },
                                          child: ListTile(
                                            leading: Icon(Icons.edit,color: Colors.black,),
                                            title: Text("Edit Product"),
                                            //trailing: Icon(Icons.edit,color: Colors.amber,),
                                          ),
                                        ),

                                        InkWell(
                                          onTap: (){
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(13.0)),
                                                    title: Text(
                                                      "Are You Sure ?",
                                                      style: myStyle(16, Colors.white, FontWeight.w500),
                                                    ),
                                                    content: Text("Once you delete, the item will gone permanently."),
                                                    titlePadding:
                                                    EdgeInsets.only(top: 30, bottom: 12, right: 30, left: 30),
                                                    contentPadding: EdgeInsets.only(
                                                      left: 30,
                                                      right: 30,
                                                    ),
                                                    backgroundColor: BrandColors.colorPrimaryDark,
                                                    contentTextStyle: myStyle(
                                                        14, BrandColors.colorText.withOpacity(0.7), FontWeight.w400),
                                                    titleTextStyle: myStyle(18, Colors.white, FontWeight.w500),
                                                    actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                                    actions: <Widget>[
                                                      MaterialButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop(false);
                                                          },
                                                          child: Text(
                                                            "Cancel",
                                                            style: myStyle(14, BrandColors.colorText),
                                                          )),
                                                      MaterialButton(
                                                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(8.0)),
                                                        color: Colors.red,
                                                        child: Text(
                                                          'Delete',
                                                          style: myStyle(14, Colors.white, FontWeight.w500),
                                                        ),


                                                        //delete item
                                                        onPressed: () async {
                                                          setState(() {
                                                            onProgress = true;
                                                          });

                                                          await CustomHttpRequest.deleteProduct(product.productList[index].id!.toInt());

                                                          setState(() {
                                                            onProgress = false;
                                                            product.productList.removeAt(index);
                                                          });
                                                          Navigator.pop(context);

                                                        }, //delete item



                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: ListTile(
                                            leading: Icon(Icons.delete,color: Colors.black,),
                                            title: Text("Delete Product"),
                                            //trailing: Icon(Icons.edit,color: Colors.amber,),
                                          ),
                                        ),


                                      ],
                                    ),
                                  );
                                });//showModalBottomSheet


                              }, icon: Icon(Icons.more_vert,color: Colors.white,),),
                            )
                          ],
                        ),
                      ),



                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5,),
                              Text("${product.productList[index].name ?? ""}",style: TextStyle(color: Colors.black),),


                              //SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("${product.productList[index].price![0].originalPrice ?? ""}",style: TextStyle(color: Colors.red),),
                                  SizedBox(width: 10,),
                                  Text("${product.productList[index].price![0].discountedPrice ?? ""}",style: TextStyle(fontSize: 14,color: Colors.black,
                                      fontWeight: FontWeight.w600),),
                                ],
                              ),


                              Text("Quantity: ${product.productList[index].stockItems![0].quantity ?? ""}",style: TextStyle(color: Colors.black),),
                            ],
                          ),



                          //Text("${product.productList[index].stockItems![0].quantity ?? ""}",style: TextStyle(color: Colors.black),),

                          Container(
                            width: 50,
                            height: 30,
                            child:
                            FlutterSwitch(
                              width: 125.0,
                              height: 55.0,
                              valueFontSize:
                              25.0,
                              toggleSize: 45.0,
                              value: available!,
                              borderRadius:
                              30.0,
                              padding: 8.0,
                              showOnOff: true,
                              onToggle: (val) {
                                available = val;

                                print(
                                    "$available");
                                int? productId =
                                    product
                                        .productList[
                                    index]
                                        .id;

                                availabilityUpdate(
                                    productId!)
                                    .then(
                                      (value) =>
                                      product.getProductData(),
                                );
                              },
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              );
            }) : CircularProgressIndicator(),




        /*ListView.builder(
            shrinkWrap: true,
            itemCount: product.productList.length,
            itemBuilder: (context,index){

              return Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),

                child: Text('${product.productList[index].price![0].originalPrice ?? ""}',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              );
        }),*/
      ),



      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          /*Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct())).then((value) =>
              Provider.of<ProductProvider>(context, listen: false));*/
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddProduct()))
              .then((value) => product.getProductData());
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add,color: Colors.amber,size: 30,),
      ),


    );
  }
}
