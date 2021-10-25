import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';
class RegularOrderPage extends StatefulWidget {
  @override
  _RegularOrderPageState createState() => _RegularOrderPageState();
}
class _RegularOrderPageState extends State<RegularOrderPage> {
  var searchTextController = TextEditingController();

  String categoryValue = 'T-Shirt';
  String subCategoryValue = 'Baby';
  var category = [
    'T-Shirt',
    'Shirt',
    'Coat',
    'Jersey',
    'Trouser',
  ];
  var subCategory = [
    'Baby',
    'Men',
    'Women',
    'Children',
    'Girls',
    'Boys',
  ];

  List<dynamic> selectOrder = [];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    return Container(
        width: publicProvider.pageWidth(size),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Container(
                  width: publicProvider.isWindows?size.height*.2:size.width*.2,
                  child:     Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: TextField(
                      controller: searchTextController,
                      decoration: textFieldFormDecoration(size).copyWith(
                        hintText: 'Search Product',
                        hintStyle: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),
                      ),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Category: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,)),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        dropdownColor: Colors.white,
                        value: categoryValue,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: category.map((String items) {
                          return DropdownMenuItem(
                              value: items, child: Text(items,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            categoryValue = newValue.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Subcategory: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,)),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        dropdownColor: Colors.white,
                        value: subCategoryValue,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: subCategory.map((String items) {
                          return DropdownMenuItem(

                              value: items, child: Text(items,style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            subCategoryValue = newValue.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),

              ],),
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text('#',style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),

                        Text('Customer Info',style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),

                        Text('Date',style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),

                        Text('Address',style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),

                        Text('Order Status',style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text('Payment Status',style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                        ),  Text('Action',style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),

                      ],),
                  ),
                ),

              ],
            ),

            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: 10,
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

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Rafiul Islam',style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: Text('014758693214',style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                  ),
                                  Text('rofiqul@gmail.com',style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                ],
                              ),
                              Text('Sep 30,2021\n(19:18)',style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                              Text('Barguna Bangladesh',style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                                    child: Text('New',style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.white ,),),
                                  )),
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                                    child: Text('Unpaid',style: TextStyle(fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.black ,),),
                                  )),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,

                                children: [

                                  InkWell(
                                    onTap: (){

                                      showDialog(context: context, builder: (_){
                                        return   AlertDialog(

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
                                                      Text('Payment ID',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                      Text('Transaction Id',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                      Text('Payment Date',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                      Text('Payment Gateway',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                      Text('Amount Receive',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                      Text('Status',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                      Text('Ordered Product',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),


                                                    ],),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                      Text(': FS-edfdi475',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                      Text(': FS-edfdi475',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                      Text(': ilmno85475213kjhy',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                      Text(': 11-10-2021 11:30',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                      Text(': SSL-COMARZ',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                      Text(': BDT0',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                                      Text(': Unpaid',style: TextStyle(color: Colors.black,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),


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
                                      }) ;
                                          },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(Radius.circular(5))),

                                        child: Row(children: [
                                          Icon(Icons.visibility,size: publicProvider.isWindows?size.height*.02:size.width*.02,color:Colors.white ,),
                                          Text('View Details',style: TextStyle(color: Colors.white,fontSize: publicProvider.isWindows?size.height*.02:size.width*.02,),),
                                        ],),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.send,color: Colors.green,size: publicProvider.isWindows?size.height*.03:size.width*.03,),
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

                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
              ),
            )




          ],),
    );
  }
}
