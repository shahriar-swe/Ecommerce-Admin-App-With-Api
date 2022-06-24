import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:seip_day50/http/custome_http_request.dart';
import 'package:seip_day50/model/category_model.dart';
import 'package:seip_day50/provider/category_provider.dart';
import 'package:seip_day50/widget/brand_colors.dart';
import 'package:seip_day50/widget/widget.dart';

class EditCategory extends StatefulWidget {
  EditCategory({Key? key,this.categoryModel}) : super(key: key);


  CategoryModel? categoryModel;

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {


  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  File? icon, image;
  final picker = ImagePicker();
  String? fildName;
  bool onProgress = false;



  @override
  void initState() {
    // TODO: implement initState
    nameController = TextEditingController(text: widget.categoryModel!.name);
    super.initState();
  }



  Future getIconformGallery() async {
    print('on the way of gallery');
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedImage != null) {
        icon = File(pickedImage.path);
        print('image found');
        print('$icon');
      } else {
        print('no image found');
      }
    });
  }




  Future getImageformGallery() async {
    print('on the way of gallery');
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedImage != null) {
        image = File(pickedImage.path);
        print('image found');
        print('$image');
      } else {
        print('no image found');
      }
    });
  }



  Future editCategory() async {
    setState(() {
      onProgress = true;
    });
    final uri = Uri.parse("https://apihomechef.antopolis.xyz/api/admin/category/${widget.categoryModel!.id}/update");


    var request = http.MultipartRequest("POST", uri);

    request.headers.addAll(
      await CustomHttpRequest().getHeaderWithToken(),
    );


    request.fields['name'] = nameController.text.toString();



    if (image != null) {
      var photo = await http.MultipartFile.fromPath('image', image!.path);
      print('processing');
      request.files.add(photo);
    }



    if (icon != null) {
      var _icon = await http.MultipartFile.fromPath('icon', icon!.path);
      print('processing');
      request.files.add(_icon);
    }



    var response = await request.send();
    print("${response.statusCode}");

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var data = jsonDecode(responseString);


    if (response.statusCode == 200) {
      print("responseBody1 $responseData");
      print(data['message']);
      setState(() {
        onProgress = false;
      });
      showInToast(data['message']);
      Provider.of<CategoryProvider>(context, listen: false).getCategoryData();
      Navigator.pop(context);
      print("${response.statusCode}");
    } else {
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

    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: onProgress == true,
        progressIndicator: CircularProgressIndicator(),
        child: Scaffold(
          appBar: AppBar(),
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category Name',),


                SizedBox(height: 10,),
                TextFormField(
                  controller: nameController,
                  onSaved: (name) {
                    fildName = name;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "*Write Category Name";
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
                      hintText: 'Enter Category Name'),
                ),


                SizedBox(height: 10,),
                Text("Choose category Icon"),


                SizedBox(height: 10,),
                Center(
                  child: Container(
                    height: height * 0.2,
                    width: weidth * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: icon == null
                        ? InkWell(
                        onTap: () {
                          getIconformGallery();
                        },
                        child: Image.network("https://apihomechef.antopolis.xyz/images/${widget.categoryModel!.icon}"))
                        : Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(icon!),
                          )),
                    ),
                  ),
                ),



                SizedBox(height: 25,),
                Center(child: Text('* 320x320 is the Recommended Size', style: TextStyle(color: Colors.black26, fontSize: 14, fontWeight: FontWeight.w400),)),



                SizedBox(height: 25,),
                Text("Choose category Image"),
                Container(
                  height: height * 0.3,
                  width: weidth * 0.9,
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
                          "https://apihomechef.antopolis.xyz/images/${widget.categoryModel!.image}"))
                      : Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(image!),
                        )),
                  ),
                ),





                Center(
                  child: MaterialButton(
                    color: Colors.black,
                    onPressed: () {
                      // addCategory();
                      editCategory();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30,right: 30),
                      child: Text("Edit Category",style: TextStyle(color: Colors.amber),),
                    ),
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
