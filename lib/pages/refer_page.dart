import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';


import 'package:provider/provider.dart';

class ReferPage extends StatefulWidget {

  @override
  _ReferPageState createState() => _ReferPageState();
}

class _ReferPageState extends State<ReferPage> {
  bool _isLoading=false;



  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    return Container(
      width: publicProvider.pageWidth(size),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),

                      child: Image.asset( 'assets/images/splash_3.png',fit: BoxFit.fill,),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mak-B 2021',style: TextStyle(fontSize: 20,color: Colors.black),),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text('Refer ID:#FG4215',style: TextStyle(fontSize: 14,color: Colors.black),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text('Start Date: 11-10-2021',style: TextStyle(fontSize: 14,color: Colors.black),),
                          ),
                          Text('Ending Date: 11-10-2022',style: TextStyle(fontSize: 14,color: Colors.black),),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text('Refer Income: 500',style: TextStyle(fontSize: 14,color: Colors.black),),
                          ),
                          Text('Refer People: 10'),


                        ],
                      ),
                    ),



                  ],),



                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),

                      border: Border.all(width: 1,color: Colors.grey)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text('Refer History',style: TextStyle(fontSize: 24,color: Colors.black),),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Photo ',style: TextStyle(fontSize: 14,color: Colors.black),),
              Text('Name ',style: TextStyle(fontSize: 14,color: Colors.black),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Customer ID',style: TextStyle(fontSize: 14,color: Colors.black),),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0),
                    child: Text('User Refer ID',style: TextStyle(fontSize: 14,color: Colors.black),),
                  ),
                  Text('Generate Date',style: TextStyle(fontSize: 14,color: Colors.black),),
                ],
              ),




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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [

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
                                      'assets/images/splash_3.png',
                                      fit: BoxFit.fill,
                                    )),
                              ),
                              Text(
                                'Mak-B 2021',
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),
                              ),


                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'User Refer Code',
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .02
                                      : size.width * .02,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                child: Center(
                                    child:
                                    Text('Customer ID')),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                child: Center(child: Text('Generate Date')),
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
      ),
      );

  }


}
