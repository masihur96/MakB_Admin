import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';


class UpdatePackage extends StatefulWidget {
  @override
  _UpdatePackageState createState() => _UpdatePackageState();
}

class _UpdatePackageState extends State<UpdatePackage> {


  bool _isLoading = false;
  //loading variable

  //Text Field Controller
  var titleTextController = TextEditingController();
  var descriptionTextController = TextEditingController();
  var priceTextController = TextEditingController();
  var discountTextController = TextEditingController();
  var quantityTextController = TextEditingController();


  //size variable
  bool _isS=false;
  bool _isM=false;
  bool _isL=false;
  bool _isXL=false;
  bool _isXXL=false;
  bool _isXXXL=false;
  List sizes=[];

  //Colors Variable
  late Color screenPickerColor;
  late Color dialogPickerColor;
  late Color dialogSelectColor;
  List<String> colorList = [];
  List colors=[];
  @override
  void initState() {
    super.initState();
    screenPickerColor = Colors.blue;  // Material blue.
    dialogPickerColor = Colors.red;   // Material red.
    dialogSelectColor = const Color(0xFFA239CA); // A purple color.
  }

  //Image Varialbe
  String? error;
  Uint8List? data;
  List <dynamic> convertedImages =[];
  List <dynamic> convertedThumbnail =[];
  List imageUrl =[];
  String thumbnailURL='';
  var file;
  String name = '';
  int? imageIndex=0;

// product Id from Product Page
  String? selectedPackageID;
  List <dynamic> selectedPackageColor =[];
  //custom init
  int counter=0;
  customInt(FirebaseProvider firebaseProvider) async {

    await firebaseProvider.getPackage();
    setState(() {
      counter++;
    });

    //selected Product Data for Update
    setState(() {
     titleTextController.text = firebaseProvider.packageList[firebaseProvider.packageIndex].title;
     descriptionTextController.text = firebaseProvider.packageList[firebaseProvider.packageIndex].description;
     priceTextController.text = firebaseProvider.packageList[firebaseProvider.packageIndex].price;
      discountTextController.text = firebaseProvider.packageList[firebaseProvider.packageIndex].discountAmount;
      quantityTextController.text= firebaseProvider.packageList[firebaseProvider.packageIndex].quantity;
      selectedPackageID = firebaseProvider.packageList[firebaseProvider.packageIndex].id;
      selectedPackageColor = firebaseProvider.packageList[firebaseProvider.packageIndex].colors;
      imageUrl = firebaseProvider.packageList[firebaseProvider.packageIndex].image;
      sizes = firebaseProvider.packageList[firebaseProvider.packageIndex].size ;

      if( sizes.contains('XL')){
        _isXL = true;
      }  if(sizes.contains('S')){
        _isS = true;
      } if(sizes.contains('M')){
        _isM =true;
      } if(sizes.contains('L')){
        _isL =true;
      } if(sizes.contains('XL')){
        _isXL =true;
      } if(sizes.contains('XXL')){
        _isXXL =true;
      } if(sizes.contains('XXXL')){
        _isXXXL =true;
      }




      print(titleTextController.text);

    });

 //   print('Selected ID: $selectedPackageID');
    print('Selected Color: $selectedPackageColor');


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
                  ):convertedThumbnail.isNotEmpty?Container(
                    child: Image.memory(convertedThumbnail[0],fit: BoxFit.cover,),

                  ):imageUrl.isNotEmpty?Image.network(imageUrl[imageIndex!]):fadingCircle,
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
                                  imageUrl.clear();
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
                                  imageUrl.clear();
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
            width:publicProvider.pageWidth(size)*.5,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: firebaseProvider.packageIndex==null? convertedImages.isEmpty?3:convertedImages.length:firebaseProvider.packageList[firebaseProvider.packageIndex].image.length,
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
                        child: Image.memory(convertedImages[index],fit: BoxFit.cover,),

                      ):Container(
                        width:publicProvider.pageWidth(size)*.1,
                        decoration: BoxDecoration(

                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(width: 1,color: Colors.grey)
                        ),
                        child:imageUrl.isNotEmpty? Image.network(firebaseProvider.packageList[firebaseProvider.packageIndex].image[index]):Container() ,
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
                      controller: descriptionTextController,
                      decoration: textFieldFormDecoration(size).copyWith(
                        labelText: 'Description',
                        hintText: 'Description',
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

                      controller: discountTextController,
                      decoration: textFieldFormDecoration(size).copyWith(
                        labelText: 'Discount Amount In Percentage',
                        hintText: 'Discount Amount In Percentage',
                        hintStyle: TextStyle(fontSize: 15),

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: TextField(
                      controller: quantityTextController,
                      decoration: textFieldFormDecoration(size).copyWith(
                        labelText: 'Quantity',
                        hintText: 'Quantity',
                        hintStyle: TextStyle(fontSize: 15),

                      ),
                    ),
                  ),



                  Row(
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
                            },

                            child: Icon(_isS?Icons.check_box_outlined:Icons.check_box_outline_blank_outlined))
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
                              },

                              child: Icon( _isM?Icons.check_box_outlined:Icons.check_box_outline_blank_outlined))

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
                            },

                            child: Icon( _isL?Icons.check_box_outlined:Icons.check_box_outline_blank_outlined))

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
                              },

                              child: Icon( _isXL?Icons.check_box_outlined:Icons.check_box_outline_blank_outlined))

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
                            },

                            child: Icon(_isXXL?Icons.check_box_outlined:Icons.check_box_outline_blank_outlined))

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
                                });
                              },

                              child: Icon(_isXXXL?Icons.check_box_outlined:Icons.check_box_outline_blank_outlined))

                        ],),
                      ),

                    ],
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
                                itemCount: firebaseProvider.packageIndex==null? colors.isEmpty?0:colors.length:selectedPackageColor.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return   Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                          color:firebaseProvider.packageIndex==null? colors[index] :Color(int.parse(selectedPackageColor[index])),
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
                  updateData(firebaseProvider,publicProvider);
                }, child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(width: 1,color: Colors.green)

                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 5,),
                  child: Text('Update',style: TextStyle(color: Colors.white),),
                ))),
          )
        ],
      ),
    );
  }

  Future<void> updateData(FirebaseProvider firebaseProvider,PublicProvider publicProvider) async {
    if (convertedImages.isEmpty) {
      setState(() {
        imageUrl = firebaseProvider.packageList[firebaseProvider.packageIndex].image;
      });
      _submitData(firebaseProvider,publicProvider);
    } else {

      _submitData(firebaseProvider,publicProvider);
    }
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
          var snapshot = await fs.ref().child('ProductImage').putBlob(image);
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
          var snapshot = await fs.ref().child('PackageThumbnail').child(image.name).putBlob(image);
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


  Future<void> _submitData(
      FirebaseProvider firebaseProvider,PublicProvider publicProvider) async {

    DateTime date = DateTime.now();
    String dateData = '${date.month}-${date.day}-${date.year}';
    setState(() => _isLoading = true);
    Map<String, dynamic> map = {
      'title': titleTextController.text,
      'description': descriptionTextController.text,
      'price': priceTextController.text,
      'discountAmount': discountTextController.text,
      'size':sizes,
      'quantity': quantityTextController.text,
      'colors': FieldValue.arrayUnion(colorList),
      'image': imageUrl,
      'thumbnail': thumbnailURL,
      'date': dateData,
    };

    await firebaseProvider.updatePackageData(map).then((value)async{
      if (value) {

        await firebaseProvider.getProducts().then((value) {
          setState(() {
            publicProvider.subCategory = 'All Package';
            publicProvider.category = '';
          });
        });


        showToast('Package Uploaded Successfully');
        _emptyFildCreator();
        setState(() {

          _isLoading = false;
          setState(() {
            convertedImages.clear();
            imageUrl.clear();
            colorList.clear();
            sizes.clear();
          });
        });
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
    discountTextController.clear();
  }


}
