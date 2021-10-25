import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class InsuranceDetails extends StatefulWidget {
  @override
  _InsuranceDetailsState createState() => _InsuranceDetailsState();
}

class _InsuranceDetailsState extends State<InsuranceDetails> {
  var oTPTextController = TextEditingController();
  var addAmountTextController = TextEditingController();

  String otpCode='123456';
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

                    child: Image.network(firebaseProvider.userList[firebaseProvider.insuranceID].imageUrl,fit: BoxFit.fill,),),
                  SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),
                      Text(firebaseProvider.userList[firebaseProvider.insuranceID].name,style: TextStyle(fontSize: 20,color: Colors.black),),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Text(firebaseProvider.userList[firebaseProvider.insuranceID].address,style: TextStyle(fontSize: 14,color: Colors.black),),
                      ),
                      Text(firebaseProvider.userList[firebaseProvider.insuranceID].phone),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Text('Start from: ${firebaseProvider.userList[firebaseProvider.insuranceID].insuranceEndingDate}',style: TextStyle(fontSize: 14,color: Colors.black),),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Text('Ending Date: ${firebaseProvider.userList[firebaseProvider.insuranceID].insuranceEndingDate}',style: TextStyle(fontSize: 14,color: Colors.black),),
                      ),
                      Text('Last Insurance Payment Date: ${firebaseProvider.userList[firebaseProvider.insuranceID].lastInsurancePaymentDate}',style: TextStyle(fontSize: 14,color: Colors.black),),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Text('Due Balance: 5000 tk',style: TextStyle(fontSize: 14,color: Colors.black),),
                      ),
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
                    onPressed: () {

                      showDialog(context: context, builder: (_){
                        return   AlertDialog(
                          title: Text('OTP'),
                          content: Container(

                            height: publicProvider.isWindows?size.height*.25:size.width*.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                                  child: TextField(
                                    controller: addAmountTextController,
                                    decoration: textFieldFormDecoration(size).copyWith(
                                      labelText: 'OTP',
                                      hintText: 'Customer OTP ',
                                      hintStyle: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: otpCode=='123456',
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                                    child: TextField(
                                      controller: addAmountTextController,
                                      decoration: textFieldFormDecoration(size).copyWith(
                                        labelText: 'Add Balance',
                                        hintText: 'Add Amount',
                                        hintStyle: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20,),

                                ElevatedButton(

                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                        textStyle: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal)),
                                    onPressed: (){}, child: Text('Add',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),))

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
                            title: Text('OTP'),
                            content: Container(

                              height: publicProvider.isWindows?size.height*.25:size.width*.25,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                                    child: TextField(
                                      controller: oTPTextController,
                                      decoration: textFieldFormDecoration(size).copyWith(
                                        labelText: 'OTP',
                                        hintText: 'Customer OTP ',
                                        hintStyle: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),

                                  Visibility(
                                    visible: otpCode=='123456',
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                                      child: TextField(
                                        controller: addAmountTextController,
                                        decoration: textFieldFormDecoration(size).copyWith(
                                          labelText: 'Update Amount',
                                          hintText: 'Update Amount',
                                          hintStyle: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 20,),

                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                          textStyle: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal)),
                                      onPressed: (){}, child: Text('Update',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),))

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
                  child: Text('Insurance History',style: TextStyle(fontSize: 20),),
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
                  Text('Insurance Balance',style: TextStyle(fontSize: 14),),

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
                                'Due',
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
                              Center(child: Text('3,000 tk',
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
}
