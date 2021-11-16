import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
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



  List sizes=[];

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
  List <dynamic> convertedThumbnail =[];
  List imageUrl =[];

  String thumbnailURL='';


  var selectedfiles=[];
  var file;
  String name = '';
  int? imageIndex=0;

  //custom init
  int counter=0;
  List _categoryList = [];
  List filterSubcategory=[];
  String categoryDropdownValue = "";
  String subCategoryDropdownValue = "";

  List<SubCategoryModel> _filteredList = [];
  List<SubCategoryModel> _subCategoryModelList = [];
  customInt(FirebaseProvider firebaseProvider) async {

    setState(() {
      counter++;
    });
    if(firebaseProvider.categoryList.isEmpty){
     await firebaseProvider.getCategory().then((value) {
        for(var i = 0;i<firebaseProvider.categoryList.length;i++){
          _categoryList.add(firebaseProvider.categoryList[i].category);
        }

        setState(() {
          categoryDropdownValue = _categoryList[0];

        });
      });
    }
    else {
      for(var i = 0;i<firebaseProvider.categoryList.length;i++){
        _categoryList.add(firebaseProvider.categoryList[i].category);
      }
      setState(() {
        categoryDropdownValue = _categoryList[0];
        _subCategoryModelList = firebaseProvider.subCategoryList;
      });

      _filterSubCategoryList(categoryDropdownValue);

    }

  }



  _filterSubCategoryList(String searchItem) {
    setState(() {
      filterSubcategory.clear();
      _filteredList = _subCategoryModelList
          .where((element) => (element.category!
          .toLowerCase()
          .contains(searchItem.toLowerCase())))
          .toList();
      if(_filteredList.isNotEmpty){
        for(var i = 0;i<_filteredList.length;i++){
          filterSubcategory.add(_filteredList[i].subCategory!);
        }
        setState(() {
          subCategoryDropdownValue = filterSubcategory[0];
        });
      }else {
        setState(() {
          subCategoryDropdownValue = '';
        });
      }


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
    ScrollController scrollController = ScrollController();
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
                  ): convertedThumbnail.isNotEmpty? Image.memory(convertedThumbnail[0],fit: BoxFit.cover,):Container(),
                ),
                Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                     Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         InkWell(
                           onTap: (){
                             convertedImages.clear();
                              convertedThumbnail.clear();
                            // // imageUrl.clear();
                            //  setState(() {
                            //    thumbnailURL='';
                            //  });

                             pickedImage();
                           },
                             child: Icon(Icons.camera)),
                         Text('Products',style: TextStyle(fontSize: 10),)
                       ],
                     ) ,

                        SizedBox(width: 50,),

                       Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           InkWell(
                               onTap: (){
                                 convertedImages.clear();
                                convertedThumbnail.clear();
                                //  imageUrl.clear();
                                //  setState(() {
                                //    thumbnailURL='';
                                //  });

                                 pickedThumbnailImage();
                               },
                               child: Icon(Icons.filter_b_and_w_outlined)),
                           Text('Thumbnail',style: TextStyle(fontSize: 10),)
                         ],
                       ) ,
                      ],
                    ))]

          ),
          Container(
            height:  publicProvider.isWindows?size.height*.2:size.width*.2,

            child: Scrollbar(
              isAlwaysShown: true,
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ListView.builder(
                  controller:scrollController ,
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
            ),
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
                    child: Container(
                      width:publicProvider.isWindows?size.height*.8:size.width*.8,

                      child: TextField(
                        controller: titleTextController,
                        decoration: textFieldFormDecoration(size).copyWith(
                          labelText: 'Title',
                          hintText: 'Product Name',
                          hintStyle: TextStyle(fontSize: 15),

                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: Container(
                      width:publicProvider.isWindows?size.height*.8:size.width*.8,
                      child: TextField(
                        controller: priceTextController,
                        decoration: textFieldFormDecoration(size).copyWith(
                          labelText: 'Price',
                          hintText: 'Price',
                          hintStyle: TextStyle(fontSize: 15),

                        ),
                      ),
                    ),
                  ),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: Container(
                      width:publicProvider.isWindows?size.height*.8:size.width*.8,
                      child: TextField(

                        controller: profitTextController,
                        decoration: textFieldFormDecoration(size).copyWith(
                          labelText: 'Profit Amount',
                          hintText: 'Profit Amount',
                          hintStyle: TextStyle(fontSize: 15),

                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: Container(
                      width:publicProvider.isWindows?size.height*.8:size.width*.8,
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
                                  value: categoryDropdownValue,
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
                                      categoryDropdownValue = newValue!;
                                    });
                                _filterSubCategoryList(categoryDropdownValue);
                                  },
                                ),
                              ),

                            ],
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

                            children: [
                              Text('Subcategory: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15)),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: subCategoryDropdownValue,
                                  elevation: 0,
                                  dropdownColor: Colors.white,
                                  style: TextStyle(color: Colors.black),
                                  items: filterSubcategory.map((itemValue) {
                                    return DropdownMenuItem<String>(
                                      value: itemValue,
                                      child: Text(itemValue),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      subCategoryDropdownValue = newValue!;
                                    });

                                  },
                                ),
                              ),

                            ],
                          ),

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

                  if(imageUrl.isNotEmpty && categoryDropdownValue!=''&& subCategoryDropdownValue!=''&& thumbnailURL.isNotEmpty){
                    setState(() {
                      _isLoading = true;
                    });
                  _submitData(publicProvider,firebaseProvider, uuid);

                  }else {
                    showToast('Product Photo ,Thumbnail, Category & Subcategory is Required');
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

  pickedThumbnailImage() async {

    FileUploadInputElement input = FileUploadInputElement()..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.multiple = false;
    input.click();

    input.onChange.listen((event) {

      for(var image in input.files!){
        final reader = FileReader();
        reader.readAsDataUrl(image);
        reader.onLoadEnd.listen((event) async {
          var snapshot = await fs.ref().child('ProductThumbnail').child(image.name).putBlob(image);
          String downloadUrl = await snapshot.ref.getDownloadURL();
          setState(() {
            thumbnailURL = downloadUrl;

          });

          print(thumbnailURL);
        });

        reader.onLoad.first.then((res) {
          final encoded = reader.result as String;
          final stripped =
          encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
          setState(() {
            data = base64.decode(stripped);
            convertedThumbnail.add(data);
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
        'category': categoryDropdownValue,
        'subCategory': subCategoryDropdownValue,
        'colors': FieldValue.arrayUnion(colorList),
        'image': imageUrl,
        'thumbnail': thumbnailURL,
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


}