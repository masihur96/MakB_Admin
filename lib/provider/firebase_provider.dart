
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/data_model/dart/admin_model.dart';
import 'package:makb_admin_pannel/data_model/dart/advertisement_model.dart';
import 'package:makb_admin_pannel/data_model/dart/area_hub_model.dart';
import 'package:makb_admin_pannel/data_model/dart/category_model.dart';
import 'package:makb_admin_pannel/data_model/dart/customer_data_model.dart';
import 'package:makb_admin_pannel/data_model/dart/package_model.dart';
import 'package:makb_admin_pannel/data_model/dart/product_id_model.dart';
import 'package:makb_admin_pannel/data_model/dart/product_model.dart';
import 'package:makb_admin_pannel/data_model/dart/set_rate_model.dart';
import 'package:makb_admin_pannel/data_model/dart/sub_category_model.dart';
import 'package:makb_admin_pannel/data_model/dart/withdraw_history_model.dart';
import 'package:makb_admin_pannel/data_model/dart/withdraw_request_model.dart';


class FirebaseProvider extends ChangeNotifier {

  List<UserModel> _userList = [];
  get userList => _userList;


  List<CategoryModel> _categoryList = [];
  get categoryList => _categoryList;

  List<SubCategoryModel> _subCategoryList = [];
  get subCategoryList => _subCategoryList;

  List<ProductModel> _productList = [];
  get productList => _productList;

  List<PackageModel> _packageList = [];
  get packageList => _packageList;

  List<AreaHubModel> _areaHubList = [];
  get areaHubList => _areaHubList;

  List<RateModel> _rateDataList = [];
  get rateDataList => _rateDataList;

  List<WithdrawRequestModel> _withdrawRequestList = [];
  get withdrawRequestList => _withdrawRequestList;

  List<WithdrawHistoryModel> _withdrawHistoryList = [];
  get withdrawHistoryList => _withdrawHistoryList;

  List<AdvertisementModel> _advertisementList = [];
  get advertisementList => _advertisementList;

  List<AdminModel> _adminList = [];
  get adminList => _adminList;

  // List<ProductIdModel> _productID = [];
  // get productID => _productID;

  var day;
  var month;
  var year;

  int? depositIndex;
  int? withdrawIndex;

  int? insuranceID;


