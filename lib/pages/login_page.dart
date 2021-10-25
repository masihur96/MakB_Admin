import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/main_page.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var userNameTextController = TextEditingController();
  var passwordTextController = TextEditingController();

  bool _isLoading =false;

  int counter=0;

  _customInit(FirebaseProvider firebaseProvider){
    setState(() {
      counter++;
    });

    firebaseProvider.getAdminData();

  }



  @override
  Widget build(BuildContext context) {
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);
    final Size size = MediaQuery.of(context).size;

    if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
      setState(() {
        publicProvider.deviceDetect = 'mobile';
      });// print('iOS');
    }
    else if ((defaultTargetPlatform == TargetPlatform.linux) || (defaultTargetPlatform == TargetPlatform.macOS) || (defaultTargetPlatform == TargetPlatform.windows)) {
      setState(() {
        publicProvider.deviceDetect = 'windows';
      });
    //  print('windows'); // Some desktop specific code there
    }
    else {

      setState(() {
        publicProvider.deviceDetect = 'windows';

      });

      // Some web specific code there
    }

    if(counter==0){
      _customInit(firebaseProvider);
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade700,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:publicProvider.deviceDetect=='windows'? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              size.width>700?
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign In With',textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: publicProvider.deviceDetect=='windows'? size.height*.05:size.width*.04,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  publicProvider.deviceDetect=='windows'? Image.asset(
                    'assets/images/deub.gif',fit: BoxFit.fill,
                    width:publicProvider.deviceDetect=='windows'? size.width*.15:size.width*.1,
                    height: publicProvider.deviceDetect=='windows'?size.width*.15:size.width*.1,
                  ):Container(),
                ],
              ):Container(),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 6),
                child: Column(
                  children: [
                    size.width<700?  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ligin to \nMy Application',textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: publicProvider.deviceDetect=='windows'? size.height*.04:size.width*.04,
                            fontWeight: FontWeight.normal,
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),


                      ],
                    ):Container(),


                    Container(
                      width: publicProvider.deviceDetect=='windows'? size.height*.5:size.width*.4,
                      height: publicProvider.deviceDetect=='windows'? size.height*.5:size.width*.4,

                      child: _formLogin(context),
                    ),
                  ],
                ),
              )
            ],
          ):Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login to \nMy Application',textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: publicProvider.deviceDetect=='windows'? size.height*.04:size.width*.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  publicProvider.deviceDetect=='windows'? Image.asset(
                    'assets/icons/logo.PNG',fit: BoxFit.fill,
                    width:publicProvider.deviceDetect=='windows'? size.height*.1:size.width*.1,
                    height: publicProvider.deviceDetect=='windows'? size.height*.1:size.width*.1,
                  ):Container(),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 6),
                child: Container(
                  width: publicProvider.deviceDetect=='windows'? size.height*.1:size.width*.1,
                  child: _formLogin(context),
                ),
              )
            ],
          ),
        ));
  }

  Widget _formLogin(BuildContext context) {
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);
    final Size size = MediaQuery.of(context).size;
    return Container(

      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1,color: Colors.grey),
          color: Colors.white


      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
              child: TextField(
                controller: userNameTextController,
                decoration: textFieldFormDecorationLogin(size,publicProvider).copyWith(
                  labelText: 'User Name',
                  hintText: 'User Name',
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
              child: TextField(
                controller: passwordTextController,
                decoration: textFieldFormDecorationLogin(size,publicProvider).copyWith(
                  labelText: 'Password',
                  hintText: 'Password',

                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: double.infinity,
                    child: Text("Sign In",textAlign: TextAlign.center,)),
              ),
              onPressed: () {

             //   _submitSubCategoryData();

                print(firebaseProvider.adminList[0].userName);
                print(firebaseProvider.adminList[0].password);

                if(firebaseProvider.adminList[0].userName == userNameTextController.text && firebaseProvider.adminList[0].password == passwordTextController.text){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>MainPage()));
                }
                else {
                  showToast('Wrong User Name or Password');
                }


              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

