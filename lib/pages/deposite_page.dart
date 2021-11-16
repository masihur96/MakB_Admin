import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:makb_admin_pannel/data_model/dart/customer_data_model.dart';
import 'package:makb_admin_pannel/data_model/dart/depositeRequestModel.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';


import 'package:provider/provider.dart';

class DepositePage extends StatefulWidget {

  @override
  _DepositePageState createState() => _DepositePageState();
}

class _DepositePageState extends State<DepositePage> {
  bool _isLoading=false;
  var searchTextController = TextEditingController();
  var depositTextController = TextEditingController();

  List<DepositRequestModel> _subList = [];
  List<DepositRequestModel> _filteredList = [];

  int counter=0;
  customInit(FirebaseProvider firebaseProvider)async{
    setState(() {
      counter++;
    });

    setState(() {
      _isLoading = true;
    });

    if(firebaseProvider.depositRequestList.isEmpty){
      await firebaseProvider.getDepositRequest().then((value) {
        setState(() {
          _subList = firebaseProvider.depositRequestList;
          _filteredList = _subList;
          _isLoading = false;
        });
      });
    }else{
      setState(() {
        _subList = firebaseProvider.depositRequestList;
        _filteredList = _subList;
        _isLoading = false;
      });
    }
  }


  _filterList(String searchItem) {
    setState(() {
      _filteredList = _subList
          .where((element) =>
      (element.phone!.toLowerCase().contains(searchItem.toLowerCase())))
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
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Depositor List ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontStyle: FontStyle.normal,

                  )),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Container(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: size.height*.4,
                  child: TextField(
                    controller: searchTextController,
                    decoration: textFieldFormDecoration(size).copyWith(
                      hintText: 'Search Depositor By ID',
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

              IconButton(onPressed: (){

                setState(() {
                  _isLoading = true;
                });

                firebaseProvider.getDepositRequest().then((value) => _isLoading = false);

              }, icon: Icon(Icons.refresh_outlined,color: Colors.green,))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Expanded(
                  child: Text(
                    'Name',textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Phone',textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Date',textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Deposit Amount',textAlign: TextAlign.center,
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
          _isLoading?Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: fadingCircle,
          ):
          ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: _filteredList.length,
              itemBuilder: (BuildContext context, int index) {
                DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(firebaseProvider
                    .depositRequestList[index].date));
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
                                '${_filteredList[index].name}',textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${_filteredList[index].phone}',textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                withdrawDate,textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text('${_filteredList[index].amount==''?'--':_filteredList[index].amount}',textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text('${_filteredList[index].status}',textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                  ),
                                  onPressed: (){


                                    showDialog(context: context, builder: (_){
                                      return   AlertDialog(
                                        title: Text('Add Deposit'),
                                        content: Container(
                                          height: publicProvider.isWindows?size.height*.1:size.width*.1,
                                          width: publicProvider.isWindows?size.height*.3:size.width*.3,
                                          child:SingleChildScrollView(
                                            child: Column(
                                              children: [

                                                Container(
                                                  width: size.height*.4,
                                                  child: TextField(
                                                    controller: depositTextController,
                                                    decoration: textFieldFormDecoration(size).copyWith(
                                                      hintText: 'Depositor Amount',
                                                      hintStyle: TextStyle(
                                                        fontSize: publicProvider.isWindows
                                                            ? size.height * .02
                                                            : size.width * .02,
                                                      ),
                                                    ),
                                                  //  onChanged: _filterList,
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

                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              showLoaderDialog(context);

                                              firebaseProvider.getSingleUserData(firebaseProvider.depositRequestList[index].userId).then((value) async{
                                                String depositAmount = firebaseProvider.userDepositBalance;

                                                int updatableAmount = int.parse(depositAmount)+int.parse(depositTextController.text);

                                             await   _addDepositRequestBalance(firebaseProvider, updatableAmount, index);

                                              }).then((value) async{

                                              await  _transferedDepositRequestBalance(firebaseProvider,depositTextController.text,index).then((value) {
                                                  // _isLoading = false;

                                                  Navigator.pop(context);
                                                });
                                              Navigator.pop(context);

                                              });

                                            },
                                          ),
                                        ],
                                      );
                                    }) ;


                              }, child: Text('Approve',style: TextStyle(color: Colors.white),))
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

  Future<void> _addDepositRequestBalance(
      FirebaseProvider firebaseProvider,int updatebleAmount,int? index) async {

    Map<String, dynamic> map = {
      'depositBalance': '$updatebleAmount',
    };
    await firebaseProvider.addDepositRequestAmount(map,index!).then((value) {
      if (value) {
        showToast('Success');


      } else {

        showToast('Failed');
      }
    });

  }
  Future<void> _transferedDepositRequestBalance(
      FirebaseProvider firebaseProvider,var requesstAmount,int? index) async {

    Map<String, dynamic> map = {
      'amount': '$requesstAmount',
      'status': 'transferred',
    };
    await firebaseProvider.updateDepositStatus(map,index!).then((value) {
      if (value) {
        showToast('Success');


      } else {

        showToast('Failed');
      }
    });

  }



}