  Future<void> getUser()async{

    try{
      await FirebaseFirestore.instance.collection('Users').get().then((snapShot){
        _userList.clear();
        snapShot.docChanges.forEach((element) {

          UserModel user=UserModel(
            id: element.doc['id'],
            name: element.doc['name'],
            address: element.doc['address'],
            phone: element.doc['phone'],
            password: element.doc['password'],
            nbp: element.doc['nbp'],
            email: element.doc['email'],
            zip: element.doc['zip'],
            referCode: element.doc['referCode'],
            // timeStamp: element.doc['timeStamp'],
            referDate: element.doc['referDate'],
            imageUrl: element.doc['imageUrl'],
            //referredList: element.doc['referredList'],
            numberOfReferred: element.doc['numberOfReferred'],
            insuranceEndingDate: element.doc['insuranceEndingDate'],
            depositBalance: element.doc['depositBalance'],
            //depositHistory: element.doc['depositHistory'],
            //withdrawHistory: element.doc['withdrawHistory'],
            insuranceBalance: element.doc['insuranceBalance'],
            lastInsurancePaymentDate: element.doc['lastInsurancePaymentDate'],
            level: element.doc['level'],
            mainBalance: element.doc['mainBalance'],
            videoWatched: element.doc['videoWatched'],
            watchDate: element.doc['watchDate'],
            myStore: element.doc['myStore'],
            myOrder: element.doc['myOrder'],
            //cartList: element.doc['cartList'],
            referLimit: element.doc['referLimit'],
          );

          final  date = new DateTime.fromMicrosecondsSinceEpoch(element.doc['timeStamp']*1000);

          day = date.day;
          month = date.month;
          year = date.year;


          _userList.add(user);
        });
        print('Customer List: ${_userList.length}');
        print(day);
        print(month);
        print(year);
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> getCategory()async{
    try{
      await FirebaseFirestore.instance.collection('Category').get().then((snapShot){
        _categoryList.clear();
        snapShot.docChanges.forEach((element) {
          CategoryModel category=CategoryModel(
            category: element.doc['category'],
            id: element.doc['id'],



          );
          _categoryList.add(category);
        });


        print(_categoryList.length);
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> getSubCategory()async{
    try{
      await FirebaseFirestore.instance.collection('SubCategory').get().then((snapShot){
        _subCategoryList.clear();
        snapShot.docChanges.forEach((element) {
          SubCategoryModel subCategory= SubCategoryModel(
            subCategory: element.doc['subCategory'],
            id: element.doc['id'],

          );
          _subCategoryList.add(subCategory);
        });
        print(_subCategoryList.length);
      });


    }catch(error){
      print(error);
    }
  }

  Future<void> getProducts()async{
    try{
      await FirebaseFirestore.instance.collection('Products').get().then((snapShot){
        _productList.clear();
        snapShot.docChanges.forEach((element) {
          ProductModel productModel=ProductModel(
            id: element.doc['id'],
            title: element.doc['title'],
            description: element.doc['description'],
            price: element.doc['price'],
            profitAmount: element.doc['profitAmount'],
            size: element.doc['size'],
            category: element.doc['category'],
            subCategory: element.doc['subCategory'],
            colors: element.doc['colors'],
            image: element.doc['image'],
            date: element.doc['date'],
          );
          _productList.add(productModel) ;
        });
        print('Product List: ${_productList.length}');
        notifyListeners();
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> getPackage()async{
    try{
      await FirebaseFirestore.instance.collection('Packages').get().then((snapShot){
        _packageList.clear();
        snapShot.docChanges.forEach((element) {
          PackageModel packageModel=PackageModel(
            id: element.doc['id'],
            title: element.doc['title'],
            description: element.doc['description'],
            price: element.doc['price'],
            size: element.doc['size'],
            colors: element.doc['colors'],
            image: element.doc['image'],
            date: element.doc['date'],
            discountAmount: element.doc['discountAmount']

          );
          _packageList.add(packageModel) ;
        });
        print('Package List: ${_packageList.length}');
        notifyListeners();
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> getAreaHub()async{
    try{
      await FirebaseFirestore.instance.collection('Area&Hub').get().then((snapShot){
        _areaHubList.clear();
        snapShot.docChanges.forEach((element) {
          AreaHubModel areaHubModel=AreaHubModel(
            hub: element.doc['hub'],
            id: element.doc['id'],
          );
          _areaHubList.add(areaHubModel) ;
        });
        print('Hub List${_areaHubList.length}');
        notifyListeners();
      });
    }catch(error){
      print(error);
    }
  }
  Future<void> getRate()async{
    try{
      await FirebaseFirestore.instance.collection('SetRate').get().then((snapShot){
        _rateDataList.clear();
        snapShot.docChanges.forEach((element) {
          RateModel rateModel=RateModel(
            serviceCharge: element.doc['serviceCharge'],
            referAmount: element.doc['referAmount'],
            videoRate: element.doc['videoRate'],
            date: element.doc['date'],
          );
          _rateDataList.add(rateModel) ;
        });

        print(_rateDataList.length);
        notifyListeners();
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> getWithdrawRequest()async{
    try{
      await FirebaseFirestore.instance.collection('WithdrawRequests').get().then((snapShot){
        _withdrawRequestList.clear();
        snapShot.docChanges.forEach((element) {
          WithdrawRequestModel withdrawRequestModel=WithdrawRequestModel(
            amount: element.doc['amount'],
            date: element.doc['date'],
            id: element.doc['id'],
            name: element.doc['name'],
            phone: element.doc['phone'],
            status: element.doc['status'],

          );
          _withdrawRequestList.add(withdrawRequestModel) ;
        });
        print('Withdraw Request: ${_withdrawRequestList.length}');
        notifyListeners();
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> getWithdrawHistory()async{
    try{
      await FirebaseFirestore.instance.collection('Users').doc(withdrawRequestList[withdrawIndex].id).collection('WithdrawHistory').get().then((snapShot){
        _withdrawHistoryList.clear();
        snapShot.docChanges.forEach((element) {
          WithdrawHistoryModel withdrawHistoryModel=WithdrawHistoryModel(
            amount: element.doc['amount'],
            date: element.doc['date'],
            id: element.doc['id'],
            imageUrl: element.doc['imageUrl'],
            name: element.doc['name'],
            phone: element.doc['phone'],
            status: element.doc['status'],

          );
          _withdrawHistoryList.add(withdrawHistoryModel) ;
        });
        print('Withdraw History: ${_withdrawHistoryList.length}');
        notifyListeners();
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> getVideo()async{
    try{
      await FirebaseFirestore.instance.collection('Advertisement').get().then((snapShot){
        _advertisementList.clear();
        snapShot.docChanges.forEach((element) {
          AdvertisementModel advertisementModel=AdvertisementModel(
            videoUrl: element.doc['videoUrl'],
            date: element.doc['date'],
            id: element.doc['id'],
            title: element.doc['title'],


          );
          _advertisementList.add(advertisementModel) ;
        });
        print('Advertisement: ${_advertisementList.length}');
        notifyListeners();
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> getAdminData()async{
    try{
      await FirebaseFirestore.instance.collection('Admin').get().then((snapShot){
        _adminList.clear();
        snapShot.docChanges.forEach((element) {
          AdminModel adminModel=AdminModel(
            userName: element.doc['userName'],
            password: element.doc['password'],
          );
          _adminList.add(adminModel) ;
        });
        print('Admin: ${_adminList.length}');
        notifyListeners();
      });
    }catch(error){
      print(error);
    }
  }

  Future<bool> addCategoryData(Map<String, String> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("Category")
          .doc(map['id'])
          .set(map);

    await  getCategory();
      notifyListeners();
      return true;
    } catch (err) {

      print(err);
      // showToast(err.toString());
      return false;
    }
  }



  Future<bool> addSubCategoryData(Map<String, String> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("SubCategory")
          .doc(map['id'])
          .set(map);

      await getSubCategory();
      notifyListeners();
      return true;
    } catch (err) {

      print(err);
      // showToast(err.toString());
      return false;
    }
  }



  Future<bool> addProductData(Map<String, dynamic> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("Products")
          .doc(map['id'])
          .set(map);
      notifyListeners();
      return true;
    } catch (err) {

      print(err);
     // showToast(err.toString());
      return false;
    }
  }
  Future<bool> addPackageData(Map<String, dynamic> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("Packages")
          .doc(map['id'])
          .set(map);

      notifyListeners();
      return true;
    } catch (err) {

      print(err);
      // showToast(err.toString());
      return false;
    }
  }

  Future<bool> addVideoData(Map<String, dynamic> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("Advertisement")
          .doc(map['id'])
          .set(map);
      notifyListeners();
      return true;
    } catch (err) {

      print(err);
      // showToast(err.toString());
      return false;
    }
  }

  Future<bool> addDepositData(Map<String, dynamic> map,String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(id)
          .update(map);
      notifyListeners();
      return true;
    } catch (err) {

      print(err);
      // showToast(err.toString());
      return false;
    }
  }
  Future<bool> updateDepositData(Map<String, dynamic> map,String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(id)
          .update(map);
      notifyListeners();
      return true;
    } catch (err) {

      print(err);
      // showToast(err.toString());
      return false;
    }
  }

  Future<bool> addRateChart(Map<String, dynamic> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("SetRate")
          .doc('MakB-Rate')
          .set(map);
      notifyListeners();
      return true;
    } catch (err) {

      print(err);
      // showToast(err.toString());
      return false;
    }
  }

  // Future<bool> updateStatusData(Map<String, dynamic> map) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection("WithdrawRequests")
  //         .doc('MakB-Rate')
  //         .set(map);
  //     notifyListeners();
  //     return true;
  //   } catch (err) {
  //
  //     print(err);
  //     // showToast(err.toString());
  //     return false;
  //   }
  // }

  Future<bool> addHubData(Map<String, dynamic> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("Area&Hub")
          .doc(map['id'])
          .set(map);
      notifyListeners();
      return true;
    } catch (err) {

      print(err);
      // showToast(err.toString());
      return false;
    }
  }

  Future<bool> updateHubData(Map<String, dynamic> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("Area&Hub")
          .doc(map['id'])
          .update(map);
      notifyListeners();
      return true;
    } catch (err) {

      print(err);
      // showToast(err.toString());
      return false;
    }
  }


  Future<bool> deleteSubCategoryData(Map<String, String> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("SubCategory")
          .doc(map['id'])
          .set(map);

      await  getCategory();
      notifyListeners();
      return true;
    } catch (err) {

      print(err);
      // showToast(err.toString());
      return false;
    }
  }

  Future<bool> deleteProductData(Map<String, String> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("Products")
          .doc(map['id'])
          .set(map);

      await  getCategory();
      notifyListeners();
      return true;
    } catch (err) {

      print(err);
      // showToast(err.toString());
      return false;
    }
  }



}
