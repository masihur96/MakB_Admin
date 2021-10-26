import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/pages/add_balance_page.dart';
import 'package:makb_admin_pannel/pages/advertisement_page.dart';
import 'package:makb_admin_pannel/pages/all_product_page.dart';
import 'package:makb_admin_pannel/pages/area_hub_page.dart';
import 'package:makb_admin_pannel/pages/customer_page.dart';
import 'package:makb_admin_pannel/pages/depositedetails_page.dart';
import 'package:makb_admin_pannel/pages/insurance_details_page.dart';
import 'package:makb_admin_pannel/pages/package_details.dart';
import 'package:makb_admin_pannel/pages/product_details_page.dart';
import 'package:makb_admin_pannel/pages/refer_page.dart';
import 'package:makb_admin_pannel/pages/regular_orders_page.dart';
import 'package:makb_admin_pannel/pages/add_package_page.dart';
import 'package:makb_admin_pannel/pages/add_product_page.dart';
import 'package:makb_admin_pannel/pages/all_package.dart';
import 'package:makb_admin_pannel/pages/settings_page.dart';
import 'package:makb_admin_pannel/pages/dashboard_page.dart';
import 'package:makb_admin_pannel/pages/deposite_page.dart';
import 'package:makb_admin_pannel/pages/insurance_page.dart';
import 'package:makb_admin_pannel/pages/update_product.dart';
import 'package:makb_admin_pannel/pages/withdraw_details_page.dart';
import 'package:makb_admin_pannel/pages/withdrow_page.dart';



class PublicProvider extends ChangeNotifier{
  String _category='';
  String _subCategory='';

  String deviceDetect='';
  bool isWindows=false;

  String  get category=>_category;
  String get subCategory=> _subCategory;

  set subCategory(String value){
    _subCategory=value;
    notifyListeners();
  }
  set category(String value){
    _category=value;
    notifyListeners();
  }

  double pageWidth(Size size){
    if(size.width<1300) return size.width;
    else return size.width*.85;
  }

  String pageHeader(){
    if(_category.isNotEmpty && _subCategory.isNotEmpty) return '$_category  \u276D  $_subCategory';
    else if(_category.isEmpty && _subCategory.isNotEmpty) return '$_subCategory';
    else return 'Dashboard';
  }

  Widget pageBody(){
    if(_subCategory=='Add Product') return UploadProductPage();
    else if(_subCategory=='All Product') return AllProductPage();
    else if(_subCategory=='Update Product') return UpdateProduct();
    else if(_subCategory=='Regular Orders') return RegularOrderPage();
    else if(_subCategory=='Add Package') return UploadPackagePage();
    else if(_subCategory=='All Package') return AllPackagePage();
    else if(_subCategory=='Area') return AreaHub();
    else if(_subCategory=='Hub') return AreaHub();
    else if(_subCategory=='Deposit') return DepositePage();
    else if(_subCategory=='Insurance') return InsurancePage();
    else if(_subCategory=='Withdraw') return WithdrowPage();
    else if(_subCategory=='Withdraw Details') return WithdrawDetails();
    else if(_subCategory=='Add Amount') return AddBalance();
    else if(_subCategory=='Customer') return CustomerPage();
    else if(_subCategory=='Advertisement') return Advertisement();
    else if(_subCategory=='Settings') return SettingsPage();
    else if(_subCategory=='ProductDetails') return ProductDetails();
    else if(_subCategory=='PackageDetails') return PackageDetailsPage();
    else if(_subCategory=='DepositDetails') return DepositeDetails();
    else if(_subCategory=='InsuranceDetails') return InsuranceDetails();


    return DashBoardPage();
  }

  // Future<bool> validateAdmin(BuildContext context, String phone, String password)async{
  //   try{
  //     QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Admin')
  //         .where('phone', isEqualTo: phone).get();
  //     final List<QueryDocumentSnapshot> user = snapshot.docs;
  //     if(user.isNotEmpty && user[0].get('password')==password){
  //       return true;
  //     }else{
  //       return false;
  //     }
  //   }catch(error){
  //     showToast(error.toString());
  //     return false;
  //   }
  // }
}