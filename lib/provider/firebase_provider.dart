
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/data_model/dart/admin_model.dart';
import 'package:makb_admin_pannel/data_model/dart/advertisement_model.dart';
import 'package:makb_admin_pannel/data_model/dart/area_hub_model.dart';
import 'package:makb_admin_pannel/data_model/dart/category_model.dart';
import 'package:makb_admin_pannel/data_model/dart/customer_data_model.dart';
import 'package:makb_admin_pannel/data_model/dart/depositeRequestModel.dart';
import 'package:makb_admin_pannel/data_model/dart/info_model.dart';
import 'package:makb_admin_pannel/data_model/dart/insurance_request_model.dart';
import 'package:makb_admin_pannel/data_model/dart/package_model.dart';
import 'package:makb_admin_pannel/data_model/dart/package_order_request_model.dart';
import 'package:makb_admin_pannel/data_model/dart/product_id_model.dart';
import 'package:makb_admin_pannel/data_model/dart/product_model.dart';
import 'package:makb_admin_pannel/data_model/dart/product_order_model.dart';
import 'package:makb_admin_pannel/data_model/dart/refer_model.dart';
import 'package:makb_admin_pannel/data_model/dart/set_rate_model.dart';
import 'package:makb_admin_pannel/data_model/dart/sub_category_model.dart';
import 'package:makb_admin_pannel/data_model/dart/withdraw_history_model.dart';
import 'package:makb_admin_pannel/data_model/dart/withdraw_request_model.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';


class FirebaseProvider extends ChangeNotifier {

  List<UserModel> _userList = [];
  get userList => _userList;


  List<CategoryModel> _categoryList = [];
  get categoryList => _categoryList;

  List<SubCategoryModel> _subCategoryList = [];
  get subCategoryList => _subCategoryList;

  List<ProductModel> _productList = [];
  get productList => _productList;

  List<ProductOrderModel> _productOrderList = [];
  get productOrderList => _productOrderList;

  List<ProductOrderModel> _productPendingOrderList = [];   //Pending Product list
  get productPendingOrderList => _productPendingOrderList;

  List<PackageModel> _packageList = [];
  get packageList => _packageList;

  List<PackageOrderModel> _packageOrderList = [];
  get packageOrderList => _packageOrderList;

  List<PackageOrderModel> _packagePendingOrderList = [];    //Package Stored List
  get packagePendingOrderList => _packagePendingOrderList;

  List<ReferModel> _referList = [];
  get referList => _referList;

  List<PackageModel> _soldPackageList = [];
  get soldPackageList => _soldPackageList;

  List<AreaHubModel> _areaHubList = [];
  get areaHubList => _areaHubList;

  List<RateModel> _rateDataList = [];
  get rateDataList => _rateDataList;



  List<WithdrawRequestModel> _withdrawRequestList = [];
  get withdrawRequestList => _withdrawRequestList;

  List<DepositRequestModel> _depositRequestList = [];
  get depositRequestList => _depositRequestList;

  List<WithdrawHistoryModel> _withdrawHistoryList = [];
  get withdrawHistoryList => _withdrawHistoryList;


  List<DepositRequestModel> _depositHistoryList = [];
  get depositHistoryList => _depositHistoryList;

  List<InsuranceModel> _insuranceRequestList = [];
  get insuranceRequestList => _insuranceRequestList;

  List<InsuranceModel> _insuranceTransferredRequestList = [];
  get insuranceTransferredRequestList => _insuranceTransferredRequestList;


  List<AdvertisementModel> _advertisementList = [];
  get advertisementList => _advertisementList;

  List<AdminModel> _adminList = [];
  get adminList => _adminList;

  List<ContactInfoModel> _infoList = [];
  get infoList => _infoList;

  // List<ProductIdModel> _productID = [];
  // get productID => _productID;

  var day;
  var month;
  var year;
  int? customerIndex;
  int? productIndex;
  int? packageIndex;
  int? depositIndex;
  int? withdrawIndex;

  int? insuranceID;


String? DateFromDatabase;

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
            timeStamp: element.doc['timeStamp'],
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

