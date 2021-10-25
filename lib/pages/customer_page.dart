import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {

  var searchTextController = TextEditingController();
  int? level;


  int counter=0;

  customInit(FirebaseProvider firebaseProvider){
    setState(() {
      counter++;
    });
    //
    // level = firebaseProvider.userList.level;
    // print('level $level');



  }

  List deleteList =[];


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
              child: Text('Customer List ',
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: (){
                        showDialog(context: context, builder: (_){
                          return   AlertDialog(
                            title: Text('Alert'),
                            content: Container(
                              height: publicProvider.isWindows?size.height*.2:size.width*.2,
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.warning_amber_outlined,color: Colors.yellow,size: 40,),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    child: Text('Are you confirm to delete this customer ?',style: TextStyle(fontSize: 14,color: Colors.black),),
                                  ),
                                ],),

                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        }) ;
                      },
                      icon: Icon(
                    Icons.delete_outline,size: 20,
                    color: Colors.red,
                  )),
                  TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                    onPressed: (){

                  }, child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text('Clear All Selection ',
                        style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontSize: publicProvider.isWindows
                              ? size.height * .02
                              : size.width * .02,
                        )),
                  ),


                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0),
                    child: Text(
                      '#',
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'ID',textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'Photo', textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Name',textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Info',textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Refer',textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Level',textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Balance',textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .02
                            : size.width * .02,
                      ),
                    ),
                  ),
                  Text(
                    'Details',textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: publicProvider.isWindows
                          ? size.height * .02
                          : size.width * .02,
                    ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            InkWell(
                              onTap: (){
                                setState(() {

                                  if(deleteList.contains(index)){

                                    deleteList.remove(index);
                                  }else {
                                    deleteList.add(index);
                                  }


                                });
                              },
                                child: deleteList. contains(index)?Icon(Icons.check_box_outlined,size: 15,):Icon(Icons.check_box_outline_blank_outlined,size: 15,)),
                            Expanded(
                              child: Text(
                                firebaseProvider.userList[index].id,textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Container(
                                width: 30,
                                child:firebaseProvider.userList[index].imageUrl != null? Image.network(
                                  firebaseProvider.userList[index].imageUrl,height: publicProvider.isWindows
                                    ? size.height * .1
                                    : size.width * .1,
                                  width: publicProvider.isWindows
                                      ? size.height * .07
                                      : size.width * .07,

                                ):Container(),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                firebaseProvider.userList[index].name,textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(firebaseProvider.userList[index].address,textAlign: TextAlign.center,),
                                  firebaseProvider.userList[index].email !=''? Text(firebaseProvider.userList[index].email,textAlign: TextAlign.center,):Container(),
                                  Text(firebaseProvider.userList[index].phone,textAlign: TextAlign.center,),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TextButton(onPressed: (){
                                showDialog(context: context, builder: (_){
                                  return   AlertDialog(
                                    title: Text('Refer Details'),
                                    content: Container(
                                      height: publicProvider.isWindows?size.height*.6:size.width*.6,
                                      width: publicProvider.isWindows?size.height*.7:size.width*.7,
                                      child:SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [


                                                      Text( firebaseProvider.userList[index].name,style: TextStyle(fontSize: 20,color: Colors.black),),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                        child: Text( 'Refer Code: ${firebaseProvider.userList[index].referCode}',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                      ),

                                                      Text('Refer Date: ${firebaseProvider.userList[index].referDate}',style: TextStyle(fontSize: 14,color: Colors.black),),

                                                      Text('Refer Limit: ${firebaseProvider.userList[index].referLimit}',),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                        child: Text('Total Referee: ${firebaseProvider.userList[index].numberOfReferred}',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                      ),
                                                    ],),

                                                  Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),

                                                    child: Image.network(firebaseProvider.userList[index].imageUrl,fit: BoxFit.fill,),),

                                                ],),
                                            ),

                                                // Expanded(
                                                //   child: ListView.builder(
                                                //   shrinkWrap: true,
                                                //   padding: const EdgeInsets.all(8),
                                                //   itemCount: 1,
                                                //   itemBuilder: (BuildContext context, int index) {
                                                //     return Container();
                                                //   }
                                                //   ),
                                                // ),

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
                                    ],
                                  );
                                }) ;

                              }, child:  Text(firebaseProvider.userList[index].numberOfReferred,textAlign: TextAlign.center,style: TextStyle(color: Colors.green),)),
                            ),

                            Expanded(child: Text(firebaseProvider.userList[index].level,textAlign: TextAlign.center,)),

                            Expanded(child: Text(firebaseProvider.userList[index].mainBalance,textAlign: TextAlign.center,)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(context: context, builder: (_){
                                        return   AlertDialog(
                                          title: Text('Customer Details'),
                                          content: Container(
                                           height: publicProvider.isWindows?size.height*.6:size.width*.6,
                                           width: publicProvider.isWindows?size.height*.7:size.width*.7,
                                            child:SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [

                                                            Container(
                                                              height: 100,
                                                              width: 100,
                                                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),

                                                              child: Image.network(firebaseProvider.userList[index].imageUrl,fit: BoxFit.fill,),),
                                                            Text( firebaseProvider.userList[index].name,style: TextStyle(fontSize: 20,color: Colors.black),),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                              child: Text( firebaseProvider.userList[index].id,style: TextStyle(fontSize: 14,color: Colors.black),),
                                                            ),

                                                            Text(firebaseProvider.userList[index].nbp,style: TextStyle(fontSize: 14,color: Colors.black),),
                                                            firebaseProvider.userList[index].email != ''? Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                              child: Text(firebaseProvider.userList[index].email,style: TextStyle(fontSize: 14,color: Colors.black),),
                                                            ):Container(),
                                                            Text(firebaseProvider.userList[index].phone,),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                              child: Text('Start from: ${firebaseProvider.userList[index].lastInsurancePaymentDate}',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                              child: Text('Deposit Balance: ${firebaseProvider.userList[index].depositBalance}',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                              child: Text('Insurance Balance: ${firebaseProvider.userList[index].insuranceBalance}',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                              child: Text('Main Balance: ${firebaseProvider.userList[index].mainBalance}',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                            ),
                                                          ],),

                                                        Container(
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),

                                                            border: Border.all(width: 1,color: Colors.grey)
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Column(

                                                              children: [
                                                                Container(
                                                                  height: 100,
                                                                  width: 100,
                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),

                                                                  child: Image.asset( 'assets/images/splash_3.png',fit: BoxFit.fill,),),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                                                                  child: Text('Silver',style: TextStyle(fontSize: 14,color: Colors.black),),
                                                                ),

                                                              ],
                                                            ),
                                                          ),
                                                        ),


                                                      ],),
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                      ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              primary: Colors.green,
                                                       ),
                                                          onPressed: (){


                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                            child: Text('Insurance',style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.normal

                                                            ),),
                                                          )),
                                                      ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                          primary: Colors.green,
                                                          textStyle: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.normal)),
                                                          onPressed: (){}, child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                            child: Text('Deposit',style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.normal

                                                      ),),
                                                          )),
                                                      ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              primary: Colors.green,),
                                                          onPressed: (){

                                                            publicProvider.subCategory = 'Refer';
                                                            publicProvider.category = '';

                                                            Navigator.pop(context);


                                                          }, child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                            child: Text('Refer',style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.normal
                                                      ),),
                                                          )),
                                                    ],),
                                                  )

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
                                          ],
                                        );
                                      }) ;
                                    },
                                    child: Icon(
                                      Icons.visibility,
                                      size: publicProvider.isWindows
                                          ? size.height * .02
                                          : size.width * .02,
                                      color: Colors.green,
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
