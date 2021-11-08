import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/data_model/dart/category_model.dart';
import 'package:makb_admin_pannel/data_model/dart/sub_category_model.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';



class UploadProductPage extends StatefulWidget {

  @override
  _UploadProductPageState createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<UploadProductPage>  {


//size Variable
  bool _isLoading = false;
  bool _isS=false;
  bool _isM=false;
  bool _isL=false;
  bool _isXL=false;
  bool _isXXL=false;
  bool _isXXXL=false;

  late Color screenPickerColor;
  // Color for the picker in a dialog using onChanged.
  late Color dialogPickerColor;
  // Color for picker using the color select dialog.
  late Color dialogSelectColor;




  int productId=1;


  @override
  void initState() {
    super.initState();
    screenPickerColor = Colors.blue;  // Material blue.
    dialogPickerColor = Colors.red;   // Material red.
    dialogSelectColor = const Color(0xFFA239CA); // A purple color.
  }
  String categorysValue='';
  String subCategorysValue = '';

  List sizes=[];



  List <CategoryModel> categorys = [];
  List <SubCategoryModel> subCategorys = [];
  var titleTextController = TextEditingController();
  var descriptionTextController = TextEditingController();
  var priceTextController = TextEditingController();
  var profitTextController = TextEditingController();
  var categoryTextController = TextEditingController();
  var subCategoryTextController = TextEditingController();



      //color Variable
  List<String> colorList = [];
  List colors=[];

  //Image Varialbe
  String? error;
  Uint8List? data;
  List <dynamic> convertedImages =[];
  List imageUrl =[];

  var selectedfiles=[];
  var file;
  String name = '';
  int? imageIndex=0;

  //custom init
  int counter=0;



  customInt(FirebaseProvider firebaseProvider) async {

    setState(() {
      counter++;
    });

      await firebaseProvider.getCategory().then((value) {
        setState(() {
          categorys = firebaseProvider.categoryList;
          categorysValue = categorys[1].category!;

          print('Category List From Add: $categorys');
          print('Category of index 0 From Add: $categorysValue');
        });
      });

    await firebaseProvider.getSubCategory().then((value) {
      setState(() {
        subCategorys = firebaseProvider.subCategoryList;
        subCategorysValue = subCategorys[1].subCategory!;

        print('SubCategory List From Add: $subCategorys');
        print('SubCategory of index 0 From Add: $subCategorysValue');

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);

    if(counter==0){
      customInt(firebaseProvider);
    }
    return Container(
      width: publicProvider.pageWidth(size),
      child: SingleChildScrollView(
        child:publicProvider.isWindows?  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width:publicProvider.pageWidth(size)*.5,
                child: productPickWidget(firebaseProvider,publicProvider,size)),

            productDetailsWidget(firebaseProvider,publicProvider,size)
          ],
        ):Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            productPickWidget(firebaseProvider,publicProvider,size),

            productDetailsWidget(firebaseProvider,publicProvider,size)
          ],
        ),
      ),
    );
  }

  Widget productPickWidget(FirebaseProvider firebaseProvider,PublicProvider publicProvider,Size size){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          Stack(
              children:[
                Container(
                  // width: size.height*.4,
                  height: publicProvider.isWindows?size.height*.6:size.width*.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 1,color: Colors.grey)
                  ),
                  child:  convertedImages.isNotEmpty? Container(
                    child: Image.memory(convertedImages[imageIndex!],fit: BoxFit.cover,) ,
                  ):Container(),
                ),

                Positioned.fill(
                    child: IconButton(onPressed: (){

                      convertedImages.clear();
                      imageUrl.clear();
                      pickedImage();

                    }, icon: Icon(Icons.camera) ))]

          ),
          Container(
            height:  publicProvider.isWindows?size.height*.2:size.width*.2,
            width:publicProvider.pageWidth(size)*.5,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: convertedImages.isEmpty?3:convertedImages.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          imageIndex = index;
                        });
                      },
                      child: convertedImages.isNotEmpty?  Container(
                          width: publicProvider.pageWidth(size)*.1,
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              border: Border.all(width: 1,color: Colors.grey)
                          ),
                          alignment: Alignment.center,
                          child: Image.memory(convertedImages[index],fit: BoxFit.fill,)

                      ):Container(
                        width:publicProvider.pageWidth(size)*.1,
                        decoration: BoxDecoration(

                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(width: 1,color: Colors.grey)
                        ),

                        height: 200,),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget productDetailsWidget(FirebaseProvider firebaseProvider,PublicProvider publicProvider,Size size){

    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Product Details',style: TextStyle(fontSize: 20),),
          ),
          Container(
            width:publicProvider.pageWidth(size)*.45,

            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(width: 1,color: Colors.grey)

            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: TextField(
                      controller: titleTextController,
                      decoration: textFieldFormDecoration(size).copyWith(
                        labelText: 'Title',
                        hintText: 'Product Name',
                        hintStyle: TextStyle(fontSize: 15),

                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: TextField(
                      controller: priceTextController,
                      decoration: textFieldFormDecoration(size).copyWith(
                        labelText: 'Price',
                        hintText: 'Price',
                        hintStyle: TextStyle(fontSize: 15),

                      ),
                    ),
                  ),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: TextField(

                      controller: profitTextController,
                      decoration: textFieldFormDecoration(size).copyWith(
                        labelText: 'Profit Amount',
                        hintText: 'Profit Amount',
                        hintStyle: TextStyle(fontSize: 15),

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: TextField(
                      controller: descriptionTextController,
                      decoration: textFieldFormDecoration(size).copyWith(
                        labelText: 'Description',
                        hintText: 'Description',
                        hintStyle: TextStyle(fontSize: 15),
                      ),
                      maxLines: 5,
                    ),
                  ),

                  Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text('Size: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15)),
                          Row(children: [
                            Text('S'),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  _isS = !_isS;
                                  if(_isS==true){
                                    sizes.add('S');
                                  }else{
                                    sizes.remove('S');
                                  }
                                });
                                print(sizes);
                              },

                                child: Icon(sizes.contains('S')?Icons.check_box_outlined:Icons.check_box_outline_blank_outlined))
                          ],),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(children: [
                              Text('M'),
                              InkWell(
                                  onTap: (){
                                    setState(() {
                                      _isM = !_isM;
                                      if(_isM==true){
                                        sizes.add('M');
                                      }else{
                                        sizes.remove('M');
                                      }
                                    });
                                    print(sizes);
                                  },

                                  child: Icon(sizes.contains('M')?Icons.check_box_outlined:Icons.check_box_outline_blank_outlined))

                            ],),
                          ),
                          Row(children: [
                            Text('L'),
                            InkWell(
                                onTap: (){
                                  setState(() {
                                    _isL = !_isL;
                                    if(_isL==true){
                                      sizes.add('L');
                                    }else{
                                      sizes.remove('L');
                                    }
                                  });
                                  print(sizes);
                                },

                                child: Icon(sizes.contains('L')?Icons.check_box_outlined:Icons.check_box_outline_blank_outlined))

                          ],),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(children: [
                              Text('XL'),
                              InkWell(
                                  onTap: (){
                                    setState(() {
                                      _isXL = !_isXL;
                                      if(_isXL==true){
                                        sizes.add('XL');
                                      }else{
                                        sizes.remove('XL');
                                      }
                                    });
                                    print(sizes);
                                  },

                                  child: Icon( sizes.contains('XL')?Icons.check_box_outlined:Icons.check_box_outline_blank_outlined))

                            ],),
                          ),
                          Row(children: [
                            Text('XXL'),
                            InkWell(
                                onTap: (){
                                  setState(() {
                                    _isXXL = !_isXXL;
                                    if(_isXXL==true){
                                      sizes.add('XXL');
                                    }else{
                                      sizes.remove('XXL');
                                    }
                                  });
                                  print(sizes);
                                },

                                child: Icon( sizes.contains('XXL')?Icons.check_box_outlined:Icons.check_box_outline_blank_outlined))

                          ],),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(children: [
                              Text('XXXL'),
                              InkWell(
                                  onTap: (){
                                    setState(() {
                                      _isXXXL = !_isXXXL;
                                      if(_isXXXL==true){
                                        sizes.add('XXXL');
                                      }else{
                                        sizes.remove('XXXL');
                                      }
                                      print(sizes);
                                    });
                                  },

                                  child: Icon(sizes.contains('XXXL')?Icons.check_box_outlined:Icons.check_box_outline_blank_outlined))

                            ],),
                          ),

                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Category: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15)),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: categorysValue,
                                  elevation: 0,
                                  dropdownColor: Colors.white,
                                  style: TextStyle(color: Colors.black),
                                  items: categorys.map((itemValue) {
                                    return DropdownMenuItem<String>(
                                      value: itemValue.category,
                                      child: Text(itemValue.category!),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      categorysValue = newValue!;
                                    });

                                  },
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                              onTap: (){
                                showDialog(context: context, builder: (_){
                                  return  StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                                    return  AlertDialog(
                                      title: Text('Add Category'),
                                      content: Container(
                                        height: publicProvider.isWindows?size.height*.5:size.width*.5,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                                                child: TextField(
                                                  controller: categoryTextController,
                                                  decoration: textFieldFormDecoration(size).copyWith(
                                                    labelText: 'Category Name',
                                                    hintText: 'Category Name',
                                                    hintStyle: TextStyle(fontSize: 15),

                                                  ),
                                                ),
                                              ),

                                              _isLoading
                                                  ? fadingCircle
                                                  :ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.green,
                                                ),
                                                onPressed: () {


                                                  if(firebaseProvider.categoryList.contains(categoryTextController.text))
                                                 {
                                                   showToast('This Category is Already Exist');

                                                  } else {
                                                    setState(() {
                                                      _isLoading=true;
                                                    });
                                                    _submitCategoryData(firebaseProvider).then((value) {
                                                      setState(() {
                                                        _isLoading=false;
                                                      });
                                                    });
                                                  }



                                                },
                                                child: Text('Add Category',style: TextStyle(color: Colors.white),),
                                              ),

                                              Container(
                                                height: publicProvider.isWindows?size.height*.35:size.width*.35,
                                                width: publicProvider.isWindows?size.height*.4:size.width*.4,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    padding: const EdgeInsets.all(8),
                                                    itemCount: firebaseProvider.categoryList.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children:[

                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                            child: Divider(
                                                              height: 1,
                                                              color: Colors.grey,
                                                            ),
                                                          ),

                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(firebaseProvider.categoryList[index].category,style: TextStyle(fontSize: 15,color: Colors.black),),

                                                              InkWell(
                                                                  onTap: (){
                                                                    FirebaseFirestore.instance.collection('Category').doc(firebaseProvider.categoryList[index].id).delete().then((value) {
                                                                     showToast('Success');
                                                                     customInt(firebaseProvider);
                                                                     Navigator.pop(context);
                                                                    });
                                                                  },
                                                                  child: Icon(Icons.cancel_outlined))

                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                ),
                                              ),




                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                                }) ;

                              },
                              child: Text('Add Category',style: TextStyle(color: Colors.green,fontSize: 14),))
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(

                            children: [
                              Text('Subcategory: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15)),
                              DropdownButtonHideUnderline(
                                child: Row(
                                  children: [
                                    DropdownButton<String>(

                                      value: subCategorysValue,
                                      elevation: 0,
                                      dropdownColor: Colors.white,
                                      style: TextStyle(color: Colors.black),
                                      items: subCategorys.map((itemValue) {
                                        return DropdownMenuItem<String>(

                                          value: itemValue.subCategory,
                                          child: Text(itemValue.subCategory!),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          subCategorysValue = newValue!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                              onTap: (){
                                showDialog(context: context, builder: (_){
                                  return  StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                                    return  AlertDialog(
                                      title: Text('Add Subcategory'),
                                      content: Container(
                                        height: publicProvider.isWindows?size.height*.5:size.width*.5,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: <Widget>[

                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                                                child: TextField(
                                                  controller: subCategoryTextController,
                                                  decoration: textFieldFormDecoration(size).copyWith(
                                                    labelText: 'Subcategory Name',
                                                    hintText: 'Subcategory Name',
                                                    hintStyle: TextStyle(fontSize: 15),

                                                  ),
                                                ),
                                              ),

                                              _isLoading
                                                  ? fadingCircle
                                                  :ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.green,
                                                ),
                                                onPressed: () {

                                                  if(firebaseProvider.subCategoryList.contains(subCategoryTextController.text)){

                                                    showToast('This SubCategory is Already Exist');
                                                  }else {
                                                    setState(() {
                                                      _isLoading=true;
                                                    });
                                                    _submitSubCategoryData(firebaseProvider).then((value) {
                                                      setState(() {
                                                        _isLoading=false;
                                                      });
                                                    });
                                                  }


                                                },
                                                child: Text('Add Subcategory',style: TextStyle(color: Colors.white),),
                                              ),

                                              Container(
                                                height: publicProvider.isWindows?size.height*.35:size.width*.35,
                                                width: publicProvider.isWindows?size.height*.4:size.width*.4,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    padding: const EdgeInsets.all(8),
                                                    itemCount: firebaseProvider.subCategoryList.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children:[

                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                            child: Divider(
                                                              height: 1,
                                                              color: Colors.grey,
                                                            ),
                                                          ),

                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(firebaseProvider.subCategoryList[index].subCategory,style: TextStyle(fontSize: 15,color: Colors.black),),

                                                              InkWell(
                                                                onTap: (){


                                                                  FirebaseFirestore.instance.collection('SubCategory').doc(firebaseProvider.subCategoryList[index].id).delete().then((value) {
                                                                   showToast('Success');
                                                                   customInt(firebaseProvider);
                                                                   Navigator.pop(context);
                                                                  });


                                                                },
                                                                  child: Icon(Icons.cancel_outlined))

                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                ),
                                              ),




                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                                }) ;

                              },

                              child: Text('Add Subcategory',style: TextStyle(color: Colors.green),))
                        ],
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Selected Color :',style: TextStyle(color: Colors.black),),

                          Container(

                            height: size.height*.05,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount:colors.isEmpty?0:colors.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return   Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                         color: colors[index] ,
                                          shape: BoxShape.circle
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.color_lens_outlined,color: Colors.redAccent,),

                          onPressed: (){
                            colorList.clear();
                            colors.clear();
                            showDialog(context: context, builder: (_){
                              return   AlertDialog(
                                title: Text('Picked Color'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: const Text('Select color below to change this color'),
                                        subtitle:
                                        Text('${ColorTools.colorCode(screenPickerColor)} '
                                            'aka ${ColorTools.nameThatColor(screenPickerColor)}'),
                                        trailing: ColorIndicator(
                                          width: 44,
                                          height: 44,
                                          borderRadius: 22,
                                          color: screenPickerColor,
                                        ),
                                      ),

                                      // Show the color picker in sized box in a raised card.
                                      SizedBox(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Card(
                                            elevation: 2,
                                            child: ColorPicker(
                                              // Use the screenPickerColor as start color.
                                              color: screenPickerColor,
                                              // Update the screenPickerColor using the callback.
                                              onColorChanged: (Color color) {
                                                setState(() {
                                              screenPickerColor = color;
                                                });
                                                setState(() {

                                                  if(colorList.contains(screenPickerColor)){

                                                  }else {
                                                    colors.add(screenPickerColor);
                                                    colorList.add('0x${ColorTools.colorCode(screenPickerColor)}');
                                                  }
                                                });
                                              },
                                              width: 44,
                                              height: 44,
                                              borderRadius: 22,
                                              heading: Text(
                                                'Select color',
                                                style: Theme.of(context).textTheme.headline5,
                                              ),
                                              subheading: Text(
                                                'Select color shade',
                                                style: Theme.of(context).textTheme.subtitle1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(onPressed: (){

                                            for(var index in colorList){
                                              colors.add(index.toString());
                                            }
                                            print(colorList);

                                          }, child: Text('Add')),
                                          ElevatedButton(onPressed: (){

                                            Navigator.pop(context);


                                          }, child: Text('Ok')),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            }) ;
                          },

                      ),

                    ],
                  ),

                ],),
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isLoading? fadingCircle: TextButton(
                onPressed: () {

                  String uuid = Uuid().v4();


                  if(convertedImages.isNotEmpty){
                    setState(() {
                      _isLoading = true;

                    });
                  _submitData(publicProvider,firebaseProvider, uuid);

                  }else {
                    showToast('Product Photo is Required');
                  }


                }, child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(width: 1,color: Colors.green)

                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 5,),
                  child: Text('Upload',style: TextStyle(color: Colors.white),),
                ))),
          )
        ],
      ),
    );
  }

  pickedImage() async {

    FileUploadInputElement input = FileUploadInputElement()..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.multiple = true;
    input.click();
    
    input.onChange.listen((event) {
      
      for(var image in input.files!){
        final reader = FileReader();
        reader.readAsDataUrl(image);
        reader.onLoadEnd.listen((event) async {
          var snapshot = await fs.ref().child('ProductImage').child(image.name).putBlob(image);
          String downloadUrl = await snapshot.ref.getDownloadURL();
          setState(() {
            imageUrl.add(downloadUrl);
          });
        });

        reader.onLoad.first.then((res) {
          final encoded = reader.result as String;
          final stripped =
          encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
          setState(() {

            data = base64.decode(stripped);
            convertedImages.add(data);
            error = null;
          });
        });
      }
    });
  }

  Future<void> _submitData( PublicProvider publicProvider,
      FirebaseProvider firebaseProvider,String id) async {


    DateTime date = DateTime.now();
    String dateData = '${date.month}-${date.day}-${date.year}';
      setState(() => _isLoading = true);
      Map<String, dynamic> map = {
        'title': titleTextController.text,
        'description': descriptionTextController.text,
        'price': priceTextController.text,
        'profitAmount': profitTextController.text,
        'size':sizes,
        'category': categorysValue,
        'subCategory': subCategorysValue,
        'colors': FieldValue.arrayUnion(colorList),
        'image': imageUrl,
        'date': dateData,
        'id': id,

      };



    await firebaseProvider.addProductData(map).then((value)async{
        if (value) {
          showToast('Product Uploaded Successfully');
          _emptyFildCreator();
          setState(() {
            setState(() {
              convertedImages.clear();
              imageUrl.clear();
              colorList.clear();
              colors.clear();
              sizes.clear();

            });
          });

          _isLoading = false;
        } else {
          setState(() => _isLoading = false);
          showToast('Failed');
        }
      });

  }

  _emptyFildCreator() {
    titleTextController.clear();
    descriptionTextController.clear();
    priceTextController.clear();
    profitTextController.clear();
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
           customInt(firebaseProvider);
          _emptyFildCreator();
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
          _emptyFildCreator();
          customInt(firebaseProvider);

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


  Future<void> _submitSubCategoryData(
      FirebaseProvider firebaseProvider) async {

    final snapshot1 = await FirebaseFirestore.instance.collection('SubCategory').doc(subCategoryTextController.text).get();

    if(snapshot1.exists){
      Map<String, dynamic> map = {

        'id': subCategoryTextController.text,
        'subCategory': subCategoryTextController.text,
      };
      await firebaseProvider.updateSubCategoryData(map).then((value) {
        if (value) {
          showToast('Successfully Updated');
          customInt(firebaseProvider);
          _emptyFildCreator();
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

        'id': subCategoryTextController.text,
        'subCategory': subCategoryTextController.text,
      };
      await firebaseProvider.addSubCategoryData(map).then((value) {
        if (value) {
          showToast('Successfully Added');
          customInt(firebaseProvider);
          _emptyFildCreator();

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


}