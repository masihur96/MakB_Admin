import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/data_model/dart/sub_category_model.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
class SubCategory extends StatefulWidget {
  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  var subCategoryTextController = TextEditingController();
  String   oldCategory='';
  var updateSubcategoryTextController;

  List _categoryList = [];
  String dropdownValue = "";

  bool _isLoading = false;
  int counter=0;

  List<SubCategoryModel> _filteredList = [];
  List<SubCategoryModel> _subCategoryList = [];

  _filterSubCategoryList(String searchItem) {
    setState(() {
      _filteredList = _subCategoryList
          .where((element) => (element.category!
          .toLowerCase()
          .contains(searchItem.toLowerCase())))
          .toList();
      //_filteredListForSearch = _filteredList;
    });
  }


  _customInit(FirebaseProvider firebaseProvider)async{
    setState(() {
      counter++;
    });

    for(var i = 0;i<firebaseProvider.categoryList.length;i++){
      _categoryList.add(firebaseProvider.categoryList[i].category);
    }
    setState(() {
      dropdownValue = _categoryList[0];
      _filterSubCategoryList(dropdownValue);
    });

    if (firebaseProvider.subCategoryList.isEmpty) {
      await firebaseProvider.getSubCategory().then((value) {
        setState(() {
          _subCategoryList = firebaseProvider.subCategoryList;
          _filterSubCategoryList(dropdownValue);

        });
      });
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _subCategoryList = firebaseProvider.subCategoryList;
        _filterSubCategoryList(dropdownValue);
      });
      setState(() {
        _isLoading = false;
      });
    }



  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);
    if(counter==0){
      _customInit(firebaseProvider);
    }
    return Container(
        width: publicProvider.pageWidth(size),
      child: Center(
        child: Column(
          children: [
            Text('Sub-Category List',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Category : ",
                                      style:
                                      TextStyle(fontSize: size.height * .025),
                                    ),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: dropdownValue,
                                        elevation: 0,
                                        dropdownColor: Colors.white,
                                        style: TextStyle(color: Colors.black),
                                        items: _categoryList.map((itemValue) {
                                          return DropdownMenuItem<String>(
                                            value: itemValue,
                                            child: Text(itemValue),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            dropdownValue = newValue!;
                                          });

                                          _filterSubCategoryList(dropdownValue);
                                        },
                                      ),
                                    ),
                                  ]),
                            )),
                        IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text('Add SubCategory'),
                                      content: TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            //   valueText = value;
                                          });
                                        },
                                        controller: subCategoryTextController,
                                        decoration: InputDecoration(hintText: "Sub-Category Name"),
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

                                                  subCategoryTextController.clear();
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
                                                :TextButton(
                                                child: Text('OK',
                                                    style: TextStyle(color: Colors.black)),
                                                onPressed: () async {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                    final String uuid = Uuid().v1();
                                                       _submitCategoryData(firebaseProvider,uuid)
                                                        .then((value) {
                                                          firebaseProvider.getSubCategory().then((value) {
                                                            setState(() {
                                                              publicProvider.subCategory =
                                                              'Subcategory';
                                                              publicProvider.category = '';
                                                            });

                                                          });

                                                        //

                                                      Navigator.pop(context);
                                                      _isLoading = false;

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
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),

                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: _filteredList.length,
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
                                                Text(_filteredList[index]
                                                    .subCategory!),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {

                                                            setState(() {
                                                              updateSubcategoryTextController = TextEditingController(text: firebaseProvider.subCategoryList[index].subCategory!);

                                                              oldCategory = firebaseProvider.subCategoryList[index].subCategory!;
                                                            });

                                                            _displayTextInputDialog(
                                                                oldCategory,
                                                                context,
                                                                firebaseProvider,
                                                                firebaseProvider.subCategoryList[index].id!);


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

                                                              oldCategory = firebaseProvider.subCategoryList[index].subCategory!;
                                                            });
                                                            _displayDeleteDialog(
                                                                oldCategory,
                                                                context,
                                                                firebaseProvider,
                                                                firebaseProvider.subCategoryList[index].id!);

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
  Future<void> _displayDeleteDialog(
      String oldText,
      BuildContext context, FirebaseProvider firebaseProvider, String id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Delete Subcategory'),
              content: Text(
                  'Are You Confirm to Delete This Subcategory'
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


                          firebaseProvider.batchDeleteSubcategory(id,oldText)
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

  Future<void> _submitCategoryData(
      FirebaseProvider firebaseProvider,String id) async {


      Map<String, dynamic> map = {

        'id': id,
        'category': dropdownValue,
        'subCategory': subCategoryTextController.text,
      };
      await firebaseProvider.addSubCategoryData(map).then((value) {
        if (value) {
          showToast('Successfully Added');
          setState(() {
            _isLoading = false;
            setState(() {
         subCategoryTextController.clear();
            });

          });
        } else {
          setState(() => _isLoading = false);
          showToast('Failed to Added');
        }
      });

  }
  Future<void> _displayTextInputDialog(
      String oldText,
      BuildContext context, FirebaseProvider firebaseProvider, String id) async {

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Update Suncategory'),
              content: TextField(
                onChanged: (value) {
                  setState(() {
                    // updateCategoryTextController.text = value;
                  });
                  // print(updateCategoryTextController.text);
                },
                controller: updateSubcategoryTextController,
                decoration: InputDecoration(hintText: "Subcategory Name"),
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
                          updateSubcategoryTextController.clear();
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
                            'subCategory': updateSubcategoryTextController.text,
                            'id': id,
                          };
                          //  print(updateCategoryTextController.text);
                          firebaseProvider.batchUpdateSubcategory(mapData,oldText, updateSubcategoryTextController.text)
                              .then((value) {


                            firebaseProvider.getSubCategory();

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
