import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:seip_day50/http/custome_http_request.dart';
import 'package:seip_day50/model/order_model.dart';
import 'package:seip_day50/provider/order_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  @override
  void initState() {
    // TODO: implement initState
    //fetchOrderData();
    Provider.of<OrderProvider>(context, listen: false).getOrderData();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    final orders = Provider.of<OrderProvider>(context).orderData;

    return Scaffold(

      appBar: AppBar(

        backgroundColor: Colors.amber,
        title: Text("Total Order: ${orders.length}"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: orders.isNotEmpty ?
        ListView.builder(
            itemCount: orders.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  //width: (MediaQuery.of(context).size.width),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("User Name: ${orders[index].user!.name}"),
                            SizedBox(height: 10,),
                            Text("Order Status: ${orders[index].orderStatus!.orderStatusCategory!.name}"),
                            SizedBox(height: 10,),
                            Text("Price: ${orders[index].price}"),


                          ],
                        ),


                        Text("Payment\nStatus:"),
                        orders[index].payment!.paymentStatus == 1
                            ?const Text("Done",style: TextStyle(color: Colors.green),)
                             : const Text("Due",style: TextStyle(color: Colors.red),),

                        // Text("Payment\nStatus: ${categories[index].payment!.paymentStatus == 1?
                        // Text("Done",style: TextStyle(color: Colors.green),)
                        //     : Text("Due",style: TextStyle(color: Colors.red),)}"),

                      ],
                    ),
                  ),
                  //Text("${orderData[index].orderStatus!.orderStatusCategory!.name}"),
                ),
              );
            }): CircularProgressIndicator(),
      ),
    );
  }
}
