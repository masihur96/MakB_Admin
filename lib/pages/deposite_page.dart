import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';


import 'package:provider/provider.dart';

class DepositePage extends StatefulWidget {

  @override
  _DepositePageState createState() => _DepositePageState();
}

class _DepositePageState extends State<DepositePage> {
  bool _isLoading=false;
  var searchTextController = TextEditingController();

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
              child: Text('Depositor List ',
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
                controller: searchTextController,
                decoration: textFieldFormDecoration(size).copyWith(
                  hintText: 'Search Depositor',
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
                  'Photo',

                ),
                Text(
                  'Name',

                ),
                Text(
                  'ID',
                ),
                Text(
                  'Info',
                ),
                Text(
                  'Deposit Amount',
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
                itemCount: firebaseProvider.userList.length,
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
                              Container(
                                  height: publicProvider.isWindows
                                      ? size.height * .1
                                      : size.width * .1,
                                  width: publicProvider.isWindows
                                      ? size.height * .1
                                      : size.width * .1,
                                  child: Image.asset(
                                    firebaseProvider.userList[index].imageUrl,
                                    fit: BoxFit.fill,
                                  )),
                              Text(
                                firebaseProvider.userList[index].name,
                              ),
                              Text(
                                firebaseProvider.userList[index].id,
                              ),
                              Text(firebaseProvider.userList[index].address,
                              ),
                              Text(firebaseProvider.userList[index].depositBalance,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        publicProvider.subCategory =
                                        'DepositDetails';
                                        publicProvider.category = '';
                                        setState(() {
                                          firebaseProvider.depositIndex = index;
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
