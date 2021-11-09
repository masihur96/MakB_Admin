import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:provider/provider.dart';

class AddBalance extends StatefulWidget {
  @override
  _AddBalanceState createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  TextEditingController _serviceCharge = TextEditingController(text: '');
  TextEditingController _videoRate = TextEditingController(text: '');
//  String error = 'Put a Strong Password';
  bool _isLoading=false;

  int counter=0;

  customInit(FirebaseProvider firebaseProvider){



    setState(() {
      counter++;
    });

    firebaseProvider.getRate().then((value) {
      if(firebaseProvider.rateDataList.isNotEmpty){
        setState(() {

          _serviceCharge = TextEditingController(text: firebaseProvider.rateDataList[0].serviceCharge);
          _videoRate = TextEditingController(text: firebaseProvider.rateDataList[0].videoRate);

        });
      }

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

      child: Center(
        child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(

              width: size.width * .35,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: <Widget>[
                  SizedBox(height: size.height * .04),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _serviceCharge,
                      decoration: InputDecoration(
                        labelText: 'Service Charge',
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(width: 1,color: Colors.green),
                        ),
                      ),
                      maxLines: 1,
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: TextFormField(
                  //     controller: _videoRate,
                  //     decoration: InputDecoration(
                  //       labelText: 'Video Rate',
                  //       border: new OutlineInputBorder(
                  //         borderRadius: new BorderRadius.circular(5.0),
                  //         borderSide: new BorderSide(width: 1),
                  //       ),
                  //     ),
                  //     maxLines: 1,
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  _isLoading
                      ? fadingCircle
                      : ElevatedButton(
                    onPressed: () {
                      _isLoading = true;
                      _submitData(firebaseProvider);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0.0),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * .03,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10,)
                ]),
              ),
            ),
          ],
        ),
      )
    );
  }

  Future<void> _submitData(
      FirebaseProvider firebaseProvider) async {
    DateTime date = DateTime.now();
    String dateData = '${date.month}-${date.day}-${date.year}';

    setState(() => _isLoading = true);
    Map<String, dynamic> map = {
      'serviceCharge': _serviceCharge.text,
      'videoRate': _videoRate.text,
      'date': dateData,
    };
    await firebaseProvider.addRateChart(map).then((value) {
      if (value) {
        print('Success');
 _emptyFildCreator();
        firebaseProvider.getRate().then((value) {
          customInit(firebaseProvider);
        });

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        print('Failed');
      }
    });
  }
  _emptyFildCreator() {
    _serviceCharge.clear();
    _videoRate.clear();

  }

}
