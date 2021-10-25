import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';

import 'package:provider/provider.dart';

class InsurancePage extends StatefulWidget {
  @override
  _InsurancePageState createState() => _InsurancePageState();
}

class _InsurancePageState extends State<InsurancePage> {
  bool _isLoading = false;

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
              child: Text('Insurance List ',
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontSize: publicProvider.isWindows
                        ? size.height * .05
                        : size.width * .05,
                  )),
            ),
            Container(
              width:
                  publicProvider.isWindows ? size.height * .5 : size.width * .5,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: TextField(
                  controller: searchTextController,
                  decoration: textFieldFormDecoration(size).copyWith(
                    hintText: 'Search Customer',
                    hintStyle: TextStyle(
                      fontSize: publicProvider.isWindows
                          ? size.height * .02
                          : size.width * .02,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ID',
                        style: TextStyle(
                          fontSize: publicProvider.isWindows
                              ? size.height * .02
                              : size.width * .02,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80.0),
                        child: Text(
                          'Photo',
                          style: TextStyle(
                            fontSize: publicProvider.isWindows
                                ? size.height * .02
                                : size.width * .02,
                          ),
                        ),
                      ),
                      Text(
                        'Name',
                        style: TextStyle(
                          fontSize: publicProvider.isWindows
                              ? size.height * .02
                              : size.width * .02,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Info',
                        style: TextStyle(
                          fontSize: publicProvider.isWindows
                              ? size.height * .02
                              : size.width * .02,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Text(
                        'Insurance Amount',
                        style: TextStyle(
                          fontSize: publicProvider.isWindows
                              ? size.height * .02
                              : size.width * .02,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Due Insurance',
                          style: TextStyle(
                            fontSize: publicProvider.isWindows
                                ? size.height * .02
                                : size.width * .02,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80.0),
                        child: Text(
                          'Action',
                          style: TextStyle(
                            fontSize: publicProvider.isWindows
                                ? size.height * .02
                                : size.width * .02,
                          ),
                        ),
                      ),
                      Text(
                        'View',
                        style: TextStyle(
                          fontSize: publicProvider.isWindows
                              ? size.height * .02
                              : size.width * .02,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                ),
              ],
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  firebaseProvider.userList[index].id,
                                  style: TextStyle(
                                    fontSize: publicProvider.isWindows
                                        ? size.height * .02
                                        : size.width * .02,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0, vertical: 5),
                                  child: Container(
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
                                ),
                                Text(
                                  firebaseProvider.userList[index].name,
                                  style: TextStyle(
                                    fontSize: publicProvider.isWindows
                                        ? size.height * .02
                                        : size.width * .02,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0),
                                  child: Center(
                                      child:
                                          Text(firebaseProvider.userList[index].address,)),
                                ),
                                Center(child: Text('${firebaseProvider.userList[index].insuranceBalance}')),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0),
                                  child: Center(child: Text('5000 tk')),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0),
                                  child: Center(child: Text('Manually')),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {

                                          firebaseProvider.insuranceID = index;
                                          publicProvider.subCategory =
                                              'InsuranceDetails';
                                          publicProvider.category = '';
                                        });
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
                                                  fontSize:
                                                      publicProvider.isWindows
                                                          ? size.height * .02
                                                          : size.width * .02,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                              ],
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
