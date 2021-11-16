import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/data_model/dart/customer_data_model.dart';
import 'package:makb_admin_pannel/pages/pdf_all_customer.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {

  var searchTextController = TextEditingController();
  int? level;

  bool _isLoading = false;

  int counter=0;

  List<UserModel> _subList = [];
  List<UserModel> _filteredList = [];

  customInit(FirebaseProvider firebaseProvider)async{
    setState(() {
      counter++;
    });
    setState(() {
      _isLoading = true;
    });

    if(firebaseProvider.userList.isEmpty){
      await firebaseProvider.getUser().then((value) {
        setState(() {
          _subList = firebaseProvider.userList;
          _filteredList = _subList;
          _isLoading = false;
        });
      });

    }else{
      setState(() {
        _subList = firebaseProvider.userList;
        _filteredList = _subList;
        _isLoading = false;
      });
    }



  }

  _filterList(String searchItem) {
    setState(() {
      _filteredList = _subList
          .where((element) =>
      (element.id!.toLowerCase().contains(searchItem.toLowerCase())))
          .toList();
    });
  }

  List deleteList =[];
  List selectedCustomerID = [];


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
        child: Column(
          children: [
            Center(
              child: Text('Customer List ',
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontSize: publicProvider.isWindows
                        ? size.height * .05
                        : size.width * .05,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: size.height*.4,
                child: TextField(
                  controller: searchTextController,
                  decoration: textFieldFormDecoration(size).copyWith(
                    hintText: 'Search Customer By ID',
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                                        child: Text('Are you confirm to delete this customer ?',style: TextStyle(fontSize: 14,color: Colors.black),),
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
                                      for (String id in selectedCustomerID) {
                                        DocumentReference ref =
                                        db.collection("Users").doc(id);
                                        batch.delete(ref);
                                      }
                                      batch.commit().then((value) {
                                        customInit(firebaseProvider);
                                        deleteList.clear();
                                        selectedCustomerID.clear();
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
                            deleteList.clear();
                            selectedCustomerID.clear();

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
                        firebaseProvider.getUser().then((value) {

                          setState(() {
                            publicProvider.subCategory =
                            'Customer';
                            publicProvider.category = '';
                            _isLoading = false;
                          });
                           // _isLoading = false;
                        });
                      }, icon: Icon(Icons.refresh_outlined,color: Colors.green,))
                    ],
                  ),

                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                      onPressed: (){

                        AllCustomerPDF.allCustomerPdf(_filteredList, 'Customer Details', context, publicProvider);

                  }, child: Text('Print',style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.normal

                  ),))


                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0),
                    child: Text(
                      '#',
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'ID',textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'Photo', textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Name',textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Info',textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Refer',textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Level',textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Balance',textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      ),
                    ),
                  ),
                  Text(
                    'Details',textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: publicProvider.isWindows
                          ? size.height * .02
                          : size.width * .02,
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
                  itemCount: _filteredList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            InkWell(
                              onTap: (){

                                setState(() {

                                  if(deleteList.contains(index)){
                                    selectedCustomerID.remove(_filteredList[index].id);
                                    deleteList.remove(index);
                                  }else {
                                    deleteList.add(index);
                                    selectedCustomerID.add(_filteredList[index].id);
                                  }


                                });
                              },
                                child: deleteList. contains(index)?Icon(Icons.check_box_outlined,size: 15,):Icon(Icons.check_box_outline_blank_outlined,size: 15,)),
                            Expanded(
                              child: Text(
                                '${_filteredList[index].id}',textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                width: 30,
                                height: 30,


                                child:_filteredList[index].imageUrl != null? Image.network(
                                  _filteredList[index].imageUrl!,fit:BoxFit.fill,


                                ):Container(),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${_filteredList[index].name}',textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('${_filteredList[index].address}',textAlign: TextAlign.center,),
                                  _filteredList[index].email !=''? Text('${_filteredList[index].email}',textAlign: TextAlign.center,):Container(),
                                  Text('${_filteredList[index].phone}',textAlign: TextAlign.center,),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TextButton(onPressed: (){

                                firebaseProvider.getReferCode(_filteredList[index].id!).then((value) {

                                  showDialog(context: context, builder: (_){
                                    return   AlertDialog(
                                      title: Text('Refer Details'),
                                      content: Container(
                                        height: publicProvider.isWindows?size.height*.6:size.width*.6,
                                        width: publicProvider.isWindows?size.height*.9:size.width*.9,
                                        child:ListView(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [


                                                      Text( '${_filteredList[index].name}',style: TextStyle(fontSize: 20,color: Colors.black),),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                        child: Text( 'Refer Code: ${_filteredList[index].referCode}',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                      ),

                                                      Text('Refer Date: ${_filteredList[index].referDate}',style: TextStyle(fontSize: 14,color: Colors.black),),

                                                      Text('Refer Limit: ${_filteredList[index].referLimit}',),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                        child: Text('Total Referee: ${_filteredList[index].numberOfReferred}',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                      ),
                                                    ],),

                                                  Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),

                                                    child: Image.network(_filteredList[index].imageUrl!,fit: BoxFit.fill,),),

                                                ],),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [

                                                  Expanded(
                                                    child: Text(
                                                      'ID',textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: publicProvider.isWindows
                                                            ? size.height * .02
                                                            : size.width * .02,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Name',textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: publicProvider.isWindows
                                                            ? size.height * .02
                                                            : size.width * .02,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Phone',textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: publicProvider.isWindows
                                                            ? size.height * .02
                                                            : size.width * .02,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Refer Code',textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: publicProvider.isWindows
                                                            ? size.height * .02
                                                            : size.width * .02,
                                                      ),
                                                    ),
                                                  ),

                                                  Expanded(
                                                    child: Text(
                                                      'Refer Date',textAlign: TextAlign.center,
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

                                                ],
                                              ),
                                            ),
                                            ListView.builder(
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.all(8),
                                            itemCount: firebaseProvider.referList.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                child: Row(
                                                  children: [
                                                    Expanded(child: Text(firebaseProvider.referList[index].id,textAlign: TextAlign.center,style: TextStyle(
                                                      fontSize: publicProvider.isWindows
                                                          ? size.height * .02
                                                          : size.width * .02,
                                                    ),)),
                                                    Expanded(child: Text(firebaseProvider.referList[index].name,textAlign: TextAlign.center,style: TextStyle(
                                                      fontSize: publicProvider.isWindows
                                                          ? size.height * .02
                                                          : size.width * .02,
                                                    ),)),
                                                    Expanded(child: Text(firebaseProvider.referList[index].phone,textAlign: TextAlign.center,style: TextStyle(
                                                      fontSize: publicProvider.isWindows
                                                          ? size.height * .02
                                                          : size.width * .02,
                                                    ),)),
                                                    Expanded(child: Text(firebaseProvider.referList[index].referCode,textAlign: TextAlign.center,style: TextStyle(
                                                      fontSize: publicProvider.isWindows
                                                          ? size.height * .02
                                                          : size.width * .02,
                                                    ),)),
                                                    Expanded(child: Text(firebaseProvider.referList[index].date,textAlign: TextAlign.center,style: TextStyle(
                                                      fontSize: publicProvider.isWindows
                                                          ? size.height * .02
                                                          : size.width * .02,
                                                    ),)),
                                                    Expanded(child: Text(firebaseProvider.referList[index].profit,textAlign: TextAlign.center,style: TextStyle(
                                                      fontSize: publicProvider.isWindows
                                                          ? size.height * .02
                                                          : size.width * .02,
                                                    ),)),

                                                ],),
                                              );
                                            }
                                            ),

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

                                });



                              }, child:  Text(firebaseProvider.userList[index].numberOfReferred,textAlign: TextAlign.center,style: TextStyle(color: Colors.green),)),
                            ),

                            Expanded(child: Text(firebaseProvider.userList[index].level,textAlign: TextAlign.center,)),

                            Expanded(child: Text(firebaseProvider.userList[index].mainBalance,textAlign: TextAlign.center,)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(

                                    onTap: () {

                                      firebaseProvider.getWithdrawHistory(firebaseProvider.userList[index].id).then((value) {
                                        showDialog(context: context, builder: (_){
                                          return   AlertDialog(
                                            title: Text('Customer Details'),
                                            content: Container(
                                              height: publicProvider.isWindows?size.height*.6:size.width*.6,
                                              width: publicProvider.isWindows?size.height*.7:size.width*.7,
                                              child:SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [

                                                              Container(
                                                                height: 100,
                                                                width: 100,
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),

                                                                child: Image.network(firebaseProvider.userList[index].imageUrl,fit: BoxFit.fill,),),
                                                              Text( firebaseProvider.userList[index].name,style: TextStyle(fontSize: 20,color: Colors.black),),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                                child: Text( firebaseProvider.userList[index].id,style: TextStyle(fontSize: 14,color: Colors.black),),
                                                              ),
                                                              Text(firebaseProvider.userList[index].nbp,style: TextStyle(fontSize: 14,color: Colors.black),),
                                                              firebaseProvider.userList[index].email != ''? Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                                child: Text(firebaseProvider.userList[index].email,style: TextStyle(fontSize: 14,color: Colors.black),),
                                                              ):Container(),
                                                              Text(firebaseProvider.userList[index].phone,),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                                child: Text('Start from: ${firebaseProvider.userList[index].lastInsurancePaymentDate}',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                                child: Text('Deposit Balance: ${firebaseProvider.userList[index].depositBalance}',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                                child: Text('Insurance Balance: ${firebaseProvider.userList[index].insuranceBalance}',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                                child: Text('Main Balance: ${firebaseProvider.userList[index].mainBalance}',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                              ),
                                                            ],),
                                                          Container(
                                                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),

                                                                border: Border.all(width: 1,color: Colors.grey)
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    height: 100,
                                                                    width: 100,
                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                    child: Image.asset(int.parse(firebaseProvider.userList[index].level)<=99? 'assets/images/normal.png':
                                                                    int.parse(firebaseProvider.userList[index].level)<199? 'assets/images/bronz.png':
                                                                    int.parse(firebaseProvider.userList[index].level)<299? 'assets/images/silver.png':
                                                                    int.parse(firebaseProvider.userList[index].level)<399? 'assets/images/gold.png':
                                                                    int.parse(firebaseProvider.userList[index].level)<499? 'assets/images/platinum.png':
                                                                    'assets/images/premeum.png'
                                                                      ,fit: BoxFit.fill,),),
                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                                                                    child: Text(int.parse(firebaseProvider.userList[index].level)<=99?'Regular':
                                                                    int.parse(firebaseProvider.userList[index].level)<199?'Bronze':
                                                                    int.parse(firebaseProvider.userList[index].level)<299?'Silver':
                                                                    int.parse(firebaseProvider.userList[index].level)<399?'Gold':
                                                                    int.parse(firebaseProvider.userList[index].level)<499?'Platinum':
                                                                    'Premium'
                                                                      ,style: TextStyle(fontSize: 14,color: Colors.black),),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        TextButton(onPressed: (){
                                                          setState(() {
                                                            publicProvider.subCategory =
                                                            'DepositDetails';
                                                            publicProvider.category = '';
                                                            setState(() {
                                                              firebaseProvider.depositIndex = index;
                                                            });
                                                          });
                                                          Navigator.pop(context);
                                                        }, child: Text('Deposit')),

                                                        TextButton(onPressed: (){
                                                          setState(() {
                                                            publicProvider.subCategory =
                                                            'Withdraw Details';
                                                            publicProvider.category = '';
                                                            firebaseProvider.withdrawIndex = index;
                                                          });
                                                          Navigator.pop(context);
                                                        }, child: Text('Withdraw')),
                                                        // TextButton(onPressed: (){
                                                        //   setState(() {
                                                        //     firebaseProvider.insuranceID = index;
                                                        //     publicProvider.subCategory =
                                                        //     'InsuranceDetails';
                                                        //     publicProvider.category = '';
                                                        //   });
                                                        //   Navigator.pop(context);
                                                        // }, child: Text('Insurance')),
                                                      ],)
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
                                        }) ;
                                      });




                                    },
                                    child: Icon(
                                      Icons.visibility,
                                      size: publicProvider.isWindows
                                          ? size.height * .02
                                          : size.width * .02,
                                      color: Colors.green,
                                    ),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Center(
                                  //         child: Icon(
                                  //           Icons.edit,
                                  //           color: Colors.green,
                                  //           size: publicProvider.isWindows
                                  //               ? size.height * .03
                                  //               : size.width * .03,
                                  //         )),
                                  //     SizedBox(
                                  //       width: 15,
                                  //     ),
                                  //     Center(
                                  //         child: Icon(
                                  //           Icons.cancel,
                                  //           color: Colors.red,
                                  //           size: publicProvider.isWindows
                                  //               ? size.height * .03
                                  //               : size.width * .03,
                                  //         )),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),


                          ],
                        ),
                      ],
                    );
                  }),
            )
          ],
        )

    );
  }
}
