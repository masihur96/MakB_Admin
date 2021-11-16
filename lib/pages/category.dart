import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:provider/provider.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  var categoryTextController = TextEditingController();
  String   oldCategory='';
  var updateCategoryTextController;



  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);

    return Container(
      width: publicProvider.pageWidth(size),
      child: Center(
        child: Column(
          children: [
            Text('Category List',
                style: TextStyle(fontSize: size.height * .035)),
            SizedBox(
              height: size.height * .01,
            ),
            Container(
              width: size.height * .8,
              height: size.height * .85,
              color: Colors.white,
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text('Add Category'),
                        InkWell(
                          onTap: (){
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text('Add Category'),
                                      content: TextField(

                                        controller: categoryTextController,
                                        decoration: InputDecoration(hintText: "Category Name"),
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(

                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(color: Colors.black),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  categoryTextController.clear();
                                                  Navigator.pop(context);
                                                });
                                              },
                                            ),
                                            _isLoading
                                                ? Container(
                                                child: Column(
                                                  children: [
                                                    fadingCircle,
                                                  ],
                                                ))
                                                : TextButton(
                                              child: Text('OK',
                                                  style: TextStyle(color: Colors.black)),
                                              onPressed: () async {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                _submitCategoryData(firebaseProvider).then((value) {

                                                  firebaseProvider.getCategory().then((value) {
                                                    _isLoading = false;
                                                    categoryTextController.clear();
                                                    Navigator.pop(context);
                                                  });
                                                });


                                              },
                                            ),

                                          ],
                                        ),
                                      ],
                                    );
                                  });
                                });
                          },
                            child: Icon(Icons.add_circle_outline))
                      ],),
                    ),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: firebaseProvider.categoryList.length,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder:
                                (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border:
                                      Border.all(color: Colors.grey)),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 3,
                                          right: 3,
                                        ),
                                        child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(firebaseProvider.categoryList[index]
                                                    .category!),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                           setState(() {
                                                             updateCategoryTextController = TextEditingController(text: firebaseProvider.categoryList[index].category!);

                                                             oldCategory = firebaseProvider.categoryList[index].category!;
                                                            });

                                                            _displayTextInputDialog(
                                                                oldCategory,
                                                                context,
                                                                firebaseProvider,
                                                                firebaseProvider.categoryList[index].id!);

                                                          },
                                                          icon: Icon(Icons
                                                              .edit_outlined)),
                                                      SizedBox(
                                                        width:
                                                        size.height * .02,
                                                      ),
                                                      IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              oldCategory = firebaseProvider.categoryList[index].category!;
                                                            });

                                                            _displayDeleteDialog(
                                                                oldCategory,
                                                                context,
                                                                firebaseProvider,
                                                                firebaseProvider.categoryList[index].id!);

                                                          },
                                                          icon: Icon(Icons
                                                              .cancel_outlined)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),


    );
  }

  Future<void> _submitCategoryData(
      FirebaseProvider firebaseProvider) async {

    final snapshot1 = await FirebaseFirestore.instance.collection('Category').doc(categoryTextController.text).get();

    if(snapshot1.exists){
      Map<String, dynamic> map = {

        'id': categoryTextController.text,
        'category': categoryTextController.text,
      };
      await firebaseProvider.updateCategoryData(map).then((value) {
        if (value) {
          showToast('Successfully Updated');
          // customInt(firebaseProvider);
       categoryTextController.clear();
          setState(() {
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
          showToast('Failed to Update');
        }
      });

    }else{

      Map<String, dynamic> map = {

        'id': categoryTextController.text,
        'category': categoryTextController.text,
      };
      await firebaseProvider.addCategoryData(map).then((value) {
        if (value) {
          showToast('Successfully Added');
          // _emptyFildCreator();
          // customInt(firebaseProvider);

          setState(() {
            _isLoading = false;
            setState(() {

            });

          });
        } else {
          setState(() => _isLoading = false);
          showToast('Failed to Added');
        }
      });

    }

  }
  Future<void> _displayTextInputDialog(
      String oldText,
      BuildContext context, FirebaseProvider firebaseProvider, String id) async {

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Update Category'),
              content: TextField(
                onChanged: (value) {
                  setState(() {
                   // updateCategoryTextController.text = value;
                  });
                 // print(updateCategoryTextController.text);
                },
                controller: updateCategoryTextController,
                decoration: InputDecoration(hintText: "Category Name"),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      // color: Colors.green,
                      // textColor: Colors.white,
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        setState(() {
                          //  codeDialog = valueText;
                          updateCategoryTextController.clear();
                          Navigator.pop(context);
                        });
                      },
                    ),
                    _isLoading
                        ? Container(
                        child: Column(
                          children: [
                            fadingCircle,
                          ],
                        ))
                        : TextButton(
                          child: Text('OK',
                              style: TextStyle(color: Colors.black)),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });

                              Map<String, String> mapData = {
                                'category': updateCategoryTextController.text,
                                'id': id,
                              };
                            //  print(updateCategoryTextController.text);
                            firebaseProvider.batchUpdateCategory(mapData,oldText, updateCategoryTextController.text)
                                  .then((value) {


                                    firebaseProvider.getCategory();

                                    setState(() {
                                      Navigator.pop(context);
                                      _isLoading = false;
                                    });

                            }


                            );

                            }
                        ),
                  ],
                ),
              ],
            );
          });
        });
  }

  Future<void> _displayDeleteDialog(
      String oldText,
      BuildContext context, FirebaseProvider firebaseProvider, String id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Delete Category'),
              content: Text(
                'Are You Confirm to Delete This Category'
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      // color: Colors.green,
                      // textColor: Colors.white,
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    _isLoading
                        ? Container(
                        child: Column(
                          children: [
                            fadingCircle,
                          ],
                        ))
                        : TextButton(
                        child: Text('OK',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });


                          firebaseProvider.batchDeleteCategory(id,oldText)
                              .then((value) {


                            firebaseProvider.getCategory();

                            setState(() {
                              Navigator.pop(context);
                              _isLoading = false;
                            });

                          }


                          );

                        }
                    ),
                  ],
                ),
              ],
            );
          });
        });
  }

}
