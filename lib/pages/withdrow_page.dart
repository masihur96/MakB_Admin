import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:makb_admin_pannel/data_model/dart/withdraw_request_model.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class WithdrowPage extends StatefulWidget {
  @override
  _WithdrowPageState createState() => _WithdrowPageState();
}

class _WithdrowPageState extends State<WithdrowPage> {
  var searchTextController = TextEditingController();

  bool _isLoading = false;

  int counter=0;

  List<WithdrawRequestModel> _subList = [];
  List<WithdrawRequestModel> _filteredList = [];

  customInit(FirebaseProvider firebaseProvider)async{
    setState(() {
      counter++;
    });

    if(firebaseProvider.withdrawRequestList.isEmpty){
      await firebaseProvider.getWithdrawRequest().then((value) {
        setState(() {
          _subList = firebaseProvider.withdrawRequestList;
          _filteredList = _subList;
        });
      });

    }else{
      setState(() {
        _subList = firebaseProvider.withdrawRequestList;
        _filteredList = _subList;
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
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Withdraw Request',
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.normal,

                    )),
              ),
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
                      'Name',textAlign: TextAlign.center,
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
                  Expanded(
                    child: Text(
                      'Approval',textAlign: TextAlign.center,
                    ),
                  ),

                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: _filteredList.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(firebaseProvider
                     .withdrawRequestList[index].date));
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
                                '${_filteredList[index].id}',textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                withdrawDate,textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                               '${_filteredList[index].name}',textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${_filteredList[index].transactionMobileNo}',textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${_filteredList[index].transactionSystem}',textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${_filteredList[index].amount}',textAlign: TextAlign.center,
                              ),
                            ),

                            Expanded(
                              child: Text('${_filteredList[index].status}',textAlign: TextAlign.center,
                              ),
                            ),

                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                       ),
                                      onPressed: (){
                                        showLoaderDialog(context);
                                    // setState(() {
                                    //   _isLoading =true;
                                    // });

                                        _transferedWithdrawRequest(firebaseProvider,index).then((value) {
                                       // _isLoading = false;

                                       Navigator.pop(context);
                                    });

                                  }, child: Text('Approve', style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500))),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                      ),
                                      onPressed: (){
                                     showLoaderDialog(context);
                                        // setState(() {
                                        //   _isLoading =true;
                                        // });

                                        firebaseProvider.getSingleUserData(firebaseProvider.withdrawRequestList[index].id).then((value) {
                                          String requestedAmount = firebaseProvider.withdrawRequestList[index].amount;
                                          String servicharge = firebaseProvider.rateDataList[0].serviceCharge;

                                          int refundAmount = int.parse(requestedAmount)+int.parse(servicharge)+int.parse(firebaseProvider.userMainBalance);

                                          print('Service $servicharge');
                                          print('Requested: $requestedAmount');
                                          print('User Main Balance: ${firebaseProvider.userMainBalance}');
                                          print('Refund $refundAmount');


                                          _refundWithDrawRequest(firebaseProvider,refundAmount,index).then((value) {
                                            // _isLoading = false;

                                            Navigator.pop(context);
                                          });
                                        });






                                      }, child: Text('Refund', style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500))),
                                ],
                              )

                              // InkWell(
                              //   onTap: () {
                              //
                              //     firebaseProvider.getWithdrawHistory(firebaseProvider.withdrawRequestList[index].id).then((value) {
                              //       setState(() {
                              //         publicProvider.subCategory =
                              //         'Withdraw Details';
                              //         publicProvider.category = '';
                              //         setState(() {
                              //           firebaseProvider.withdrawIndex = index;
                              //         });
                              //       });
                              //     });
                              //   },
                              //   child: Icon(
                              //     Icons.visibility,
                              //     size: publicProvider.isWindows
                              //         ? size.height * .02
                              //         : size.width * .02,
                              //     color: Colors.green,
                              //   ),
                              // ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  );
                })
          ],
        )
    );
  }



  Future<void> _transferedWithdrawRequest(
      FirebaseProvider firebaseProvider,int? index) async {

    Map<String, dynamic> map = {
      'status': 'transferred',
    };
    await firebaseProvider.updateStatusData(map,index!).then((value) {
      if (value) {
        showToast('Success');


      } else {

        showToast('Failed');
      }
    });

  }


  Future<void> _refundWithDrawRequest(
      FirebaseProvider firebaseProvider,int? refundAmount,int? index) async {

    Map<String, dynamic> map = {
      'mainBalance': '$refundAmount',
    };
    await firebaseProvider.refundWithdrawAmount(map,index!).then((value) {
      if (value) {
        showToast('Success');


      } else {

        showToast('Failed');
      }
    });

  }
}
