import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:seip_day50/http/custome_http_request.dart';
import 'package:seip_day50/provider/category_provider.dart';
import 'package:seip_day50/screen/add_category.dart';
import 'package:seip_day50/screen/edit_category.dart';
import 'package:seip_day50/widget/brand_colors.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {


  @override
  void initState() {
    // TODO: implement initState
    //fetchOrderData();
    Provider.of<CategoryProvider>(context, listen: false).getCategoryData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    final category  = Provider.of<CategoryProvider>(context);

    return Scaffold(
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(),
        inAsyncCall: onProgress == true,


        child: Container(
            width: double.infinity,
            child: category.categoryList.isNotEmpty
                ? NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                setState(() {
                  if (notification.direction == ScrollDirection.forward) {
                    _buttonVisiable = true;
                  } else if (notification.direction ==
                      ScrollDirection.reverse) {
                    _buttonVisiable = false;
                  }
                });
                return true;
              },


              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: category.categoryList.length,
                  itemBuilder: (context, index) {



                    return Container(
                      height: 200,



                      child: Stack(
                        children: [



                          Column(
                            children: [



                              Expanded(
                                flex: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "https://apihomechef.antopolis.xyz/images/${category.categoryList[index].image ?? ""}"),
                                    ),
                                  ),
                                ),
                              ),



                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${category.categoryList[index].name ?? ""}',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),




                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                width: 0.1),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                Radius.circular(5)),
                                          ),
                                          child: TextButton(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.edit,
                                                  size: 15,
                                                  color: aTextColor,
                                                ),
                                                Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                    color: aTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),





                                            onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditCategory(
                                                            categoryModel: category.categoryList[index],
                                                          )));
                                            },


                                          ),
                                        )),
                                    Container(
                                      height: 30,
                                      width: 0.5,
                                      color: Colors.grey,
                                    ),
                                    Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                width: 0.1),
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                Radius.circular(5)),
                                          ),




                                          child: TextButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('Are you sure ?'),

                                                      titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: aTextColor),


                                                      titlePadding:
                                                      EdgeInsets.only(
                                                          left: 35,
                                                          top: 25),
                                                      content: Text(
                                                          'Once you delete, the item will gone permanently.'),
                                                      contentTextStyle:
                                                      TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                          color:
                                                          aTextColor),
                                                      contentPadding:
                                                      EdgeInsets.only(
                                                          left: 35,
                                                          top: 10,
                                                          right: 40),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                15,
                                                                vertical:
                                                                10),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        5)),
                                                                border: Border.all(
                                                                    color:
                                                                    aTextColor,
                                                                    width:
                                                                    0.2)),
                                                            child: Text(
                                                              'CANCEL',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  12,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                                  color:
                                                                  aTextColor),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                15,
                                                                vertical:
                                                                10),
                                                            decoration:
                                                            BoxDecoration(
                                                              color: Colors
                                                                  .redAccent
                                                                  .withOpacity(
                                                                  0.2),
                                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                                            ),
                                                            child: Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  12,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                                  color:
                                                                  aPriceTextColor),
                                                            ),
                                                          ),


                                                          //delete item
                                                          onPressed: () async {
                                                            setState(() {
                                                              onProgress =
                                                              true;
                                                            });
                                                            await CustomHttpRequest
                                                                .deleteCategory(category.categoryList[index].id!.toInt());

                                                            setState(() {
                                                              onProgress =
                                                              false;
                                                              category.categoryList.removeAt(index);
                                                            });
                                                            Navigator.pop(context);

                                                            /*    CustomHttpRequest.deleteCategoryItem(
                                                        context,
                                                        categories
                                                            .categoriesList[
                                                        index]
                                                            .id)
                                                        .then((value) =>
                                                    value);
                                                    setState(() {
                                                      categories
                                                          .categoriesList
                                                          .removeAt(
                                                          index);
                                                    });
                                                    Navigator.pop(
                                                        context);*/
                                                          },//delete item
                                                        ),
                                                      ],
                                                    );
                                                  },
                                              );
                                            },




                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  size: 15,
                                                  color: Colors.red,
                                                ),
                                                Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),




                            ],
                          ),





                          Positioned(
                            right: 55,
                            top: 80,



                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(50)),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: aTextColor, width: 0.5)),
                              child: Center(
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "https://apihomechef.antopolis.xyz/images/${category.categoryList[index].icon ?? ""}"),
                                    ),
                                  ),
                                ),
                              ),
                            ),



                          ),



                        ],
                      ),




                    );



                  },
              ),



            )
                : CircularProgressIndicator(),



        ),
      ),




      floatingActionButton: _buttonVisiable
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategory())).then((value) =>
              Provider.of<CategoryProvider>(context, listen: false));
        },
        backgroundColor: aBlackCardColor,
        child: Icon(
          Icons.add,
          size: 30,
          color: aPrimaryColor,
        ),
      )
          : null,
    );
  }



  bool onProgress = false;

  bool _buttonVisiable = true;
  ScrollController? _scrollController;

}
