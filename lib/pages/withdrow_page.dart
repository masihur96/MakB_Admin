import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class WithdrowPage extends StatefulWidget {
  @override
  _WithdrowPageState createState() => _WithdrowPageState();
}

class _WithdrowPageState extends State<WithdrowPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);
    return Container(
      width: publicProvider.pageWidth(size),

        child: Column(
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
            Container(
              width: publicProvider.isWindows
                  ? size.height * .5
                  : size.width * .5,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: TextField(

                  decoration: textFieldFormDecoration(size).copyWith(
                    hintText: 'Search By ID',
                    hintStyle: TextStyle(
                      fontSize: publicProvider.isWindows
                          ? size.height * .02
                          : size.width * .02,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID',
                  ),
                  Text(
                    'Name',
                  ),
                  Text(
                    'Phone',
                  ),
                  Text(
                    'Amount',
                  ),
                  Text(
                    'Request Date',
                  ),

                  Text(
                    'Status',
                  ),
                  Text(
                    'View',
                  ),

                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: firebaseProvider.withdrawRequestList.length,
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
                                firebaseProvider.withdrawRequestList[index].id,
                              ),
                              Text(
                                firebaseProvider.withdrawRequestList[index].name,
                              ),
                              Text(
                                firebaseProvider.withdrawRequestList[index].phone,
                              ),
                              Text(
                                firebaseProvider.withdrawRequestList[index].amount,
                              ),
                              Text(
                                firebaseProvider.withdrawRequestList[index].date,
                              ),
                              Text(firebaseProvider.withdrawRequestList[index].status,
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        publicProvider.subCategory =
                                        'Withdraw Details';
                                        publicProvider.category = '';
                                        setState(() {
                                          firebaseProvider.withdrawIndex = index;
                                        });
                                      });
                                      // Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductDetails()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.visibility,
                                              size: publicProvider.isWindows
                                                  ? size.height * .02
                                                  : size.width * .02,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'View Details',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),

                            ],
                          ),
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
