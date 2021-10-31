import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class WithdrawDetails extends StatefulWidget {
  @override
  _WithdrawDetailsState createState() => _WithdrawDetailsState();
}

class _WithdrawDetailsState extends State<WithdrawDetails> {

  bool _isLoading = false;

  String statusValue='pending';
  List<String> status=['pending','transferred'];

  int counter=0;

  _customInit(FirebaseProvider firebaseProvider){
    setState(() {
      counter++;

     // firebaseProvider.getWithdrawHistory();

    });
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);

    // if(counter==0){
    //   _customInit(firebaseProvider);
    // }
    return Container(
      width: publicProvider.pageWidth(size),

        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),

                 child: Image.network(firebaseProvider.withdrawHistoryList[firebaseProvider.withdrawIndex].imageUrl,fit: BoxFit.fill,),

                  ),
                  SizedBox(width: 10,),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),

                      Text('Mak-B 2021'),
                      Text('ID:${firebaseProvider.withdrawHistoryList[firebaseProvider.withdrawIndex].id}'),
                      Text('Request Balance: ${firebaseProvider.withdrawHistoryList[firebaseProvider.withdrawIndex].amount}'),
                      Text('Request Date: ${firebaseProvider.withdrawHistoryList[firebaseProvider.withdrawIndex].date}'),
                      Text('Request Status: ${firebaseProvider.withdrawHistoryList[firebaseProvider.withdrawIndex].status}'),

                    ],)
                ],),
            ),
            Row(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Status: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 15)),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: statusValue,
                        elevation: 0,
                        dropdownColor: Colors.white,
                        style: TextStyle(color: Colors.black),
                        items: status.map((itemValue) {
                          return DropdownMenuItem<String>(
                            value: itemValue,
                            child: Text(itemValue),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            statusValue = newValue!;
                          });

                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      onPressed: () {

                        _submitData(firebaseProvider,firebaseProvider.withdrawIndex);

                        // showDialog(context: context, builder: (_){
                        //   return   AlertDialog(
                        //     title: Text('Update Warning'),
                        //     content: Container(
                        //
                        //       height: publicProvider.isWindows?size.height*.3:size.width*.3,
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: <Widget>[
                        //
                        //           Text('Are you Confirm to Update Status ?'),
                        //
                        //           SizedBox(height: 20,),
                        //           ElevatedButton(
                        //
                        //               style: ElevatedButton.styleFrom(
                        //
                        //                 primary: Colors.green,
                        //               ),
                        //               onPressed: (){
                        //
                        //                 _submitData(firebaseProvider);
                        //
                        //               }, child: Padding(
                        //             padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        //             child: Text('Update',
                        //               style: TextStyle(
                        //                   fontSize: 15,
                        //                   color: Colors.white,
                        //                   fontWeight: FontWeight.normal),
                        //             ),
                        //           ))
                        //
                        //         ],
                        //       ),
                        //     ),
                        //     actions: <Widget>[
                        //       TextButton(
                        //         child: Text('Cancel'),
                        //         onPressed: () {
                        //           Navigator.of(context).pop();
                        //         },
                        //       ),
                        //     ],
                        //   );
                        // }) ;

                      },
                      child: Text('Update Status',style: TextStyle(fontSize: 15,color: Colors.white),)),
                ),
              ],),

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
                  Expanded(child: Text('Date',textAlign: TextAlign.center,)),
                  Expanded(child: Text('Status',textAlign: TextAlign.center,)),
                  Expanded(child: Text('From',textAlign: TextAlign.center,)),
                  Expanded(child: Text('Withdraw Balance',textAlign: TextAlign.center,)),

                ],),
            ),

            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: firebaseProvider.withdrawHistoryList.length,
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
                                  '${firebaseProvider.withdrawHistoryList[index].date}',textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: publicProvider.isWindows
                                        ? size.height * .02
                                        : size.width * .02,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${firebaseProvider.withdrawHistoryList[index].status}',textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: publicProvider.isWindows
                                        ? size.height * .02
                                        : size.width * .02,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text('${firebaseProvider.withdrawHistoryList[index].amount}',textAlign: TextAlign.center,
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

  Future<void> _submitData(
      FirebaseProvider firebaseProvider,int? index) async {
    setState(() => _isLoading = true);
    Map<String, dynamic> map = {
      'status': statusValue,
    };
    await firebaseProvider.updateStatusData(map).then((value) {
      if (value) {
        print('Success');
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        print('Failed');
      }
    });

  }
}
