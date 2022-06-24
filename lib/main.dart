import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seip_day50/provider/category_provider.dart';
import 'package:seip_day50/provider/order_provider.dart';
import 'package:seip_day50/provider/product_provider.dart';
import 'package:seip_day50/screen/login_page.dart';
import 'package:seip_day50/screen/registration_page.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<OrderProvider>(
        create: (_) => OrderProvider(),
      ),
//

      ChangeNotifierProvider<CategoryProvider>(
        create: (_) => CategoryProvider(),
      ),
      //


      ChangeNotifierProvider<ProductProvider>(
        create: (_) => ProductProvider(),
      ),

    ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: RegistrationPage(),
      home: LoginPage(),
    );
  }
}
