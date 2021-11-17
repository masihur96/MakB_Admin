import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class WithdrawDetails extends StatefulWidget {
  @override
  _WithdrawDetailsState createState() => _WithdrawDetailsState();
}

class _WithdrawDetailsState extends State<WithdrawDetails> {


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
                  child: Text('Withdraw History',style: TextStyle(fontSize: 20),),
                )),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'ID',textAlign: TextAlign.center,
                    ),
                  ),

                  Expanded(
                    child: Text(
                      'Request Date',textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Transaction No',textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Transaction System',textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Amount',textAlign: TextAlign.center,
                    ),
                  ),

                  Expanded(
                    child: Text(
                      'Status',textAlign: TextAlign.center,
                    ),
                  ),


                ],
              ),
            ),

            ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: firebaseProvider.withdrawHistoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(firebaseProvider
                      .withdrawHistoryList[index].date));
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
                              child: Text('${firebaseProvider.withdrawHistoryList[index].id}',textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),),
                            ),

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
                                '${firebaseProvider.withdrawHistoryList[index].transactionMobileNo}',textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text('${firebaseProvider.withdrawHistoryList[index].transactionSystem}',textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),),
                            ),

                            Expanded(
                              child: Text('${firebaseProvider.withdrawHistoryList[index].amount}',textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),),
                            ),
                            Expanded(
                              child: Text('${firebaseProvider.withdrawHistoryList[index].status}',textAlign: TextAlign.center,
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
          ],
        )
    );
  }


}
