import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class DepositeDetails extends StatefulWidget {
  @override
  _DepositeDetailsState createState() => _DepositeDetailsState();
}

class _DepositeDetailsState extends State<DepositeDetails> {

  var addDepositTextController = TextEditingController();
  var updateDepositTextController = TextEditingController();
  var oTPTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);
    return Container(
        width: publicProvider.pageWidth(size),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Image.network(firebaseProvider.userList[firebaseProvider.depositIndex].imageUrl,fit: BoxFit.fill,),),
                SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),
                    Text(firebaseProvider.userList[firebaseProvider.depositIndex].name,style: TextStyle(fontSize: 20,color: Colors.black),),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Text(firebaseProvider.userList[firebaseProvider.depositIndex].address,style: TextStyle(fontSize: 14,color: Colors.black),),
                    ),
                    Text(firebaseProvider.userList[firebaseProvider.depositIndex].phone,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Text('Start from:${firebaseProvider.day.toString()+'/'+firebaseProvider.month.toString()+'/'+firebaseProvider.year.toString()}',style: TextStyle(fontSize: 14,color: Colors.black),),
                    ),
                    Text('Deposit Balance: ${firebaseProvider.userList[firebaseProvider.depositIndex].depositBalance}',style: TextStyle(fontSize: 14,color: Colors.black),),
                  ],)
              ],),
            ),
            Row(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  onPressed: () async{
                    showDialog(context: context, builder: (_){
                      return   AlertDialog(
                        title: Text('Add Balance'),
                        content: Container(

                          height: publicProvider.isWindows?size.height*.3:size.width*.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                                child: TextField(
                                  controller: oTPTextController,
                                  decoration: textFieldFormDecoration(size).copyWith(
                                    labelText: 'OTP',
                                    hintText: 'OTP',
                                    hintStyle: TextStyle(fontSize: 15),

                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                                child: TextField(
                                  controller: addDepositTextController,
                                  decoration: textFieldFormDecoration(size).copyWith(
                                    labelText: 'Amount',
                                    hintText: 'Amount',
                                    hintStyle: TextStyle(fontSize: 15),

                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              ElevatedButton(

                                  style: ElevatedButton.styleFrom(

                                    primary: Colors.green,
                                  ),
                                  onPressed: (){



                                    _addDeposite(firebaseProvider);


                                  }, child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                child: Text('Add',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ))

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
                  child: Text('Add Balance',style: TextStyle(fontSize: 15,color: Colors.white),)),

                SizedBox(width: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    onPressed: () {

                      showDialog(context: context, builder: (_){
                        return   AlertDialog(
                          title: Text('Update Balance'),
                          content: Container(

                            height: publicProvider.isWindows?size.height*.3:size.width*.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                                  child: TextField(
                                    controller: oTPTextController,
                                    decoration: textFieldFormDecoration(size).copyWith(
                                      labelText: 'OTP',
                                      hintText: 'OTP',
                                      hintStyle: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                                  child: TextField(
                                    controller: addDepositTextController,
                                    decoration: textFieldFormDecoration(size).copyWith(
                                      labelText: 'Amount',
                                      hintText: 'Amount',
                                      hintStyle: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                ElevatedButton(

                                    style: ElevatedButton.styleFrom(

                                      primary: Colors.green,
                                    ),
                                    onPressed: (){

                                      _updateDeposit(firebaseProvider);


                                    }, child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                  child: Text('Update',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ))

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
                    child: Text('Update Balance',style: TextStyle(fontSize: 15,color: Colors.white),)),
              ),
            ],),

            SizedBox(height: 40,),
            Align(
              alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Deposit History',style: TextStyle(fontSize: 20),),
                )),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text('Date',style: TextStyle(fontSize: 14),),
                Text('Status',style: TextStyle(fontSize: 14),),
                Text('Amount',style: TextStyle(fontSize: 14),),
                Text('From',style: TextStyle(fontSize: 14),),
                Text('Deposit Balance',style: TextStyle(fontSize: 14),),

              ],),
            ),

            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '06/10/2021',
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),
                              ),
                              Text(
                                'Withdraw',
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),
                              ),
                              Text('5000 tk',
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),),
                              Text('Manually',
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),),
                              Center(child: Text('30,00 tk',
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),)),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ],
        )
    );
  }

  Future<void> _addDeposite(
      FirebaseProvider firebaseProvider) async {

  //  setState(() => _isLoading = true);
    Map<String, dynamic> map = {
    //  'depositPreBalance': addDepositTextController.text,
      'depositBalance': int.parse(firebaseProvider.userList[firebaseProvider.depositIndex].depositBalance)+int.parse(addDepositTextController.text),
    };
    await firebaseProvider.addDepositData(map,firebaseProvider.userList[firebaseProvider.depositIndex].id).then((value) {
      if (value) {
        print('Success');
        // _emptyFildCreator();
        setState(() {
       //   _isLoading = false;
        });
      } else {
     //   setState(() => _isLoading = false);
        print('Failed');
      }
    });

  }

  Future<void> _updateDeposit(
      FirebaseProvider firebaseProvider) async {
    //  setState(() => _isLoading = true);
    Map<String, dynamic> map = {
      'depositBalance': addDepositTextController.text,
    };
    await firebaseProvider.updateDepositData(map,firebaseProvider.userList[firebaseProvider.depositIndex].id).then((value) {
      if (value) {
        print('Success');
        // _emptyFildCreator();
        setState(() {
          //   _isLoading = false;
        });
      } else {
        //   setState(() => _isLoading = false);
        print('Failed');
      }
    });

  }

}
