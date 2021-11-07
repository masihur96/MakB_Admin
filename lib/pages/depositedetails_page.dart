import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                  Expanded(child: Text('Date',textAlign: TextAlign.center,style: TextStyle(fontSize: 14),)),
                  Expanded(child: Text('phone',textAlign: TextAlign.center,style: TextStyle(fontSize: 14),)),
                  Expanded(child: Text('Amount',textAlign: TextAlign.center,style: TextStyle(fontSize: 14),)),
                  Expanded(child: Text('Status',textAlign: TextAlign.center,style: TextStyle(fontSize: 14),)),




              ],),
            ),

            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: firebaseProvider.depositHistoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(firebaseProvider
                        .depositHistoryList[index].date));
                    var format = new DateFormat("yMMMd").add_jm();
                    String withdrawDate = format.format(date);
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
                              Expanded(
                                child: Text(
                                  withdrawDate,textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: publicProvider.isWindows
                                        ? size.height * .02
                                        : size.width * .02,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  firebaseProvider.depositHistoryList[index].phone,textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: publicProvider.isWindows
                                        ? size.height * .02
                                        : size.width * .02,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text( firebaseProvider.depositHistoryList[index].amount,textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: publicProvider.isWindows
                                        ? size.height * .02
                                        : size.width * .02,
                                  ),),
                              ),
                              Expanded(
                                child: Text( firebaseProvider.depositHistoryList[index].status,textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: publicProvider.isWindows
                                        ? size.height * .02
                                        : size.width * .02,
                                  ),),
                              ),

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
