import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:provider/provider.dart';

class ContactInfo extends StatefulWidget {
  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  TextEditingController _email = TextEditingController(text: '');
  TextEditingController _phone = TextEditingController(text: '');
  TextEditingController _address= TextEditingController(text: '');
  TextEditingController _fbLink = TextEditingController(text: '');
  TextEditingController _youtubeLink = TextEditingController(text: '');
  TextEditingController _twitterLink = TextEditingController(text: '');
  TextEditingController _instragramLink = TextEditingController(text: '');
  TextEditingController _linkedInLink = TextEditingController(text: '');


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
          _email = TextEditingController(text: firebaseProvider.infoList[0].email);
          _phone = TextEditingController(text: firebaseProvider.infoList[0].phone);
          _address = TextEditingController(text: firebaseProvider.infoList[0].address);
          _fbLink = TextEditingController(text: firebaseProvider.infoList[0].fbLink);
          _youtubeLink = TextEditingController(text: firebaseProvider.infoList[0].youtubeLink);
          _twitterLink = TextEditingController(text: firebaseProvider.infoList[0].twitterLink);
          _instragramLink = TextEditingController(text: firebaseProvider.infoList[0].instagram);
          _linkedInLink = TextEditingController(text: firebaseProvider.infoList[0].linkedIn);


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
          child: ListView(
            children: [
              Column(
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
                            controller: _email,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(width: 1,color: Colors.green),
                              ),
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _phone,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(width: 1,color: Colors.green),
                              ),
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _address,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(width: 1,color: Colors.green),
                              ),
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _fbLink,
                            decoration: InputDecoration(
                              labelText: 'FB Link',
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(width: 1,color: Colors.green),
                              ),
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _youtubeLink,
                            decoration: InputDecoration(
                              labelText: 'Youtube Link',
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(width: 1,color: Colors.green),
                              ),
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _twitterLink,
                            decoration: InputDecoration(
                              labelText: 'Twitter Link',
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(width: 1,color: Colors.green),
                              ),
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _instragramLink,
                            decoration: InputDecoration(
                              labelText: 'Instagram link',
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(width: 1,color: Colors.green),
                              ),
                            ),
                            maxLines: 1,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _linkedInLink,
                            decoration: InputDecoration(
                              labelText: 'LinkedIn Link',
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(width: 1,color: Colors.green),
                              ),
                            ),
                            maxLines: 1,
                          ),
                        ),


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
      'email': _email.text,
      'phone': _phone.text,
      'address': _address.text,
      'fbLink': _fbLink.text,
      'youtubeLink': _youtubeLink.text,
      'twitterLink': _twitterLink.text,
      'instagram': _instragramLink.text,
      'linkedIn': _linkedInLink.text,
      'date': dateData,
    };
    await firebaseProvider.addContactInfo(map).then((value) {
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
    _email.clear();
    _phone.clear();
    _address.clear();
    _fbLink.clear();
    _youtubeLink.clear();
    _twitterLink.clear();
    _instragramLink.clear();
    _linkedInLink.clear();
  }
}
