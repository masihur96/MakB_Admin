import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/data_model/dart/customer_data_model.dart';
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

  List<UserModel> _subList = [];
  List<UserModel> _filteredList = [];

  int counter=0;
  customInit(FirebaseProvider firebaseProvider)async{
    setState(() {
      counter++;
    });

    await firebaseProvider.getUser().then((value) {
      setState(() {
        _subList = firebaseProvider.userList;
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
              child: Text('Depositor List ',
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  'Photo',textAlign: TextAlign.center,

                ),
                Expanded(
                  child: Text(
                    'Name',textAlign: TextAlign.center,

                  ),
                ),
                Expanded(
                  child: Text(
                    'Customer ID',textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Info',textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Deposit Amount',textAlign: TextAlign.center,
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
                              Container(
                                  height: publicProvider.isWindows
                                      ? size.height * .1
                                      : size.width * .1,
                                  width: publicProvider.isWindows
                                      ? size.height * .05
                                      : size.width * .05,
                                  child: Image.network(
                                    _filteredList[index].imageUrl!,
                                    fit: BoxFit.fill,
                                  )),
                              Expanded(
                                child: Text(
                                  '${_filteredList[index].name}',textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${_filteredList[index].id}',textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text('${_filteredList[index].address}',textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text('${_filteredList[index].depositBalance}',textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Column(
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
                                      },
                                      child: Icon(
                                        Icons.visibility,
                                        size: publicProvider.isWindows
                                            ? size.height * .02
                                            : size.width * .02,
                                        color: Colors.green,
                                      ),
                                    ),

                                  ],
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
