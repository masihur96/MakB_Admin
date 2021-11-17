import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/data_model/dart/package_model.dart';
import 'package:makb_admin_pannel/data_model/dart/package_order_request_model.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class SoledPackage extends StatefulWidget {
  @override
  _SoledPackageState createState() => _SoledPackageState();
}

class _SoledPackageState extends State<SoledPackage> {

  var packageSearchTextController = TextEditingController();

  bool _isLoading=false;

  static const packageStatus = <String> [
    'stored',
    'collected',
  ];
  String packageStatusValue = 'stored';

  List<dynamic> selectOrder = [];
  List<dynamic> selectOrderID = [];

  List<PackageOrderModel> _soldPackageSubList = [];
  List<PackageOrderModel> _soldPackageFilteredList = [];
  List<PackageOrderModel> _soldPackagePendungFilteredList = [];
  int counter =0;
  customInit(FirebaseProvider firebaseProvider)async{
    setState(() {
      counter++;
    });
    setState(() {
      _isLoading = true;
    });

    if(firebaseProvider.soldPackageList.isEmpty){
      await firebaseProvider.getSoldPackage().then((value) {
        setState(() {
          _soldPackageSubList = firebaseProvider.soldPackageList;
          _soldPackageFilteredList = _soldPackageSubList;
          _isLoading = false;
        });
      });
    }else {
      setState(() {
        _soldPackageSubList = firebaseProvider.soldPackageList;
        _soldPackageFilteredList = _soldPackageSubList;
        _isLoading = false;
      });
    }

  }

  _packagePendingFilterList(String searchItem) {
    setState(() {
      _soldPackageFilteredList = _soldPackageSubList
          .where((element) =>
      (element.status!.toLowerCase().contains(searchItem.toLowerCase())))
          .toList();

      _soldPackagePendungFilteredList = _soldPackageFilteredList;
    });
  }
  _packageFilterList(String searchItem) {
    setState(() {
      _soldPackageFilteredList = _soldPackagePendungFilteredList
          .where((element) =>
      (element.productName!.toLowerCase().contains(searchItem.toLowerCase())))
          .toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);

    if(counter==0){
      customInit(firebaseProvider);
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
                controller: packageSearchTextController,
                decoration: textFieldFormDecoration(size).copyWith(
                  hintText: 'Search By Package Name',
                  hintStyle: TextStyle(
                    fontSize: publicProvider.isWindows
                        ? size.height * .02
                        : size.width * .02,
                  ),
                ),
                onChanged: _packageFilterList,
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
                        return   StatefulBuilder(
                            builder: (context, setState){
                              return AlertDialog(
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
                                        child: Text('Are you confirm to delete this Item ?',style: TextStyle(fontSize: 14,color: Colors.black),),
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

                                  _isLoading?fadingCircle:
                                  TextButton(
                                    child: Text('Ok'),
                                    onPressed: () {

                                      setState(() {
                                        _isLoading = true;
                                        showLoaderDialog(context);
                                      });


                                      var db = FirebaseFirestore.instance;
                                      WriteBatch batch = db.batch();
                                      for (String id in selectOrderID) {
                                        DocumentReference ref =
                                        db.collection("SoldPackages").doc(id);
                                        batch.delete(ref);
                                      }
                                      batch.commit().then((value) {
                                        firebaseProvider.getSoldPackage();
                                         customInit(firebaseProvider);
                                        selectOrder.clear();
                                        selectOrderID.clear();
                                        Navigator.of(context).pop();
                                        setState(() {
                                          _isLoading = false;
                                          // showLoaderDialog(context);
                                        });
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            }

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
                      selectOrder.clear();
                      selectOrderID.clear();
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
                IconButton(onPressed: (){

                  setState(() {
                    _isLoading = true;
                  });

                  firebaseProvider.getSoldPackage().then((value) => _isLoading = false);

                }, icon: Icon(Icons.refresh_outlined,color: Colors.green,)),
                Text('Ordered Type : ',style: TextStyle(fontSize: 15),),

                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: packageStatusValue,
                    elevation: 0,
                    dropdownColor: Colors.white,
                    style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.025:size.height*.025),
                    items: packageStatus.map((itemValue) {
                      return DropdownMenuItem<String>(
                        value: itemValue,
                        child: Text(itemValue),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        packageStatusValue = newValue!;
                      });
                      _packagePendingFilterList(packageStatusValue);
                    },
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
                Text('#',textAlign: TextAlign.center, style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                Expanded(child: Text('Customer Info',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
                Expanded(child: Text('Date',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
                Expanded(child: Text('Package Name',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
                Expanded(child: Text('Price',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
                Expanded(child: Text('Discount',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
                Expanded(child: Text('Quantity',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
                Expanded(child: Text('Order Status',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),

              ],),
          ),
          _isLoading?Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: fadingCircle,
          ):
          ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: _soldPackageFilteredList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    children: [
                      Divider(height: 1,color: Colors.grey,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          InkWell(
                              onTap: (){
                                setState(() {
                                  if(selectOrder.contains(index)){
                                    selectOrder.remove(index);
                                    selectOrderID.remove(_soldPackageFilteredList[index].id);
                                  }
                                  else {
                                    selectOrder.add(index);
                                    selectOrderID.add(_soldPackageFilteredList[index].id);
                                  }
                                });

                                    print(selectOrderID);
                              },
                              child: selectOrder.contains(index)? Icon(Icons.check_box_outlined):Icon(Icons.check_box_outline_blank)),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_soldPackageFilteredList[index].userName!,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                  Text(_soldPackageFilteredList[index].userAddress!,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                  Text(_soldPackageFilteredList[index].userPhone!,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              child: Text(_soldPackageFilteredList[index].date!,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
                          Expanded(
                            child: Text(_soldPackageFilteredList[index].productName!,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.green ,),),
                          ),
                          Expanded(
                            child: Text(_soldPackageFilteredList[index].productPrice!,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.grey ,),),
                          ),
                          Expanded(
                            child: Text(_soldPackageFilteredList[index].discount!,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.grey ,),),
                          ),
                          Expanded(
                            child: Text(_soldPackageFilteredList[index].quantity!,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.grey ,),),
                          ),

                          Expanded(
                            child: Text(_soldPackageFilteredList[index].status!,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.grey ,),),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
          )

        ],
      )
    );
  }
}
