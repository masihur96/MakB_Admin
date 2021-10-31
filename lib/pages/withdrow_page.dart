import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/data_model/dart/withdraw_request_model.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class WithdrowPage extends StatefulWidget {
  @override
  _WithdrowPageState createState() => _WithdrowPageState();
}

class _WithdrowPageState extends State<WithdrowPage> {
  var searchTextController = TextEditingController();

  int counter=0;

  List<WithdrawRequestModel> _subList = [];
  List<WithdrawRequestModel> _filteredList = [];

  customInit(FirebaseProvider firebaseProvider)async{
    setState(() {
      counter++;
    });

    await firebaseProvider.getWithdrawRequest().then((value) {
      setState(() {
        _subList = firebaseProvider.withdrawRequestList;
        _filteredList = _subList;
      });
    });

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
                      'Amount',textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Request Date',textAlign: TextAlign.center,
                    ),
                  ),

                  Expanded(
                    child: Text(
                      'Status',textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'View',textAlign: TextAlign.center,
                    ),
                  ),

                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: _filteredList.length,
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
                                child: Text(
                                  '${_filteredList[index].id}',textAlign: TextAlign.center,
                                ),
                              ),
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
                                  '${_filteredList[index].amount}',textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${_filteredList[index].date}',textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text('${_filteredList[index].status}',textAlign: TextAlign.center,
                                ),
                              ),

                              Expanded(
                                child: InkWell(
                                  onTap: () {

                                    firebaseProvider.getWithdrawHistory(index).then((value) {
                                      setState(() {
                                        publicProvider.subCategory =
                                        'Withdraw Details';
                                        publicProvider.category = '';
                                        setState(() {
                                          firebaseProvider.withdrawIndex = index;
                                        });
                                      });
                                    });
                                  },
                                  child: Icon(
                                    Icons.visibility,
                                    size: publicProvider.isWindows
                                        ? size.height * .02
                                        : size.width * .02,
                                    color: Colors.green,
                                  ),
                                ),
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
