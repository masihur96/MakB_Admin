import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/data_model/dart/customer_data_model.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:provider/provider.dart';

class DashBoardPage extends StatefulWidget {

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {


  bool _isLoading=true;
  bool showAvg = false;
  //Barchart
  final Color barBackgroundColor =  Colors.yellow;
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;
  bool isPlaying = false;


  int counter=0;


  List<UserModel> _totalUserList = [];
  List<UserModel> _todayUserList = [];
  Future <void>_customInt (FirebaseProvider firebaseProvider) async{
    setState(() {
      counter++;
    });



    DateTime date = DateTime.now();
    String dateData = '${date.day}-${date.month}-${date.year}';

    print(' Date From Device Instance: $dateData');


    setState(() {
      _totalUserList = firebaseProvider.userList;
      for (int i = 0; i < _totalUserList.length; i++) {
        //
        // print(' Date From ssss Instance: ${_totalUserList.length}');
        // print('_totalUserList[i].timeStamp');

        DateTime dateFromList = DateTime.fromMillisecondsSinceEpoch(int.parse('${_totalUserList[i].timeStamp}'));

        String dateFromDatabase = '${dateFromList.day}-${dateFromList.month}-${dateFromList.year}';
        print('Date Database: $dateFromDatabase');
        print(' Date From Device: $dateData');
        if (dateFromDatabase == dateData) {
          _todayUserList.add(_totalUserList[i]);
        }
      }
      print('Today List: ${_todayUserList.length}');
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);

      if(counter ==0){
        _customInt(firebaseProvider);
      }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Container(
          width: publicProvider.pageWidth(size),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: GridView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: publicProvider.isWindows ?4:1,
                    childAspectRatio: 3.5/2
                  ),
                  children: [
                    _gridViewTile(size,'Product',Color(0xff9D7CFD),
                        'Total Product','Soled ','${firebaseProvider.productList.length}','${firebaseProvider.productOrderList.length}'),

                    _gridViewTile(size,'Package',Color(0xff00B5C9),
                        'Total Package','Soled Package', '${firebaseProvider.packageList.length}','${firebaseProvider.soldPackageList.length}'),

                    _gridViewTile(size,'Order',Color(0xffFF8C00),
                        'Product Order','Package Order','${firebaseProvider.productOrderList.length}','${firebaseProvider.packageOrderList.length}'),
                    _gridViewTile(size,'Customer',Color(0xffFF8C00),
                        'Total Customer','New Customer','${firebaseProvider.userList.length}','${_todayUserList.length}'),
                    _gridViewTile(size,'Insurance',Color(0xffFF8C00),
                        'Pending','Transferred','${firebaseProvider.insuranceRequestList.length}','${firebaseProvider.insuranceTransferredRequestList.length}'),
                    _gridViewTile(size,'Deposit',Color(0xff00A958),
                        'Request ','Total','${firebaseProvider.depositRequestList.length}','${firebaseProvider.userList.length}'),
                    _gridViewTile(size,'Advertisement',Color(0xff00C4FE),
                        'Total Video','Rate','${firebaseProvider.advertisementList.length}','5'),
                  ],
                ),
              ),

              SizedBox(height: 300,),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: publicProvider.isWindows? Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Card(
              //           elevation: 5,
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Container(
              //                 width: publicProvider.isWindows? size.height*.5:size.width*.4,
              //                 color: Colors.green,
              //                 child: Stack(
              //                   children: <Widget>[
              //                     AspectRatio(
              //                       aspectRatio: 1.3,
              //                       child: Container(
              //
              //
              //                         child: LineChart(
              //                           showAvg ? avgData() : mainData(),
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               Padding(
              //                 padding: const EdgeInsets.all(5.0),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Text('Daily Sales',style: TextStyle(fontSize: 20),),
              //                     Text('10 Sales in Today',style: TextStyle(fontSize: 15),),
              //                     Divider(
              //                       height: 1,
              //                       color: Colors.grey,
              //                     ),
              //                     Row(children: [
              //
              //                       Icon(Icons.update_outlined,size: 15,),
              //                       Text('Updated 23521 Millisecond ago',style: TextStyle(fontSize: 10),),
              //                     ],)
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Card(
              //           elevation: 5,
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Container(
              //                 width: publicProvider.isWindows? size.height*.5:size.width*.4,
              //
              //                 child: Stack(
              //                   children: <Widget>[
              //                     AspectRatio(
              //                       aspectRatio: 1.3,
              //                       child: Container(
              //                         color: Colors.amber.shade400,
              //                         child: BarChart(
              //                            mainBarData(),
              //                             swapAnimationDuration: Duration(milliseconds: 50), // Optional
              //                         swapAnimationCurve: Curves.linear, // Optional
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //
              //               Padding(
              //                 padding: const EdgeInsets.all(5.0),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //
              //                     Text('Product By Date',style: TextStyle(fontSize: 20),),
              //                     Text('Last Campaign Performance',style: TextStyle(fontSize: 15),),
              //                     Divider(
              //                       height: 1,
              //                       color: Colors.grey,
              //                     ),
              //                     Row(children: [
              //
              //                       Icon(Icons.update_outlined,size: 15,),
              //                       Text('Updated 23521 Millisecond ago',style: TextStyle(fontSize: 10),),
              //                     ],)
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Card(
              //           elevation: 8,
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Container(
              //                 width: publicProvider.isWindows? size.height*.5:size.width*.4,
              //                 child: Stack(
              //                   children: <Widget>[
              //                     AspectRatio(
              //                       aspectRatio: 1.3,
              //                       child: Container(
              //
              //                         color: Colors.green.shade300,
              //                         child: LineChart(
              //                           showAvg ? avgData() : mainData(),
              //                         ),
              //                       ),
              //                     ),
              //                     // SizedBox(
              //                     //   width: size.width*.02,
              //                     //   height: size.width*.02,
              //                     //   child: TextButton(
              //                     //     onPressed: () {
              //                     //       setState(() {
              //                     //         showAvg = !showAvg;
              //                     //       });
              //                     //     },
              //                     //     child: Text(
              //                     //       'avg',
              //                     //       style: TextStyle(
              //                     //           fontSize: 12, color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
              //                     //     ),
              //                     //   ),
              //                     // ),
              //                   ],
              //                 ),
              //               ),
              //
              //               Padding(
              //                 padding: const EdgeInsets.all(5.0),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //
              //                     Text('Daily Orders',style: TextStyle(fontSize: 20),),
              //                     Text('Last Campaigns Performance',style: TextStyle(fontSize: 15),),
              //                     Divider(
              //                       height: 1,
              //                       color: Colors.grey,
              //                     ),
              //                     Row(children: [
              //
              //                       Icon(Icons.update_outlined,size: 15,),
              //                       Text('Updated 23521 Millisecond ago',style: TextStyle(fontSize: 10),),
              //                     ],)
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ):Column(
              //
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Card(
              //           elevation: 5,
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Container(
              //                 width: publicProvider.isWindows? size.height*.4:size.width*.4,
              //                 color: Colors.green,
              //                 child: Stack(
              //                   children: <Widget>[
              //                     AspectRatio(
              //                       aspectRatio: 1.3,
              //                       child: Container(
              //
              //
              //                         child: LineChart(
              //                           showAvg ? avgData() : mainData(),
              //                         ),
              //                       ),
              //                     ),
              //                     // SizedBox(
              //                     //   width: size.width*.02,
              //                     //   height: size.width*.02,
              //                     //   child: TextButton(
              //                     //     onPressed: () {
              //                     //       setState(() {
              //                     //         showAvg = !showAvg;
              //                     //       });
              //                     //     },
              //                     //     child: Text(
              //                     //       'avg',
              //                     //       style: TextStyle(
              //                     //           fontSize: 12, color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
              //                     //     ),
              //                     //   ),
              //                     // ),
              //                   ],
              //                 ),
              //               ),
              //               Padding(
              //                 padding: const EdgeInsets.all(5.0),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //
              //                     Text('Daily Sales',style: TextStyle(fontSize: 20),),
              //                     Text('10 Sales in Today',style: TextStyle(fontSize: 15),),
              //                     Divider(
              //                       height: 1,
              //                       color: Colors.grey,
              //                     ),
              //                     Row(children: [
              //
              //                       Icon(Icons.update_outlined,size: 15,),
              //                       Text('Updated 23521 Millisecond ago',style: TextStyle(fontSize: 10),),
              //                     ],)
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Card(
              //           elevation: 5,
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Container(
              //                 width: 350,
              //
              //                 child: Stack(
              //                   children: <Widget>[
              //                     AspectRatio(
              //                       aspectRatio: 1.3,
              //                       child: Container(
              //                         color: Colors.amber.shade400,
              //
              //
              //                         child: BarChart(
              //                           mainBarData(),
              //                           swapAnimationDuration: Duration(milliseconds: 50), // Optional
              //                           swapAnimationCurve: Curves.linear, // Optional
              //                         ),
              //                       ),
              //                     ),
              //                     // SizedBox(
              //                     //   width: size.width*.02,
              //                     //   height: size.width*.02,
              //                     //   child: TextButton(
              //                     //     onPressed: () {
              //                     //       setState(() {
              //                     //         showAvg = !showAvg;
              //                     //       });
              //                     //     },
              //                     //     child: Text(
              //                     //       'avg',
              //                     //       style: TextStyle(
              //                     //           fontSize: 12, color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
              //                     //     ),
              //                     //   ),
              //                     // ),
              //                   ],
              //                 ),
              //               ),
              //
              //               Padding(
              //                 padding: const EdgeInsets.all(5.0),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //
              //                     Text('Product By Date',style: TextStyle(fontSize: 20),),
              //                     Text('Last Campaign Performance',style: TextStyle(fontSize: 15),),
              //                     Divider(
              //                       height: 1,
              //                       color: Colors.grey,
              //                     ),
              //                     Row(children: [
              //
              //                       Icon(Icons.update_outlined,size: 15,),
              //                       Text('Updated 23521 Millisecond ago',style: TextStyle(fontSize: 10),),
              //                     ],)
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Card(
              //           elevation: 8,
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Container(
              //                 width: 350,
              //                 child: Stack(
              //                   children: <Widget>[
              //                     AspectRatio(
              //                       aspectRatio: 1.3,
              //                       child: Container(
              //
              //                         color: Colors.green.shade300,
              //                         child: LineChart(
              //                           showAvg ? avgData() : mainData(),
              //                         ),
              //                       ),
              //                     ),
              //                     // SizedBox(
              //                     //   width: size.width*.02,
              //                     //   height: size.width*.02,
              //                     //   child: TextButton(
              //                     //     onPressed: () {
              //                     //       setState(() {
              //                     //         showAvg = !showAvg;
              //                     //       });
              //                     //     },
              //                     //     child: Text(
              //                     //       'avg',
              //                     //       style: TextStyle(
              //                     //           fontSize: 12, color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
              //                     //     ),
              //                     //   ),
              //                     // ),
              //                   ],
              //                 ),
              //               ),
              //
              //               Padding(
              //                 padding: const EdgeInsets.all(5.0),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //
              //                     Text('Daily Orders',style: TextStyle(fontSize: 20),),
              //                     Text('Last Campaigns Performance',style: TextStyle(fontSize: 15),),
              //                     Divider(
              //                       height: 1,
              //                       color: Colors.grey,
              //                     ),
              //                     Row(children: [
              //
              //                       Icon(Icons.update_outlined,size: 15,),
              //                       Text('Updated 23521 Millisecond ago',style: TextStyle(fontSize: 10),),
              //                     ],)
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _gridViewTile(Size size,String title, Color bgColor,
      String heading1, String heading2, String h1Data, String h2Data){
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    return Stack(
      children: [
        Container(
          width: 300,
          height: 250,
          margin: EdgeInsets.only(top: size.height*.05,left: size.height*.02,right: size.height*.02),
          padding: EdgeInsets.symmetric(horizontal: size.height*.02,vertical: size.height*.02),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5)
            ]
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(heading1,style: TextStyle(color: Colors.grey,
                    fontSize: size.height*.016,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'OpenSans'),),
                Text(h1Data,style: TextStyle(color: Colors.grey[900],
                    fontSize: size.height*.022,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'OpenSans')),
                SizedBox(height: size.height*.02),

                Text(heading2,style: TextStyle(color: Colors.grey,
                    fontSize: size.height*.016,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'OpenSans'),),
                Text(h2Data,style: TextStyle(color: Colors.grey[900],
                    fontSize: size.height*.022,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'OpenSans')),

                Divider(height: 3,thickness: 0.2,color: Colors.grey),

                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(

                      onPressed: (){
                        if (title == 'Product') {
                          publicProvider.subCategory = 'All Product';
                          publicProvider.category = '';
                        } else if (title == 'Package') {
                          publicProvider.subCategory = 'All Package';
                          publicProvider.category = '';
                        } else if (title == 'Order') {
                          publicProvider.subCategory = 'Regular Orders';
                          publicProvider.category = '';
                        } else if (title == 'Customer') {
                          publicProvider.subCategory = 'Customer';
                          publicProvider.category = '';
                        } else if (title == 'Insurance') {
                          publicProvider.subCategory = 'Insurance';
                          publicProvider.category = '';
                        } else if (title == 'Deposit') {
                          publicProvider.subCategory = 'Deposit';
                          publicProvider.category = '';
                        } else if (title == 'Advertisement') {
                          publicProvider.subCategory = 'Advertisement';
                          publicProvider.category = '';
                        }
                      },

                      child: Text('View All',
                          style: TextStyle(
                              fontSize: size.height*.016,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'OpenSans'))
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: size.height*.04,
          top: size.height*.02,
          child: Container(
            height: size.height*.1,
            width: size.height*.1,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade500,
                    blurRadius: 10,
                  )
                ]
            ),
            child: Text(title,
                textAlign: TextAlign.center,
                style:TextStyle(color: Colors.white,fontSize: size.height*.02,fontFamily: 'OpenSans') ),
          ),
        )
      ],
    );
  }

  LineChartData mainData() {
    Size size = MediaQuery.of(context).size;
    return LineChartData(

      lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(tooltipBgColor: Colors.white,
              tooltipRoundedRadius:  8,
              getTooltipItems: defaultLineTooltipItem
          )
      ),

      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color:  Colors.grey,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color:  Colors.grey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),

        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) =>
              TextStyle(
                  fontFamily: 'taviraj',
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontStyle: FontStyle.normal,
                  fontSize: 9),

          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '4';
              case 1:
                return '2';
              case 2:
                return '30';
              case 3:
                return '29';
              case 4:
                return '27';
              case 5:
                return '26';
              case 6:
                return '23';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) =>
              TextStyle(
                  fontFamily: 'taviraj',

                  color: Colors.white,
                  fontStyle: FontStyle.normal,
                  fontSize: 9),

          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 1:
                return '500';
              case 2:
                return '1000';
            }
            return '';
          },
          margin: 8,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color:  Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: false,
          colors: [Colors.white,Colors.white],
          barWidth: 2,
          isStrokeCapRound: false,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: [Colors.green,Colors.white].map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),

      ],




    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: true),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (context, value) =>
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return 'Jan';
              case 1:
                return 'Feb';
              case 2:
                return 'Mar';
              case 3:
                return 'Apr';
              case 4:
                return 'May';
              case 5:
                return 'Jun';
              case 6:
                return 'Jul';
              case 7:
                return 'Aug';
              case 8:
                return 'Sep';
              case 9:
                return 'Oct';
              case 10:
                return 'Nov';
              case 11:
                return 'Dec';

            }
            return '';
          },
          margin: 8,
          interval: 1,
        ),
        leftTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      ),
      borderData:
      FlBorderData(show: false, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          colors: [
            ColorTween(begin: [Colors.black,Colors.black][0], end: [Colors.black,Colors.black][1]).lerp(0.2)!,
            ColorTween(begin: [Colors.black,Colors.black][0], end: [Colors.black,Colors.black][1]).lerp(0.2)!,
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: [Colors.black,Colors.black][0], end: [Colors.black,Colors.black][1])
                .lerp(0.2)!
                .withOpacity(0.1),
            ColorTween(begin: [Colors.black,Colors.black][0], end: [Colors.black,Colors.black][1])
                .lerp(0.2)!
                .withOpacity(0.1),
          ]),
        ),
      ],
    );
  }
  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
             tooltipBgColor: Colors.white,

            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = '31 May';
                  break;
                case 1:
                  weekDay = '1Jun';
                  break;
                case 2:
                  weekDay = '5 June';
                  break;
                case 3:
                  weekDay = '6 June';
                  break;
                case 4:
                  weekDay = '7 June';
                  break;
                case 5:
                  weekDay = '8 June';
                  break;
                case 6:
                  weekDay = '9 June';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay,
                TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),

              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) =>
          const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 9),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return '1 June';
              case 1:
                return '5 June';
              case 2:
                return '6 June';
              case 3:
                return '7 June';
              case 4:
                return '8 June';
              case 5:
                return '9 June';
              case 6:
                return '4 June';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }
  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, 5, isTouched: i == touchedIndex);
      case 1:
        return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
      case 2:
        return makeGroupData(2, 5, isTouched: i == touchedIndex);
      case 3:
        return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
      case 4:
        return makeGroupData(4, 9, isTouched: i == touchedIndex);
      case 5:
        return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
      case 6:
        return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
      default:
        return throw Error();
    }
  });

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = Colors.white,
        double width = 10,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow, width: 1)
              : BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: false,
            y: 20,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}

