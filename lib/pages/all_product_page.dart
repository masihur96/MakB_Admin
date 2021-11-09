import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/data_model/dart/category_model.dart';
import 'package:makb_admin_pannel/data_model/dart/product_model.dart';
import 'package:makb_admin_pannel/data_model/dart/sub_category_model.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class AllProductPage extends StatefulWidget {
  @override
  _AllProductPageState createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage> {

  var searchTextController = TextEditingController();
  bool _isLoading = false;
  //Category Variable
  String categorysValue='';
  String subCategorysValue = '';
  List <CategoryModel> caterorys = [];
  List <SubCategoryModel> subCategorys = [];


 List selectedProduct=[]; //selected product for check
 List selectedProductID=[]; //selected product ID for Delete

  final List<String> imgList = [];

  int _currentIndex = 0;

  int counter = 0;
  List<ProductModel> _subList = [];
  List<ProductModel> _filteredList = [];
  _customInit(FirebaseProvider firebaseProvider) async{
    setState(() {
      counter++;

    });
    setState(() {
      _isLoading =true;
    });

    if(firebaseProvider.categoryList.isEmpty){

      await firebaseProvider.getCategory().then((value) {
        setState(() {
          caterorys = firebaseProvider.categoryList;
          categorysValue = caterorys[0].category!;

          _isLoading =false;
        });
      });


    }else{
      setState(() {
        caterorys = firebaseProvider.categoryList;
        categorysValue = caterorys[0].category!;

        _isLoading =false;
      });

    }

    if(firebaseProvider.subCategoryList.isEmpty){
      await firebaseProvider.getSubCategory().then((value) {
        setState(() {
          subCategorys = firebaseProvider.subCategoryList;
          subCategorysValue = subCategorys[0].subCategory!;
          _isLoading =false;
        });
      });
    }else {
      setState(() {
        subCategorys = firebaseProvider.subCategoryList;
        subCategorysValue = subCategorys[0].subCategory!;
        _isLoading =false;
      });
    }

   if(firebaseProvider.productList.isEmpty){
     await firebaseProvider.getProducts().then((value) {
       setState(() {
         _subList = firebaseProvider.productList;
         _filteredList = _subList;
         _isLoading =false;
       });
     });
   }else{
     setState(() {
       _subList = firebaseProvider.productList;
       _filteredList = _subList;
       _isLoading =false;
     });

   }


  }


  _filterList(String searchItem) {
    setState(() {
      _filteredList = _subList
          .where((element) =>
      (element.title!.toLowerCase().contains(searchItem.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);

    if(counter ==0){
      _customInit(firebaseProvider);
    }
    return Container(
      width: publicProvider.pageWidth(size),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: size.height*.4,
              child: TextField(
                controller: searchTextController,
                decoration: textFieldFormDecoration(size).copyWith(
                  hintText: 'Search Product By Title',
                  hintStyle: TextStyle(
                    fontSize: publicProvider.isWindows
                        ? size.height * .02
                        : size.width * .02,
                  ),
                ),
                onChanged: _filterList,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: (){
                      showDialog(context: context, builder: (_){
                        return   AlertDialog(
                          title: Text('Alert'),
                          content: Container(
                            height: publicProvider.isWindows?size.height*.2:size.width*.2,

                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.warning_amber_outlined,color: Colors.yellow,size: 40,),

                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Text('Are you confirm to delete this Product ?',style: TextStyle(fontSize: 14,color: Colors.black),),
                                ),
                              ],),

                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Ok'),

                              onPressed: () {

                                var db = FirebaseFirestore.instance;
                                WriteBatch batch = db.batch();
                                for (String id in selectedProductID) {
                                  DocumentReference ref = db.collection("Products").doc(id);
                                  batch.delete(ref);
                                }
                                batch.commit().then((value) {
                                  firebaseProvider.getProducts();
                                  selectedProduct.clear();
                                  Navigator.of(context).pop();
                                });

                                selectedProductID.forEach((element) {

                                  deleteSinglePhoto(firebaseProvider.productList[element].image);
                                });

                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      }) ;
                    },
                    icon: Icon(
                      Icons.delete_outline,size: 20,
                      color: Colors.red,
                    )),
                TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: (){

                    setState(() {
                      selectedProduct.clear();
                      selectedProductID.clear();
                    });

                  }, child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text('Clear All Selection ',
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      )),
                ),


                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  '#',
                  style: TextStyle(
                    fontSize: publicProvider.isWindows
                        ? size.height * .02
                        : size.width * .02,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Text(
                    'Photo',
                    style: TextStyle(
                      fontSize: publicProvider.isWindows
                          ? size.height * .02
                          : size.width * .02,
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    'Product Title',textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: publicProvider.isWindows
                          ? size.height * .02
                          : size.width * .02,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Price',textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: publicProvider.isWindows
                          ? size.height * .02
                          : size.width * .02,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Profit',textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: publicProvider.isWindows
                          ? size.height * .02
                          : size.width * .02,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Category',textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: publicProvider.isWindows
                          ? size.height * .02
                          : size.width * .02,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Action',textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: publicProvider.isWindows
                          ? size.height * .02
                          : size.width * .02,
                    ),
                  ),
                ),

              ],
            ),
          ),

          _isLoading?Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: fadingCircle,
          ):
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount:_filteredList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Column(
                      children: [
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
                            InkWell(
                                onTap: (){
                                  setState(() {



                                    if(selectedProduct.contains(index)){
                                      selectedProductID.remove(_filteredList[index].id);
                                      selectedProduct.remove(index);
                                    }else {

                                      selectedProductID.add(_filteredList[index].id);
                                      selectedProduct.add(index);

                                      print(selectedProductID);
                                    }


                                  });
                                },
                                child: selectedProduct. contains(index)?Icon(Icons.check_box_outlined):Icon(Icons.check_box_outline_blank_outlined)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 28.0),
                              child: Container(
                                  height: publicProvider.isWindows
                                      ? size.height * .04
                                      : size.width * .04,
                                  width: publicProvider.isWindows
                                      ? size.height * .03
                                      : size.width * .03,
                                  child: Image.network(
                                    _filteredList[index].image![0],
                                    fit: BoxFit.fill,
                                  )),
                            ),

                            Expanded(
                              child: Text(
                                '${_filteredList[index].title}',textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text('${_filteredList[index].price}',textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),),
                            ),
                            Expanded(
                              child: Text('${_filteredList[index].profitAmount}',textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),),
                            ),
                            Expanded(
                              child: Text('${_filteredList[index].category}',textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {

                                      setState(() {
                                        firebaseProvider.productIndex = index;
                                      });

                                        showDialog(context: context, builder: (_){
                                          return   AlertDialog(
                                            title: Text('Product Details'),
                                            content: Container(
                                              height: publicProvider.isWindows?size.height*.6:size.width*.6,
                                              width: publicProvider.isWindows?size.height:size.width*.8,
                                              child:ListView(
                                                children: [

                                                  publicProvider.isWindows? SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                            width:publicProvider.isWindows?size.height/2:size.width*.8/2,
                                                            child: productImageList(publicProvider,size,index,firebaseProvider)
                                                        ),
                                                        Container(
                                                            width:publicProvider.isWindows?size.height/2:size.width*.8/2,
                                                            child: productDetailsData(publicProvider,firebaseProvider,index,size))
                                                      ],
                                                    ),
                                                  ): Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                          width:publicProvider.pageWidth(size)*.5,
                                                          child: productImageList(publicProvider,size,index,firebaseProvider)
                                                      ),
                                                      productDetailsData(publicProvider,firebaseProvider,index,size)
                                                    ],
                                                  ),

                                                ],
                                              )

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
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.visibility,
                                        size: publicProvider.isWindows
                                            ? size.height * .02
                                            : size.width * .02,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget productImageList(PublicProvider publicProvider,Size size,int index,FirebaseProvider firebaseProvider){
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
                  height:publicProvider.isWindows?size.height*.4:size.width*.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 1,color: Colors.grey)
                  ),
                  child:firebaseProvider.productList[index].image.isNotEmpty? Container(
                    child: Image.network(firebaseProvider.productList[index].image[_currentIndex],fit: BoxFit.cover,) ,
                  ):Container(),
                ),
              ]

          ),
          Container(
            height:publicProvider.isWindows?size.height*.15:size.width*.15,
            width:publicProvider.isWindows?size.height/2:size.width*.8/2,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount:firebaseProvider.productList[index].image.length==0?3:firebaseProvider.productList[index].image.length,
                itemBuilder: (BuildContext ctx, indx) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          _currentIndex = indx;
                        });
                      },
                      child: firebaseProvider.productList[index].image.isNotEmpty?  Container(
                          width: publicProvider.pageWidth(size)*.07,
                          height: publicProvider.isWindows?size.height*.2:size.width*.2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              border: Border.all(width: 1,color: Colors.grey)
                          ),
                          alignment: Alignment.center,
                          child:Image.network(firebaseProvider.productList[index].image[indx],fit: BoxFit.cover,)

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
  Widget productDetailsData(PublicProvider publicProvider,FirebaseProvider firebaseProvider,int index,Size size){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Product Details',style: TextStyle(fontSize: 20),),
          ),
          Container(
            width:publicProvider.isWindows?size.height/2:size.width*.8/2,

            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(width: 1,color: Colors.grey)

            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: Text(firebaseProvider.productList[index].title,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.025:size.width*.025,) ,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                      child:  Text( 'Description: ${firebaseProvider.productList[index].description}',style: TextStyle(fontSize:  publicProvider.isWindows?size.height*.025:size.width*.025,) ,)
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                      child:  Text( 'Price: ${firebaseProvider.productList[index].price}',style: TextStyle(fontSize:  publicProvider.isWindows?size.height*.025:size.width*.025,) ,)
                  ),
                  firebaseProvider.productList[index].colors.length==0?SizedBox():   Padding(
                      padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                      child:  Container(
                        // width: size.height*.5,
                        height: 30,
                        child: Row(
                          children: [
                            Text('Color:',style: TextStyle(fontSize:  publicProvider.isWindows?size.height*.025:size.width*.025,) ,),
                            ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount:firebaseProvider.productList[index].colors.length,
                                itemBuilder: (_,idx){
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                          color: Color( int.parse(firebaseProvider.productList[index].colors[idx])) ,
                                          shape: BoxShape.circle
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      )
                  ),

                  firebaseProvider.productList[index].size.length==0?SizedBox():  Container(
                    // width: size.height*.5,
                    height: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Size:',style: TextStyle(fontSize:  publicProvider.isWindows?size.height*.025:size.width*.025,) ,),

                        ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount:firebaseProvider.productList[index].size.length,
                            itemBuilder: (_,idx){
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(firebaseProvider.productList[index].size[idx],style: TextStyle(fontSize:  publicProvider.isWindows?size.height*.025:size.width*.025,) ,),
                              );
                            }),
                      ],
                    ),
                  ),

                  Padding(
                      padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                      child:  Text('Profit Amount: ${firebaseProvider.productList[index].profitAmount}',style: TextStyle(fontSize:  publicProvider.isWindows?size.height*.025:size.width*.025,) ,)
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                      child:  Text('Category:  ${firebaseProvider.productList[index].category}',style: TextStyle(fontSize:  publicProvider.isWindows?size.height*.025:size.width*.025,) ,)
                  ),

                  Padding(
                      padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                      child:  Text('Subcategory: ${firebaseProvider.productList[index].subCategory}',style: TextStyle(fontSize:  publicProvider.isWindows?size.height*.025:size.width*.025,) ,)
                  ),


                  Text('Upload Date: ${firebaseProvider.productList[index].date}',style: TextStyle(fontSize:  publicProvider.isWindows?size.height*.025:size.width*.025,) ,),


                ],),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: (){

                  setState(() {
                    publicProvider.subCategory = 'Update Product';
                    publicProvider.category = '';
                  });


                  Navigator.pop(context);
                }, child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(width: 1,color: Colors.green)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 5,),
                  child: Text('Update',style: TextStyle(color: Colors.white,fontSize:  publicProvider.isWindows?size.height*.03:size.width*.03,),),
                ))),
          )
        ],
      ),
    );
  }


  Future deleteSinglePhoto(List<dynamic> photos) async {
    try {
      if (photos.isNotEmpty) {
        for (var photo in photos) {
          print('deleting $photo');
          await FirebaseStorage.instance.refFromURL(photo).delete();
        }
      }
    } catch (error) {
      print('deleting single photo error: $error');
    }
  }
}
