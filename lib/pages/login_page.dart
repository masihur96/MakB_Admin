import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/main_page.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var userNameTextController = TextEditingController();
  var passwordTextController = TextEditingController();

  bool _isLoading =false;

  int counter=0;

  _customInit(FirebaseProvider firebaseProvider)async{
      counter++;
    await  firebaseProvider.getAdminData();


  }



  @override
  Widget build(BuildContext context) {
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);
    final Size size = MediaQuery.of(context).size;
    if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
      setState(() {
        publicProvider.isWindows = false;
      });
    }
    else if ((defaultTargetPlatform == TargetPlatform.linux) || (defaultTargetPlatform == TargetPlatform.macOS) || (defaultTargetPlatform == TargetPlatform.windows)) {
      setState(() {
        publicProvider.isWindows = true;
      });
    }
    else {
      setState(() {
        publicProvider.isWindows = true;
      });
    }
    if(counter==0){
      _customInit(firebaseProvider);
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade700,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:publicProvider.isWindows? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              size.width>700?
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  publicProvider.isWindows? Image.asset(
                    'assets/images/deub.png',fit: BoxFit.fill,
                    width: size.width*.15,
                    height:size.width*.15,
                  ):Container(),
                  Text(
                    'DEUB',textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.height*.05,
                      fontWeight: FontWeight.normal,
                      color: Colors.white
                    ),
                  ),
                  Text(
                    'Digital Elimination of Unemployment in Bangladesh',textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.height*.03,
                      fontWeight: FontWeight.normal,
                        color: Colors.yellow
                    ),
                  ),
                ],
              ):Container(),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    size.width<700?  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login to \nMy Application',textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize:size.height*.04,
                            fontWeight: FontWeight.normal,
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ):Container(),

                    Container(
                      width: size.height*.5,
                      height:size.height*.5,

                      child: _formLogin(context),
                    ),
                  ],
                ),
              )
            ],
          ):Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login to \nMy Application',textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width*.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    'assets/images/deub.gif',fit: BoxFit.fill,
                    width:size.width*.1,
                    height:size.width*.1,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 6),
                child: Container(
                  width:size.width*.1,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to DEUB\n Login',textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: publicProvider.isWindows? size.height*.03:size.width*.03,

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
              child: Container(
                width: publicProvider.isWindows? size.height*.5:size.width*.6,
                child: TextField(
                  controller: userNameTextController,
                  decoration: textFieldFormDecorationLogin(size,publicProvider).copyWith(
                    labelText: 'User Name',
                    hintText: 'User Name',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
              child: Container(
                width: publicProvider.isWindows? size.height*.5:size.width*.6,
                child: TextField(
                  controller: passwordTextController,
                  decoration: textFieldFormDecorationLogin(size,publicProvider).copyWith(
                    labelText: 'Password',
                    hintText: 'Password',

                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(width: publicProvider.isWindows? size.height*.4:size.width*.5,
                    padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                    child: Text("Sign In",textAlign: TextAlign.center,)),
              ),
              onPressed: ()async {

                if(firebaseProvider.adminList[0].userName == userNameTextController.text && firebaseProvider.adminList[0].password == passwordTextController.text){
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  pref.setString('phone', userNameTextController.text);
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

