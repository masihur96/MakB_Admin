class UserModel{
  String? id;
  String? name;
  String? address;
  String? phone;
  String? password;
  String? nbp;
  String? email;
  String? zip;
  String? referCode;
  String? timeStamp;
  String? referDate;
  String? imageUrl;
  //String? referredList;
  String? numberOfReferred;
  String? insuranceEndingDate;
  String? depositBalance;
  //String? depositHistory;
  //String? withdrawHistory;
  String? insuranceBalance;
  String? lastInsurancePaymentDate;
  String? level;
  String? mainBalance;
  String? videoWatched;
  String? watchDate;
  String? myStore;
  String? myOrder;
  //String? cartList;
  String? referLimit;

  UserModel({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.password,
    this.nbp,
    this.email,
    this.zip,
    this.referCode,
    this.timeStamp,
    this.referDate,
    this.imageUrl,
    //this.referredList,
    this.numberOfReferred,
    this.insuranceEndingDate,
    this.depositBalance,
    //this.depositHistory,
    //this.withdrawHistory,
    this.insuranceBalance,
    this.lastInsurancePaymentDate,
    this.level,
    this.mainBalance,
    this.videoWatched,
    this.watchDate,
    this.myStore,
    this.myOrder,
    //this.cartList,
    this.referLimit
  });
}