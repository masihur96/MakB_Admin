import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';
class RegularOrderPage extends StatefulWidget {
  @override
  _RegularOrderPageState createState() => _RegularOrderPageState();
}
class _RegularOrderPageState extends State<RegularOrderPage> {
  var searchTextController = TextEditingController();
  final _ktabs = <Tab>[
    const Tab(text: 'Product Order'),
    const Tab(
      text: 'Package Order',
    ),
  ];

  static const status = <String> [
    'Processing',
    'Collected',
  ];

  String statusValue = 'Collected';
  List<dynamic> selectOrder = [];


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);

    return Container(
        width: publicProvider.pageWidth(size),
        child: ListView(
          children: [

            Container(
              height: size.height * .913,
              child: DefaultTabController(
                length: _ktabs.length,
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(50),
                    child: AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.white54,
                      bottom: TabBar(
                          labelStyle: TextStyle(
                            fontSize: size.height * .03,
                          ),
                          tabs: _ktabs,
                          indicatorColor: Colors.black,
                          unselectedLabelColor: Colors.blueGrey,
                          labelColor: Colors.black),
                    ),
                  ),
                  body: TabBarView(children: [
                    _productOrder(publicProvider,size,firebaseProvider),
                    _packageOrder(publicProvider,size,firebaseProvider),
                  ]),
                ),
              ),
            ),
          ],),
    );
  }

  _productOrder(PublicProvider publicProvider,Size size,FirebaseProvider firebaseProvider){

    return ListView(
      children: [

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: publicProvider.isWindows?size.height*.2:size.width*.2,
            child:     TextField(
              controller: searchTextController,
              decoration: textFieldFormDecoration(size).copyWith(
                hintText: 'Search Package by Order ID',
                hintStyle: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),
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
                                child: Text('Are you confirm to delete this Order ?',style: TextStyle(fontSize: 14,color: Colors.black),),
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

                  setState(() {
                    selectOrder.clear();
                  });

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
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('#',textAlign: TextAlign.center, style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
              Expanded(child: Text('Customer Info',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
              Expanded(child: Text('Date',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
              Expanded(child: Text('Order Number',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
              Expanded(child: Text('Quantity',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
              Expanded(child: Text('Payment Status',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
              Expanded(child: Text('Amount',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
              Expanded(child: Text('Action',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),

            ],),
        ),

        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: firebaseProvider.productOrderList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    children: [
                      Divider(height: 1,color: Colors.grey,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          InkWell(
                              onTap: (){
                                setState(() {
                                  if(selectOrder.contains(index)){
                                    selectOrder.remove(index);
                                  }
                                  else {
                                    selectOrder.add(index);
                                  }
                                });
                              },
                              child: selectOrder.contains(index)? Icon(Icons.check_box_outlined):Icon(Icons.check_box_outline_blank)),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(firebaseProvider.productOrderList[index].name,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                  Text(firebaseProvider.productOrderList[index].phone,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                               ],
                              ),
                            ),
                          ),
                          Expanded(
                              child: Text(firebaseProvider.productOrderList[index].orderDate,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
                          Expanded(
                            child: Text(firebaseProvider.productOrderList[index].orderNumber,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.green ,),),
                          ),
                          Expanded(
                            child: Text(firebaseProvider.productOrderList[index].quantity,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.grey ,),),
                          ),
                          Expanded(
                            child: Text(firebaseProvider.productOrderList[index].state,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.grey ,),),
                          ),
                          Expanded(
                            child: Text(firebaseProvider.productOrderList[index].totalAmount,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.grey ,),),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: (){

                                    showDialog(context: context, builder: (_){
                                      return   StatefulBuilder(
                                        builder: (context,setState){
                                          return AlertDialog(

                                            content: Container(
                                              height: publicProvider.isWindows?size.height*.7:size.width*.7,
                                              width: publicProvider.isWindows?size.height*.8:size.width*.5,
                                              child: ListView(


                                                children: <Widget>[

                                                  Text('Payment Information',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.03:size.width*.03,),),

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('Order ID',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                          //   Text('Transaction Id',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                          Text('Payment Date',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                          Text('Area',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                          Text('Hub',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                          Text('Quantity',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                          Text('Amount Receive',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                          Text('Status',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),


                                                        ],),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(firebaseProvider.productOrderList[index].orderNumber,style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                          // Text(firebaseProvider.productOrderList[index].orderNumber,style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                          Text(firebaseProvider.productOrderList[index].orderDate,style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                          Text(firebaseProvider.productOrderList[index].Area,style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                          Text(firebaseProvider.productOrderList[index].hub,style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                          Text(firebaseProvider.productOrderList[index].quantity,style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                          Text(firebaseProvider.productOrderList[index].totalAmount,style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
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

                                                                updateStateValue(firebaseProvider,index,statusValue);


                                                              },
                                                            ),
                                                          ),


                                                        ],)



                                                    ],),

                                                  Center(child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text('Ordered Product',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.03:size.width*.03,),),
                                                  )),

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text('Photo',style: TextStyle(color: Colors.green,fontSize: publicProvider.isWindows?size.height*.025:size.width*.025,),),

                                                      Text('Product Info',style: TextStyle(color: Colors.green,fontSize: publicProvider.isWindows?size.height*.025:size.width*.025,),),
                                                      Text('Quantity',style: TextStyle(color: Colors.green,fontSize: publicProvider.isWindows?size.height*.025:size.width*.025,),),
                                                      Text('Size',style: TextStyle(color: Colors.green,fontSize: publicProvider.isWindows?size.height*.025:size.width*.025,),),
                                                      Text('Color',style: TextStyle(color: Colors.green,fontSize: publicProvider.isWindows?size.height*.025:size.width*.025,),),
                                                      Text('Total',style: TextStyle(color: Colors.green,fontSize: publicProvider.isWindows?size.height*.025:size.width*.025,),),
                                                    ],),


                                                  Expanded(
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        padding: const EdgeInsets.all(8),
                                                        itemCount: 10,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                child: Divider(height: 1,color: Colors.grey,),
                                                              ),
                                                              Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [

                                                                    Image.asset('assets/images/splash_3.png',height: 30,width: 25,),

                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [

                                                                        Text('MakB Product',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                                        Text('Product ID : FS-edfdi475',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),

                                                                      ],),
                                                                    Text('Quantity: 1 Pcs',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                                    Text('Size: 1 XL',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                                    Text('Color: Green',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                                    Text('Total: 50 Pcs',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                                  ]
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                    ),
                                                  ),
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

                                        },

                                      );
                                    }) ;
                                  },
                                  child: Icon(Icons.visibility,size: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.green ,),
                                ),

                                SizedBox(width: 15,),
                                InkWell(
                                    onTap: (){

                                      showDialog(context: context, builder: (_){
                                        return   AlertDialog(

                                          title: Text('Alert'),

                                          content: Container(
                                            height: size.height*.2,
                                            child: Column(
                                              children: [
                                                Icon(Icons.warning_amber_outlined,size: 50,color: Colors.red,),
                                                Text('Are You Sure To Delete This Order ??'),
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
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                firebaseProvider.deleteProductOrder(firebaseProvider, index);

                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      }) ;
                                    },

                                    child: Icon(Icons.cancel,color: Colors.red,size: publicProvider.isWindows?size.height*.03:size.width*.03,)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
          ),
        )

      ],
    );
  }


  Future<void> updateStateValue(
      FirebaseProvider firebaseProvider, int? index,String status) async {
    Map<String, dynamic> map = {
      'state': status,
    };
    await firebaseProvider.updateOrderStatus(map,index!).then((value) {
      if (value) {
        showToast('Success');

      } else {

        showToast('Failed');
      }
    });

  }

  _packageOrder(PublicProvider publicProvider,Size size,FirebaseProvider firebaseProvider){

    return ListView(
      children: [

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: publicProvider.isWindows?size.height*.2:size.width*.2,
            child:     TextField(
              controller: searchTextController,
              decoration: textFieldFormDecoration(size).copyWith(
                hintText: 'Search Package by Order ID ',
                hintStyle: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),
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
                                child: Text('Are you confirm to delete this Order ?',style: TextStyle(fontSize: 14,color: Colors.black),),
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

                  setState(() {
                    selectOrder.clear();
                  });

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
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('#',textAlign: TextAlign.center, style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
              Expanded(child: Text('Customer Info',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
              Expanded(child: Text('Date',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
              Expanded(child: Text('Package Name',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
              Expanded(child: Text('Price',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
              Expanded(child: Text('Discount',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
              Expanded(child: Text('Quantity',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
              Expanded(child: Text('Order Status',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
              Expanded(child: Text('Action',textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),

            ],),
        ),

        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: firebaseProvider.packageOrderList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    children: [
                      Divider(height: 1,color: Colors.grey,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          InkWell(
                              onTap: (){
                                setState(() {
                                  if(selectOrder.contains(index)){
                                    selectOrder.remove(index);
                                  }
                                  else {
                                    selectOrder.add(index);
                                  }
                                });
                              },
                              child: selectOrder.contains(index)? Icon(Icons.check_box_outlined):Icon(Icons.check_box_outline_blank)),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(firebaseProvider.packageOrderList[index].userName,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                  Text(firebaseProvider.packageOrderList[index].userAddress,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                  Text(firebaseProvider.packageOrderList[index].userPhone,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              child: Text(firebaseProvider.packageOrderList[index].date,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),)),
                          Expanded(
                            child: Text(firebaseProvider.packageOrderList[index].productName,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.green ,),),
                          ),
                          Expanded(
                            child: Text(firebaseProvider.packageOrderList[index].productPrice,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.grey ,),),
                          ),
                          Expanded(
                            child: Text(firebaseProvider.packageOrderList[index].discount,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.grey ,),),
                          ),
                          Expanded(
                            child: Text(firebaseProvider.packageOrderList[index].quantity,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.grey ,),),
                          ),

                          Expanded(
                            child: Text(firebaseProvider.packageOrderList[index].status,textAlign: TextAlign.center,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.grey ,),),
                          ),

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

                              //   updatePackageStateValue(firebaseProvider,index,statusValue);


                              },
                            ),
                          ),


                          // Expanded(
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       InkWell(
                          //         onTap: (){
                          //
                          //           showDialog(context: context, builder: (_){
                          //             return   AlertDialog(
                          //
                          //               content: Container(
                          //                 height: publicProvider.isWindows?size.height*.7:size.width*.7,
                          //                 width: publicProvider.isWindows?size.height*.8:size.width*.5,
                          //                 child: ListView(
                          //
                          //
                          //                   children: <Widget>[
                          //
                          //                     Text('Payment Information',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.03:size.width*.03,),),
                          //
                          //                     Row(
                          //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //                       children: [
                          //                         Column(
                          //                           crossAxisAlignment: CrossAxisAlignment.start,
                          //                           children: [
                          //                             Text('Customer Name',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                          //                             Text('Address',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                          //                             Text('Package Name',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                          //                             Text('Quantity',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                          //                             Text('Price',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                          //                             Text('Discount',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                          //                             Text('Date',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                          //                             Text('Status',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                          //
                          //                           ],),
                          //                         Column(
                          //                           crossAxisAlignment: CrossAxisAlignment.start,
                          //                           children: [
                          //                             Text(firebaseProvider.packageOrderList[index].userName,style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                          //                             Text(firebaseProvider.packageOrderList[index].userAddress,style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                          //                             Text(firebaseProvider.packageOrderList[index].productName,style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                          //                             Text(firebaseProvider.packageOrderList[index].quantity,style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                          //                             Text(firebaseProvider.packageOrderList[index].productPrice,style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                          //                             Text(firebaseProvider.packageOrderList[index].discount,style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                          //                             Text(firebaseProvider.packageOrderList[index].date,style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                          //                             DropdownButtonHideUnderline(
                          //                               child: DropdownButton<String>(
                          //                                 value: statusValue,
                          //                                 elevation: 0,
                          //                                 dropdownColor: Colors.white,
                          //                                 style: TextStyle(color: Colors.black),
                          //                                 items: status.map((itemValue) {
                          //                                   return DropdownMenuItem<String>(
                          //                                     value: itemValue,
                          //                                     child: Text(itemValue),
                          //                                   );
                          //                                 }).toList(),
                          //                                 onChanged: (newValue) {
                          //                                   setState(() {
                          //                                     statusValue = newValue!;
                          //                                   });
                          //
                          //                                   //   updateStateValue(firebaseProvider,index,statusValue);
                          //
                          //                                 },
                          //                               ),
                          //                             ),
                          //                           ],)
                          //                       ],),
                          //
                          //                   ],
                          //                 ),
                          //               ),
                          //               actions: <Widget>[
                          //                 TextButton(
                          //                   child: Text('Cancel'),
                          //                   onPressed: () {
                          //                     Navigator.of(context).pop();
                          //                   },
                          //                 ),
                          //               ],
                          //             );
                          //           }) ;
                          //         },
                          //         child: Icon(Icons.visibility,size: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.green ,),
                          //       ),
                          //
                          //       SizedBox(width: 15,),
                          //       InkWell(
                          //           onTap: (){
                          //
                          //             showDialog(context: context, builder: (_){
                          //               return   AlertDialog(
                          //
                          //                 title: Text('Alert'),
                          //
                          //                 content: Container(
                          //                   height: size.height*.2,
                          //                   child: Column(
                          //                     children: [
                          //                       Icon(Icons.warning_amber_outlined,size: 50,color: Colors.red,),
                          //                       Text('Are You Sure To Delete This Order ??'),
                          //                     ],
                          //                   ),
                          //                 ),
                          //                 actions: <Widget>[
                          //
                          //                   TextButton(
                          //                     child: Text('Cancel'),
                          //                     onPressed: () {
                          //                       Navigator.of(context).pop();
                          //                     },
                          //                   ),
                          //                   TextButton(
                          //                     child: Text('OK'),
                          //                     onPressed: () {
                          //                       Navigator.of(context).pop();
                          //                     },
                          //                   ),
                          //                 ],
                          //               );
                          //             }) ;
                          //           },
                          //
                          //           child: Icon(Icons.cancel,color: Colors.red,size: publicProvider.isWindows?size.height*.03:size.width*.03,)),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                );
              }
          ),
        )

      ],
    );
  }

  Future<void> updatePackageStateValue(
      FirebaseProvider firebaseProvider, int? index,String status) async {
    Map<String, dynamic> map = {
      'status': status,
    };
    await firebaseProvider.updatePackageOrderStatus(map,index!).then((value) {
      if (value) {
        showToast('Success');

      } else {

        showToast('Failed');
      }
    });

  }
}