         final  date = new DateTime.fromMillisecondsSinceEpoch(int.parse(element.doc['timeStamp']));
          day = date.day;
          month = date.month;
          year = date.year;
           DateFromDatabase = '${date.day}-${date.month}-${date.year}';
          _userList.add(user);
        });

        print('Customeraaaaaa List: ${_userList.length}');

      });
    }catch(error){
      print('get User: $error');
    }
  }

  String userMainBalance='';
  String userDepositBalance='';
  Future<void> getSingleUserData(String id)async{
    try {

      var document = await FirebaseFirestore.instance.collection('Users').doc(id).get();

      // ignore: unnecessary_statements

      userMainBalance = document['mainBalance'];
      userDepositBalance = document['depositBalance'];
      print('Single User MainBalance: ${document['mainBalance']}');
      print('Single User DepositBalance: ${document['depositBalance']}');

    }catch(error){
      print('get Single User Name: $error');
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
        print('Category List: ${_categoryList.length}');
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
            category: element.doc['category'],
          );
          _subCategoryList.add(subCategory);
        });
        print('SubCAtegory: ${_subCategoryList.length}');
      });


    }catch(error){
      print(error);
    }
  }

  Future<void> getProducts()async{
    try{
      await FirebaseFirestore.instance.collection('Products').orderBy('title').get().then((snapShot){
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
            thumbnail: element.doc['thumbnail'],
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
      await FirebaseFirestore.instance.collection('Packages').orderBy('title').get().then((snapShot){
        _packageList.clear();
        snapShot.docChanges.forEach((element) {
          PackageModel packageModel=PackageModel(
            id: element.doc['id'],
            title: element.doc['title'],
            description: element.doc['description'],
            price: element.doc['price'],
            quantity: element.doc['quantity'],
            size: element.doc['size'],
            colors: element.doc['colors'],
            image: element.doc['image'],
            date: element.doc['date'],
            discountAmount: element.doc['discountAmount'],
            thumbnail: element.doc['thumbnail']

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

  Future<void> getPackageRequest()async{
    try{
      await FirebaseFirestore.instance.collection('PackageCollectionRequest').get().then((snapShot){
        _packageOrderList.clear();
        snapShot.docChanges.forEach((element) {
          PackageOrderModel packageOrderModel=PackageOrderModel(
              colors: element.doc['colors'],
              date: element.doc['date'],
              discount: element.doc['discount'],
              id: element.doc['id'],
              imageUrl: element.doc['imageUrl'],
              packageId: element.doc['packageId'],
              productName: element.doc['productName'],
              productPrice: element.doc['productPrice'],
              quantity: element.doc['quantity'],
              sizes: element.doc['sizes'],
              status: element.doc['status'],
              userName: element.doc['userName'],
              userAddress: element.doc['userAddress'],
              userPhone: element.doc['userPhone'],
          );
          _packageOrderList.add(packageOrderModel) ;
        });
        print('Package Order List: ${_packageOrderList.length}');
        notifyListeners();
      });

      await FirebaseFirestore.instance.collection('PackageCollectionRequest').where('status',isEqualTo: 'stored').get().then((snapShot){
        _packagePendingOrderList.clear();
        snapShot.docChanges.forEach((element) {
          PackageOrderModel packageOrderModel=PackageOrderModel(
            colors: element.doc['colors'],
            date: element.doc['date'],
            discount: element.doc['discount'],
            id: element.doc['id'],
            imageUrl: element.doc['imageUrl'],
            packageId: element.doc['packageId'],
            productName: element.doc['productName'],
            productPrice: element.doc['productPrice'],
            quantity: element.doc['quantity'],
            sizes: element.doc['sizes'],
            status: element.doc['status'],
            userName: element.doc['userName'],
            userAddress: element.doc['userAddress'],
            userPhone: element.doc['userPhone'],
          );
          _packagePendingOrderList.add(packageOrderModel) ;
        });
        print('Package Stored Order List: ${_packagePendingOrderList.length}');
        notifyListeners();
      });
    }catch(error){
      print(error);
    }
  }
  Future<void> getReferCode(String userId)async{
    try{
      await FirebaseFirestore.instance.collection('Users').doc(userId).collection('referredList').get().then((snapShot){
        _referList.clear();
        snapShot.docChanges.forEach((element) {
          ReferModel referModel=ReferModel(
            date: element.doc['date'],
            id: element.doc['id'],
            name: element.doc['name'],
            phone: element.doc['phone'],
            profit: element.doc['profit'],
            referCode: element.doc['referCode'],
          );
          _referList.add(referModel);
        });


        print('Refer List: ${_referList.length}');
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> getSoldPackage()async{
    try{
      await FirebaseFirestore.instance.collection('SoldPackages').get().then((snapShot){
        _soldPackageList.clear();
        snapShot.docChanges.forEach((element) {
          PackageModel packageModel=PackageModel(
              id: element.doc['id'],
              title: element.doc['productName'],
              description: element.doc['description'],
              price: element.doc['productPrice'],
              quantity: element.doc['quantity'],
              size: element.doc['sizes'],
              colors: element.doc['colors'],
              image: element.doc['imageUrl'],
              date: element.doc['date'],
              discountAmount: element.doc['discount']

          );
          _soldPackageList.add(packageModel) ;
        });
        print('Sold Package List: ${_soldPackageList.length}');
        notifyListeners();
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> getProductOrder()async{
    try{
      await FirebaseFirestore.instance.collection('Orders').get().then((snapShot){
        _productOrderList.clear();
        snapShot.docChanges.forEach((element) {
          ProductOrderModel productOrderModel =ProductOrderModel(
              Area: element.doc['Area'],
              hub: element.doc['hub'],
              name: element.doc['name'],
              orderDate: element.doc['orderDate'],
              orderNumber: element.doc['orderNumber'],
              phone: element.doc['phone'],
              products: element.doc['products'],
              quantity: element.doc['quantity'],
              state: element.doc['state'],
              totalAmount: element.doc['totalAmount'],
              id: element.doc['id']
          );
          _productOrderList.add(productOrderModel) ;
        });
        print('Product Order  List: ${_productOrderList.length}');
        notifyListeners();
      });

      await FirebaseFirestore.instance.collection('Orders').where('state',isEqualTo: 'pending').get().then((snapShot){
        _productPendingOrderList.clear();
        snapShot.docChanges.forEach((element) {
          ProductOrderModel productOrderModel =ProductOrderModel(
              Area: element.doc['Area'],
              hub: element.doc['hub'],
              name: element.doc['name'],
              orderDate: element.doc['orderDate'],
              orderNumber: element.doc['orderNumber'],
              phone: element.doc['phone'],
              products: element.doc['products'],
              quantity: element.doc['quantity'],
              state: element.doc['state'],
              totalAmount: element.doc['totalAmount'],
              id: element.doc['id']
          );
          _productPendingOrderList.add(productOrderModel) ;
        });
        print('Product Pending Order  List: ${_productPendingOrderList.length}');
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

  Future<void> getDepositRequest()async{
    try{
      await FirebaseFirestore.instance.collection('DepositRequests').where('status',isEqualTo:'pending').get().then((snapShot){
        _depositRequestList.clear();
        snapShot.docChanges.forEach((element) {
          DepositRequestModel depositRequestModel=DepositRequestModel(
            amount: element.doc['amount'],
            date: element.doc['date'],
            name: element.doc['name'],
            phone: element.doc['phone'],
            status: element.doc['status'],
            depositId: element.doc['depositId'],
            userId: element.doc['userId'],
          );
          _depositRequestList.add(depositRequestModel) ;
        });
        print('Deposit Request: ${_depositRequestList.length}');
        notifyListeners();
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> getDepositHistory(String userID)async{
    try{
      await FirebaseFirestore.instance.collection('Users').doc(userID).collection('DepositHistory').get().then((snapShot){
        _depositHistoryList.clear();
        snapShot.docChanges.forEach((element) {
          DepositRequestModel depositRequestModel=DepositRequestModel(
            amount: element.doc['amount'],
            date: element.doc['date'],
            name: element.doc['name'],
            phone: element.doc['phone'],
            status: element.doc['status'],
            depositId: element.doc['depositId'],
            userId: element.doc['userId'],

          );
          _depositHistoryList.add(depositRequestModel) ;
        });
        print('Deposit History: ${_depositHistoryList.length}');
        notifyListeners();
      });
    }catch(error){
      print(error);
    }
  }



  Future<void> getWithdrawRequest()async{
    try{
      await FirebaseFirestore.instance.collection('WithdrawRequests').where('status',isEqualTo:'pending').get().then((snapShot){
        _withdrawRequestList.clear();
        snapShot.docChanges.forEach((element) {
          WithdrawRequestModel withdrawRequestModel=WithdrawRequestModel(
            amount: element.doc['amount'],
            date: element.doc['date'],
            id: element.doc['id'],
            name: element.doc['name'],
            phone: element.doc['phone'],
            status: element.doc['status'],
            withdrawId: element.doc['withdrawId'],
            transactionMobileNo: element.doc['transactionMobileNo'],
            transactionSystem: element.doc['transactionSystem'],

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

  Future<void> getWithdrawHistory(String userID)async{
    try{
      await FirebaseFirestore.instance.collection('Users').doc(userID).collection('WithdrawHistory').get().then((snapShot){
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
            withdrawId: element.doc['withdrawId'],
            transactionMobileNo: element.doc['transactionMobileNo'],
            transactionSystem: element.doc['transactionSystem'],

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

  Future<void> getInsurancePendingRequest()async{
    try{
      await FirebaseFirestore.instance.collection('InsuranceWithDrawRequest').where('status',isEqualTo:'pending').get().then((snapShot){
        _insuranceRequestList.clear();
        snapShot.docChanges.forEach((element) {
          InsuranceModel insuranceModel=InsuranceModel(
              amount: element.doc['amount'],
              date: element.doc['date'],
              insuranceId: element.doc['insuranceId'],
              name: element.doc['name'],
              phone: element.doc['phone'],
              status: element.doc['status'],
              userId: element.doc['userId'],

          );
          _insuranceRequestList.add(insuranceModel) ;
        });
        print('Insurance List: ${_insuranceRequestList.length}');
        notifyListeners();
      });
    }catch(error){
      print(error);
    }
  }

  Future<void> getInsuranceTransferredRequest()async{
    try{
      await FirebaseFirestore.instance.collection('InsuranceWithDrawRequest').where('status',isEqualTo:'transferred').get().then((snapShot){
        _insuranceTransferredRequestList.clear();
        snapShot.docChanges.forEach((element) {
          InsuranceModel insuranceModel=InsuranceModel(
            amount: element.doc['amount'],
            date: element.doc['date'],
            insuranceId: element.doc['insuranceId'],
            name: element.doc['name'],
            phone: element.doc['phone'],
            status: element.doc['status'],
            userId: element.doc['userId'],
          );
          _insuranceTransferredRequestList.add(insuranceModel) ;
        });
        print('Insurance Transferred List: ${_insuranceTransferredRequestList.length}');
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

  Future<void> getContactInfo()async{
    try{
      await FirebaseFirestore.instance.collection('ContactInfo').get().then((snapShot){
        _infoList.clear();
        snapShot.docChanges.forEach((element) {
          ContactInfoModel contactInfoModel = ContactInfoModel(
            email: element.doc['email'],
            phone: element.doc['phone'],
            address: element.doc['address'],
            fbLink: element.doc['fbLink'],
            youtubeLink: element.doc['youtubeLink'],
            twitterLink: element.doc['twitterLink'],
            instagram: element.doc['instagram'],
            linkedIn: element.doc['linkedIn'],
            date: element.doc['date'],
          );
          _infoList.add(contactInfoModel) ;
        });
        print('Contact Info: ${_infoList.length}');
        notifyListeners();
      });
    }catch(error){
      print(error);
    }
  }
  //
  // Future<bool> addCategoryData(Map<String, String> map) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection("Category")
  //         .doc(map['id'])
  //         .set(map);
  //
  //   await  getCategory();
  //     notifyListeners();
  //     return true;
  //   } catch (err) {
  //
  //     print(err);
  //     // showToast(err.toString());
  //     return false;
  //   }
  // }
  //


  // Future<bool> addSubCategoryData(Map<String, String> map) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection("SubCategory")
  //         .doc(map['id'])
  //         .set(map);
  //
  //     await getSubCategory();
  //     notifyListeners();
  //     return true;
  //   } catch (err) {
  //
  //     print(err);
  //     // showToast(err.toString());
  //     return false;
  //   }
  // }
  //

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

  Future<bool> addInsuranceData(Map<String, dynamic> map,int index) async {
    String id = insuranceRequestList[index].userId;
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

  Future<bool> updateOrderStatus(Map<String, dynamic> map,int index) async {
    String id = productOrderList[index].id;

    try {
      await FirebaseFirestore.instance
          .collection("Orders")
          .doc(id)
          .update(map).then((value) {
          getProductOrder();
          });
      notifyListeners();
      return true;
    } catch (err) {

      print(err);
       showToast(err.toString());
      return false;
    }
  }

  Future<bool> updatePackageOrderStatus(Map<String, dynamic> map,int index) async {
    String id = packageOrderList[index].id;
    String userId = packageOrderList[index].userPhone;

    try {
      await FirebaseFirestore.instance
          .collection("PackageCollectionRequest")
          .doc(id)
          .update(map).then((value) async{
        await FirebaseFirestore.instance
            .collection("SoldPackages")
            .doc(id)
            .update(map);
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userId).collection('MyStore')
            .doc(id)
            .update(map);

        getPackageRequest();
      });
      notifyListeners();
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> updateAreaHub(Map<String, dynamic> map,String id) async {

    try {
      await FirebaseFirestore.instance
          .collection("Area&Hub")
          .doc(id)
          .update(map);
      notifyListeners();
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }



  Future<bool> updateInsuranceStatusData(Map<String, dynamic> map,int index) async {
    String id = insuranceRequestList[index].insuranceId;
    try {
      await FirebaseFirestore.instance
          .collection("InsuranceWithDrawRequest")
          .doc(id)
          .update(map).then((value) {
            getInsurancePendingRequest().then((value) => getInsuranceTransferredRequest());
          });
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
  Future<bool> addContactInfo(Map<String, dynamic> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("ContactInfo")
          .doc('MakB-Rate')
          .set(map).then((value) => getContactInfo());
      notifyListeners();
      return true;
    } catch (err) {

      print(err);
      // showToast(err.toString());
      return false;
    }
  }



  Future<bool> addHubData(Map<String, dynamic> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("Area&Hub")
          .doc(map['id'])
          .set(map).then((value) => getAreaHub());
      notifyListeners();
      return true;
    } catch (err) {

      print(err);
      // showToast(err.toString());
      return false;
    }
  }

  Future<bool> addCategoryData(Map<String, dynamic> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("Category")
          .doc(map['id'])
          .set(map).then((value) => getCategory());
      notifyListeners();


      return true;
    } catch (err) {

      print(err);
      // showToast(err.toString());
      return false;
    }
  }

  Future<bool> addSubCategoryData(Map<String, dynamic> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("SubCategory")
          .doc(map['id'])
          .set(map).then((value) => getSubCategory());
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
          .update(map).then((value) => getAreaHub());
      notifyListeners();
      return true;
    } catch (err) {

      print(err);
       showToast(err.toString());
      return false;
    }
  }

  Future<bool> updateCategoryData(Map<String, dynamic> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("Category")
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
  Future<bool> updateSubCategoryData(Map<String, dynamic> map) async {
    try {
      await FirebaseFirestore.instance
          .collection("SubCategory")
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




  Future<bool> updateStatusData(Map<String, dynamic> map,int index) async {

 //   print('WithDrow ID : ${withdrawRequestList[withdrawIndex].withdrawId}');
    try {
      await FirebaseFirestore.instance
          .collection("WithdrawRequests")
          .doc(withdrawRequestList[index].withdrawId)
          .update(map).then((value) async{
              await FirebaseFirestore.instance
                  .collection("Users")
                  .doc(withdrawRequestList[index].id).collection('WithdrawHistory').doc(withdrawRequestList[index].withdrawId)
                  .update(map).then((value) => getWithdrawRequest());
              notifyListeners();
          });
      notifyListeners();
      return true;
    } catch (err) {
      print(err);
      // showToast(err.toString());
      return false;
    }
  }


  Future<bool> refundWithdrawAmount(Map<String, dynamic> map,int index) async {

    //   print('WithDrow ID : ${withdrawRequestList[withdrawIndex].withdrawId}');
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(withdrawRequestList[index].id)
          .update(map).then((value) async{

              await FirebaseFirestore.instance
                  .collection("WithdrawRequests")
                  .doc(withdrawRequestList[index].withdrawId).delete()
                  .then((value) async{
                        await FirebaseFirestore.instance
                            .collection("Users")
                            .doc(withdrawRequestList[index].id).collection('WithdrawHistory').doc(withdrawRequestList[index].withdrawId).delete()
                            .then((value) => getWithdrawRequest());
               notifyListeners();
        });
          });



      notifyListeners();
      return true;
    } catch (err) {
      print(err);
      // showToast(err.toString());
      return false;
    }
  }


  Future<bool> addDepositRequestAmount(Map<String, dynamic> map,int index) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(depositRequestList[index].userId)
          .update(map);


      notifyListeners();
      return true;
    } catch (err) {
      print(err);
      showToast(err.toString());
      return false;
    }
  }

  Future<bool> updateDepositStatus(Map<String, dynamic> map,int index) async {


    try {
      await FirebaseFirestore.instance
          .collection("DepositRequests")
          .doc(depositRequestList[index].depositId)
          .update(map).then((value) async{

        await FirebaseFirestore.instance
                .collection("Users")
                .doc(depositRequestList[index].userId).collection('DepositHistory').doc(depositRequestList[index].depositId)
                .update(map).then((value) => getDepositRequest());
            notifyListeners();


      });
      notifyListeners();
      return true;
    } catch (err) {
      print(err);
      showToast(err.toString());
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

  Future<void> deleteProductOrder(
      FirebaseProvider firebaseProvider, int? index) async {
    await  FirebaseFirestore.instance
        .collection("Orders")
        .doc(productOrderList[index].id).delete().then((value) => getProductOrder());

  }

  Future<bool> updateProductData(Map<String, dynamic> map) async {
    try {
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(productList[productIndex].id)
          .update(map);
      notifyListeners();


      return true;
    } catch (error) {
      showToast(error.toString());
      return false;
    }
  }
  Future<bool> updatePackageData(Map<String, dynamic> map) async {
    try {
      await FirebaseFirestore.instance
          .collection('Packages')
          .doc(packageList[packageIndex].id)
          .update(map);
      notifyListeners();


      return true;
    } catch (error) {
      showToast(error.toString());
      return false;
    }
  }

  Future<void> batchUpdateCategory(Map<String, String> map,
      String oldSubtext, String newSubText) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    // print('Batch Category: $collectionName');
    print('Batch Old Text : $oldSubtext');
    print('Batch New Text : $newSubText');
    // print('Batch New Text : $newSubText');
    print('Batch Map : $map');
    try {
      print('Updating...');
        await FirebaseFirestore.instance
            .collection('Products')
            .where('category', isEqualTo: oldSubtext)
            .get()
            .then((snapshot) {
          snapshot.docChanges.forEach((element) {
            batch.update(
                FirebaseFirestore.instance
                    .collection('Products')
                    .doc(element.doc.id),
                {'category': newSubText});
          });
          return batch.commit();
        }).then((value) async {
          try {
            await FirebaseFirestore.instance
                .collection('Category')
                .doc(map['id'])
                .update(map);
            notifyListeners();
            return true;
          } catch (error) {
            // showToast(error.toString());
            return false;
          }
        });

      print('Update Success');
      }catch (error) {
      print((error.toString()));
    }

    notifyListeners();
  }

  Future<void> batchDeleteCategory(String id,
      String oldSubtext) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    // print('Batch Category: $collectionName');
    // print('Batch Old Text : $oldSubtext');
    // print('Batch New Text : $newSubText');
    // print('Batch New Text : $newSubText');
   // print('Batch Map : $map');
    try {
      print('Updating...');
      await FirebaseFirestore.instance
          .collection('Products')
          .where('category', isEqualTo: oldSubtext)
          .get()
          .then((snapshot) {
        snapshot.docChanges.forEach((element) {
          batch.delete(
              FirebaseFirestore.instance
                  .collection('Products')
                  .doc(element.doc.id),
             );
        });
        notifyListeners();
        return batch.commit();
      }).then((value) async {
        print('Batch Old Text : $oldSubtext');
        WriteBatch batch = FirebaseFirestore.instance.batch();
        try{
          await FirebaseFirestore.instance
              .collection('SubCategory')
              .where('category', isEqualTo: oldSubtext)
              .get()
              .then((snapshot) {
            snapshot.docChanges.forEach((element) {
              batch.delete(
                FirebaseFirestore.instance
                    .collection('SubCategory')
                    .doc(element.doc.id),
              );
            });
            notifyListeners();
            return batch.commit();
          });
        }catch (error) {
           showToast(error.toString());
           print(error.toString());
          return false;
        }
      }).then((value) async{
        try {
          await FirebaseFirestore.instance
              .collection('Category')
              .doc(id)
              .delete().then((value) =>   getCategory());

          notifyListeners();
          return true;
        } catch (error) {
           showToast(error.toString());
          return false;
        }
      });

      print('Update Success');
    }catch (error) {
      print((error.toString()));
    }

    notifyListeners();
  }

  Future<void> batchUpdateSubcategory(Map<String, String> map,
      String oldSubtext, String newSubText) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    // print('Batch Category: $collectionName');
    print('Batch Old Text : $oldSubtext');
    print('Batch New Text : $newSubText');
    // print('Batch New Text : $newSubText');
    print('Batch Map : $map');
    try {
      print('Updating...');
      await FirebaseFirestore.instance
          .collection('Products')
          .where('subCategory', isEqualTo: oldSubtext)
          .get()
          .then((snapshot) {
        snapshot.docChanges.forEach((element) {
          batch.update(
              FirebaseFirestore.instance
                  .collection('Products')
                  .doc(element.doc.id),
              {'subCategory': newSubText});
        });
        return batch.commit();
      }).then((value) async {
        try {
          await FirebaseFirestore.instance
              .collection('SubCategory')
              .doc(map['id'])
              .update(map);
          notifyListeners();
          return true;
        } catch (error) {
          // showToast(error.toString());
          return false;
        }
      });

      print('Update Success');
    }catch (error) {
      print((error.toString()));
    }

    notifyListeners();
  }
  Future<void> batchDeleteSubcategory(String id,
      String oldSubtext) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    // print('Batch Category: $collectionName');
    // print('Batch Old Text : $oldSubtext');
    // print('Batch New Text : $newSubText');
    // print('Batch New Text : $newSubText');
    // print('Batch Map : $map');
    try {
      print('Updating...');
      await FirebaseFirestore.instance
          .collection('Products')
          .where('subCategory', isEqualTo: oldSubtext)
          .get()
          .then((snapshot) {
        snapshot.docChanges.forEach((element) {
          batch.delete(
            FirebaseFirestore.instance
                .collection('Products')
                .doc(element.doc.id),
          );
        });
        notifyListeners();
        return batch.commit();
      }).then((value) async{
        try {
          await FirebaseFirestore.instance
              .collection('SubCategory')
              .doc(id)
              .delete().then((value) =>   getSubCategory());

          notifyListeners();
          return true;
        } catch (error) {
          showToast(error.toString());
          return false;
        }
      });

      print('Update Success');
    }catch (error) {
      print((error.toString()));
    }

    notifyListeners();
  }
}
