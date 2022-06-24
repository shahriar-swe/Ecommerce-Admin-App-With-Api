import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:seip_day50/http/custome_http_request.dart';
import 'package:seip_day50/model/category_model.dart';
import 'package:seip_day50/model/product_model.dart';
import 'package:seip_day50/widget/brand_colors.dart';
import 'package:seip_day50/widget/widget.dart';

class EditProduct extends StatefulWidget {
  EditProduct({Key? key,this.productModel}) : super(key: key);


  ProductModel? productModel;
  //CategoryModel? categoryModel;

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {



  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  ///////
  //TextEditingController idController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController originalPriceController = TextEditingController();
  TextEditingController discountedPriceController = TextEditingController();
  TextEditingController discountTypeController = TextEditingController();
  TextEditingController percentOfController = TextEditingController();
  TextEditingController fixedValueController = TextEditingController();


  String? fildName,fildId,fildQuantity,fildOriginalPrice,fildDiscountedPrice,fildDiscountType,fildPercentOf,fildFixedValue;
  //int? fildId,fildQuantity,fildOriginalPrice,fildDiscountedPrice,fildFixedValue;
  //int? fildId;
  bool onProgress = false;
  bool isVisiable = false;
  bool isImageVisiable = false;

  File? image;
  final picker = ImagePicker();

/////
  String? categoryType;

  List? categoryList;

  Future<dynamic> getCategory() async {
    setState(() {
      onProgress = true;
    });
    await CustomHttpRequest.getCategoriesDropDown().then((responce) {
      var dataa = json.decode(responce.body);
      setState(() {
        categoryList = dataa;
        onProgress = false;
        print("all categories are : $categoryList");
      });
    });
  }

  /////

  @override
  void initState() {
    // TODO: implement initState
    nameController = TextEditingController(text: widget.productModel!.name);
    //idController = TextEditingController(text: widget.productModel!.id.toString());
    //categoryType = TextEditingController(text: widget.productModel!.id.toString());
    quantityController = TextEditingController(text: widget.productModel!.stockItems![0].quantity.toString());
    originalPriceController = TextEditingController(text: widget.productModel!.price![0].originalPrice.toString());
    discountedPriceController = TextEditingController(text: widget.productModel!.price![0].discountedPrice.toString());
    discountTypeController = TextEditingController(text: widget.productModel!.price![0].discountType);
    percentOfController = TextEditingController(text: widget.productModel!.price![0].percentOf.toString());
    fixedValueController = TextEditingController(text: widget.productModel!.price![0].fixedValue.toString());

    //////
    getCategory();
    /////

    super.initState();
  }




  Future getImageformGallery() async {
    print('on the way of gallery');
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        image = File(pickedImage.path);
        print('image found');
        print('$image');
        setState(() {
          isImageVisiable = true;
        });
      } else {
        print('no image found');
      }
    });
  }




  Future editProduct() async {
    setState(() {
      onProgress = true;
    });

    final uri = Uri.parse("https://apihomechef.antopolis.xyz/api/admin/product/${widget.productModel!.id}/update");
    var request = http.MultipartRequest("POST", uri);


    request.headers.addAll(
      await CustomHttpRequest().getHeaderWithToken(),
    );


    request.fields['name'] = nameController.text.toString();
    //request.fields['category_id'] = idController.text.toString();
    request.fields['category_id'] = categoryType.toString();
    request.fields['quantity'] = quantityController.text.toString();
    request.fields['original_price'] = originalPriceController.text.toString();
    request.fields['discounted_price'] = discountedPriceController.text.toString();
    request.fields['discount_type'] = discountTypeController.text.toString();
    request.fields['percent_of'] = percentOfController.text.toString();
    request.fields['fixed_value'] = fixedValueController.text.toString();

    //for image
    if (image != null) {
      var photo = await http.MultipartFile.fromPath('image', image!.path);
      print('processing');
      request.files.add(photo);
    }


    //for icon
    /*if (icon != null) {
      var _icon = await http.MultipartFile.fromPath('icon', icon!.path);
      print('processing');
      request.files.add(_icon);
    }*/



    var response = await request.send();
    print("${response.statusCode}");

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var data = jsonDecode(responseString);
    if (response.statusCode == 200) {
      print("responseBody1 $responseData");

      print('oooooooooooooooooooo');
      print(data['message']);
      setState(() {
        onProgress = false;
      });
      showInToast(data['message']);
      Navigator.pop(context);
      print("***************");
      print("${response.statusCode}");
    } else {
      print('else call');
      print("responseBody1 $responseString");
      print(data['errors']['image'][0]);
      showInToast(data["errors"]['image'][0]);
      setState(() {
        onProgress = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {


    final double height = MediaQuery.of(context).size.height;
    final double weidth = MediaQuery.of(context).size.width;

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: Icon(Icons.arrow_back),
        title: Text("Add new Product"),
        centerTitle: true,
      ),



      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Product Name',),


                SizedBox(height: 10,),
                TextFormField(
                  controller: nameController,
                  onSaved: (name) {
                    fildName = name;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "*Write Product Name";
                    }
                    if (value.length < 3) {
                      return "*Write more then three word";
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          gapPadding: 5.0,
                          borderSide:
                          BorderSide(color: aTextColor, width: 2.5)),
                      hintText: 'Enter Product Name'),
                ),




                Text('Category Name',),


                SizedBox(height: 10,),
                /*TextFormField(
                  controller: idController,
                  onSaved: (name) {
                    fildId = name;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "*Write Product Id";
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          gapPadding: 5.0,
                          borderSide:
                          BorderSide(color: aTextColor, width: 2.5)),
                      hintText: 'Enter Product Id'),
                ),*/

                //////
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  decoration: BoxDecoration(
                      color: aSearchFieldColor,
                      border: Border.all(color: Colors.grey, width: 0.2),
                      borderRadius: BorderRadius.circular(10.0)),
                  height: 60,
                  child: Center(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 30,
                      ),
                      decoration: InputDecoration.collapsed(hintText: ''),
                      value: categoryType,
                      hint: Text(
                        'Select Category',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: aTextColor, fontSize: 16),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          categoryType = newValue;
                          print("my Category is $categoryType");
                          if (categoryType!.isEmpty) {
                            showInToast("Category Type required");
                          }
                          // print();
                        });
                      },
                      /*onSaved: (name) {
                        categoryType = name;
                      },*/
                      validator: (value) =>
                      value == null ? 'field required' : null,
                      items: categoryList?.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(
                            "${item['name']}",
                            style: TextStyle(
                                fontSize: 14,
                                color: aTextColor,
                                fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          value: item['id'].toString(),
                        );
                      })?.toList() ?? [],
                    ),
                  ),
                ),

                ///////



                Text('Quantity',),


                SizedBox(height: 10,),
                TextFormField(
                  controller: quantityController,
                  onSaved: (name) {
                    fildQuantity = name;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "*Write Product Quantity";
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          gapPadding: 5.0,
                          borderSide:
                          BorderSide(color: aTextColor, width: 2.5)),
                      hintText: 'Enter Product Quantity'),
                ),



                Text('Original Price',),


                SizedBox(height: 10,),
                TextFormField(
                  controller: originalPriceController,
                  onSaved: (name) {
                    fildOriginalPrice = name;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "*Write Original Price";
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          gapPadding: 5.0,
                          borderSide:
                          BorderSide(color: aTextColor, width: 2.5)),
                      hintText: 'Enter Original Price'),
                ),


                Text('Discounted Price',),


                SizedBox(height: 10,),
                TextFormField(
                  controller: discountedPriceController,
                  onSaved: (name) {
                    fildDiscountedPrice = name;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "*Write Discounted Price";
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          gapPadding: 5.0,
                          borderSide:
                          BorderSide(color: aTextColor, width: 2.5)),
                      hintText: 'Enter Discounted Price'),
                ),



                Text('Discounted Type',),


                SizedBox(height: 10,),
                TextFormField(
                  controller: discountTypeController,
                  onSaved: (name) {
                    fildDiscountType = name;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "*Write Discounted Type";
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          gapPadding: 5.0,
                          borderSide:
                          BorderSide(color: aTextColor, width: 2.5)),
                      hintText: 'Enter Discounted Type'),
                ),



                Text('How Many Percent Off',),


                SizedBox(height: 10,),
                TextFormField(
                  controller: percentOfController,
                  onSaved: (name) {
                    fildPercentOf = name;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "*Write Percent Off";
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          gapPadding: 5.0,
                          borderSide:
                          BorderSide(color: aTextColor, width: 2.5)),
                      hintText: 'Enter How Many Percent Off'),
                ),



                Text('Fixed Value',),


                SizedBox(height: 10,),
                TextFormField(
                  controller: fixedValueController,
                  onSaved: (name) {
                    fildFixedValue = name;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "*Write Fixed Value";
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          gapPadding: 5.0,
                          borderSide:
                          BorderSide(color: aTextColor, width: 2.5)),
                      hintText: 'Enter Fixed Value'),
                ),




                SizedBox(height: 30,),
                Text('Product Image',),


                SizedBox(height: 10,),
                //image Upload design
                Container(
                  height: height * 0.3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: image == null
                      ? InkWell(
                      onTap: () {
                        getImageformGallery();
                      },
                      child: Image.network(
                          "https://apihomechef.antopolis.xyz/images/${widget.productModel!.image}"))
                      : Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(image!),
                        )),
                  ),
                ),
                //image Upload design

                SizedBox(height: 25,),
                Center(child: Text('* 320x320 is the Recommended Size', style: TextStyle(color: Colors.black26, fontSize: 14, fontWeight: FontWeight.w400),)),


                SizedBox(height: 25,),

                SizedBox(height: 30,),


                //Edit Product Button
                Container(
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.black,
                      border: Border.all(color: aTextColor, width: 0.5),
                    ),
                    child: TextButton(
                      onPressed: () {
                        editProduct();
                      },
                      child: Center(
                        child: Text(
                          'Publish Product',
                          style: TextStyle(
                              color: aPrimaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
                //Edit Product Button



              ],
            ),
          ),
        ),
      ),

    );
  }
}
