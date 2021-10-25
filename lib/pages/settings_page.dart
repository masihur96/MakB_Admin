import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';

import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _oldPassword = TextEditingController(text: '');
  TextEditingController _newPassword = TextEditingController(text: '');
  TextEditingController _reNewPassword = TextEditingController(text: '');
  String error = 'Put a Strong Password';
  bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);
    return Container(
      width: publicProvider.pageWidth(size),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                error,
                style: TextStyle(
                    color: Colors.green, fontSize: size.height * .04),
              ),
            ),
            Container(
              height: size.height * .55,
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
                      controller: _oldPassword,
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(width: 1,color: Colors.green),
                        ),
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _newPassword,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(width: 1),
                        ),
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _reNewPassword,
                      decoration: InputDecoration(
                        labelText: 'Re-Enter New Password',
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(width: 1),
                        ),
                      ),
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: 10),
                  _isLoading
                      ? fadingCircle
                      : ElevatedButton(
                    onPressed: () {
                      setState(() => _isLoading = true);

                      updateData(firebaseProvider);

                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0.0),
                      child: Text(
                        'UPDATE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * .03,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                  )
                ]),
              ),
            ),
          ],
        ),
      )
    );
  }
  // Future<void> updateData(FirebaseProvider firebaseProvider) async {
  //   DateTime date = DateTime.now();
  //   String dateData = '${date.month}-${date.day}-${date.year}';
  //
  //
  //   if(firebaseProvider.advertisementList.length<6){
  //     Map<String, dynamic> map = {
  //       'videoUrl': videoUrl,
  //       'id': uuid,
  //       'date': dateData,
  //       'title': titleTextController.text,
  //
  //     };
  //     await firebaseProvider.addVideoData(map).then((value) {
  //       if (value) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //         showToast('Success');
  //         _emptyFiledCreator();
  //         firebaseProvider.getVideo();
  //
  //
  //       } else {
  //         setState(() => _isLoading = false);
  //         showToast('Failed');
  //       }
  //     });
  //   }else {
  //     showToast('You Have Already Five Videos');
  //   }
  //
  //   // setState(() => _isLoading = true);
  //
  //
  // }

  void updateData(FirebaseProvider firebaseProvider) async {
    setState(() => _isLoading = true);


    if (firebaseProvider.adminList[0].password != _oldPassword.text) {
      setState(() {
        error = 'Old Password is Wrong!';
      });
    } else {

      if (_newPassword.text == _reNewPassword.text) {
        if (_newPassword.text.length > 6) {
          await FirebaseFirestore.instance
              .collection('Admin')
              .doc('Deub_Admin')
              .update({'password': _reNewPassword.text}).then((value) {

                firebaseProvider.getAdminData();
                setState(() {
                  _isLoading = false;
                  _oldPassword.clear();
                  _newPassword.clear();
                  _reNewPassword.clear();
                });
          });


        } else {
          setState(() {
            error = 'Minimum 6 character required';
            _isLoading = true;
          });
        }
      } else {
        setState(() {
          error = 'Password Does Not Match';
          _isLoading = true;
        });
      }
    }
    _isLoading = false;
  }

}
