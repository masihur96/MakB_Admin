import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/data_model/dart/package_model.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';

class AllPackagePage extends StatefulWidget {
  @override
  _AllPackagePageState createState() => _AllPackagePageState();
}

class _AllPackagePageState extends State<AllPackagePage> {
  var searchTextController = TextEditingController(); // Package Search Controller
  List selectedPackage = []; //List of selected package index
  List selectedPackageID = []; //List of selected package id

   List<String> imgList = [];

  int counter = 0;
  List<PackageModel> _subList = [];

  List<PackageModel> _filteredList = [];

 bool _isLoading = false;

  _customInit(FirebaseProvider firebaseProvider) async {
    setState(() {
      counter++;
    });
    setState(() {
      _isLoading = true;
    });
    if(firebaseProvider.packageList.isEmpty){
      await firebaseProvider.getPackage().then((value) {
        setState(() {
          _subList = firebaseProvider.packageList;
          _filteredList = _subList;
          _isLoading = false;
        });
      });
    }else{
      setState(() {
        _subList = firebaseProvider.packageList;
        _filteredList = _subList;
        _isLoading = false;
      });
    }
  }

  _filterList(String searchItem) {
    setState(() {
      _filteredList = _subList
          .where((element) =>
              (element.title!.toLowerCase().contains(searchItem.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);

    if (counter == 0) {
      _customInit(firebaseProvider);
    }
    return Container(
      width: publicProvider.pageWidth(size),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 50,
              child: TextField(
                controller: searchTextController,
                decoration: textFieldFormDecoration(size).copyWith(
                  hintText: 'Search Package By Title',
                  hintStyle: TextStyle(
                    fontSize: publicProvider.isWindows
                        ? size.height * .02
                        : size.width * .02,
                  ),
                ),
                onChanged: _filterList,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text('Alert'),
                              content: Container(
                                height: publicProvider.isWindows
                                    ? size.height * .2
                                    : size.width * .2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.warning_amber_outlined,
                                      color: Colors.yellow,
                                      size: 40,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Text(
                                        'Are you confirm to delete this Product ?',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    var db = FirebaseFirestore.instance;
                                    WriteBatch batch = db.batch();
                                    for (String id in selectedPackageID) {
                                      DocumentReference ref =
                                          db.collection("Packages").doc(id);
                                      batch.delete(ref);
                                    }
                                    batch.commit().then((value) {
                                      firebaseProvider.getPackage();
                                      selectedPackage.clear();
                                      selectedPackageID.clear();
                                    });

                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.red,
                    )),
                TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () {
                    setState(() {
                      selectedPackage.clear();
                      selectedPackageID.clear();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text('Clear All Selection ',
                        style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontSize: publicProvider.isWindows
                              ? size.height * .02
                              : size.width * .02,
                        )),
                  ),
                ),

                IconButton(onPressed: (){

                  setState(() {
                    _isLoading = true;
                  });

                  firebaseProvider.getPackage().then((value) => _isLoading = false);

                }, icon: Icon(Icons.refresh_outlined,color: Colors.green,))

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#',
                  style: TextStyle(
                    fontSize: publicProvider.isWindows
                        ? size.height * .02
                        : size.width * .02,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Text(
                    'Photo',
                    style: TextStyle(
                      fontSize: publicProvider.isWindows
                          ? size.height * .02
                          : size.width * .02,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Package Title',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: publicProvider.isWindows
                          ? size.height * .02
                          : size.width * .02,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Package Price',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: publicProvider.isWindows
                          ? size.height * .02
                          : size.width * .02,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Discount',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: publicProvider.isWindows
                          ? size.height * .02
                          : size.width * .02,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Action',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: publicProvider.isWindows
                          ? size.height * .02
                          : size.width * .02,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isLoading?Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: fadingCircle,
          ):
          ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: _filteredList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                setState(() {
                                  if (selectedPackage.contains(index)) {
                                    selectedPackageID
                                        .remove(_filteredList[index].id);
                                    selectedPackage.remove(index);
                                  } else {
                                    selectedPackage.add(index);
                                    selectedPackageID
                                        .add(_filteredList[index].id);
                                  }
                                });
                              },
                              child: selectedPackage.contains(index)
                                  ? Icon(Icons.check_box_outlined)
                                  : Icon(Icons
                                      .check_box_outline_blank_outlined)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 28.0),
                            child: Container(
                                height: publicProvider.isWindows
                                    ? size.height * .04
                                    : size.width * .04,
                                width: publicProvider.isWindows
                                    ? size.height * .03
                                    : size.width * .03,
                                child: Image.network(
                                  _filteredList[index].thumbnail!,
                                  fit: BoxFit.fill,
                                )),
                          ),
                          Expanded(
                            child: Text(
                              '${_filteredList[index].title}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: publicProvider.isWindows
                                    ? size.height * .02
                                    : size.width * .02,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${_filteredList[index].price}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: publicProvider.isWindows
                                    ? size.height * .02
                                    : size.width * .02,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${_filteredList[index].discountAmount}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: publicProvider.isWindows
                                    ? size.height * .02
                                    : size.width * .02,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      firebaseProvider.packageIndex = index;
                                    });

                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter setState) {
                                            return AlertDialog(
                                              title: Text('Package Details'),
                                              content: Container(
                                                  height:
                                                      publicProvider.isWindows
                                                          ? size.height * .6
                                                          : size.width * .6,
                                                  width:
                                                      publicProvider.isWindows
                                                          ? size.height
                                                          : size.width * .8,
                                                  child: ListView(
                                                    children: [
                                                      publicProvider.isWindows
                                                          ? SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                      width: publicProvider.isWindows
                                                                          ? size.height /
                                                                              2
                                                                          : size.width *
                                                                              .8 /
                                                                              2,
                                                                      child: productImageList(
                                                                          publicProvider,
                                                                          size,
                                                                          index,
                                                                          firebaseProvider)),
                                                                  Container(
                                                                      width: publicProvider.isWindows
                                                                          ? size.height /
                                                                              2
                                                                          : size.width *
                                                                              .8 /
                                                                              2,
                                                                      child: productDetailsData(
                                                                          publicProvider,
                                                                          firebaseProvider,
                                                                          index,
                                                                          size))
                                                                ],
                                                              ),
                                                            )
                                                          : Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                    width:
                                                                        publicProvider.pageWidth(size) *
                                                                            .5,
                                                                    child: productImageList(
                                                                        publicProvider,
                                                                        size,
                                                                        index,
                                                                        firebaseProvider)),
                                                                productDetailsData(
                                                                    publicProvider,
                                                                    firebaseProvider,
                                                                    index,
                                                                    size)
                                                              ],
                                                            ),
                                                    ],
                                                  )),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                        });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.visibility,
                                      size: publicProvider.isWindows
                                          ? size.height * .02
                                          : size.width * .02,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }

  Widget productImageList(PublicProvider publicProvider, Size size, int index,
      FirebaseProvider firebaseProvider) {
    int _currentIndex = 0;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Stack(children: [
            Container(
              // width: size.height*.4,
              height:
                  publicProvider.isWindows ? size.height * .4 : size.width * .4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 1, color: Colors.grey)),
              child:  firebaseProvider
                  .packageList[index].image.isNotEmpty
                  ? Container(
                      child: Image.network(
                        firebaseProvider
                            .packageList[index].image[_currentIndex],
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
            ),
          ]),
          Container(
            height:
                publicProvider.isWindows ? size.height * .15 : size.width * .15,
            width: publicProvider.isWindows
                ? size.height / 2
                : size.width * .8 / 2,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: firebaseProvider.packageList[index].image.length == 0
                    ? 3
                    : firebaseProvider.packageList[index].image.length,
                itemBuilder: (BuildContext ctx, indx) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _currentIndex = indx;
                        });
                      },
                      child: firebaseProvider
                              .packageList[index].image.isNotEmpty
                          ? Container(
                              width: publicProvider.pageWidth(size) * .07,
                              height: publicProvider.isWindows
                                  ? size.height * .2
                                  : size.width * .2,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              alignment: Alignment.center,
                              child: Image.network(
                                firebaseProvider.packageList[index].image[indx],
                                fit: BoxFit.cover,
                              ))
                          : Container(
                              width: publicProvider.pageWidth(size) * .1,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              height: 200,
                            ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget productDetailsData(PublicProvider publicProvider,
      FirebaseProvider firebaseProvider, int index, Size size) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Package Details',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            width: publicProvider.isWindows
                ? size.height / 2
                : size.width * .8 / 2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(width: 1, color: Colors.grey)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      firebaseProvider.packageList[index].title,
                      style: TextStyle(
                        fontSize: publicProvider.isWindows
                            ? size.height * .025
                            : size.width * .025,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        'Description: ${firebaseProvider.packageList[index].description}',
                        style: TextStyle(
                          fontSize: publicProvider.isWindows
                              ? size.height * .025
                              : size.width * .025,
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        'Price: ${firebaseProvider.packageList[index].price}',
                        style: TextStyle(
                          fontSize: publicProvider.isWindows
                              ? size.height * .025
                              : size.width * .025,
                        ),
                      )),
                  firebaseProvider.packageList[index].colors.length == 0
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Container(
                            // width: size.height*.5,
                            height: 30,
                            child: Row(
                              children: [
                                Text(
                                  'Color:',
                                  style: TextStyle(
                                    fontSize: publicProvider.isWindows
                                        ? size.height * .025
                                        : size.width * .025,
                                  ),
                                ),
                                ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: firebaseProvider
                                        .packageList[index].colors.length,
                                    itemBuilder: (_, idx) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                  color: firebaseProvider
                                                              .packageList[
                                                                  index]
                                                              .colors[idx]
                                                              .length ==
                                                          0
                                                      ? Colors.white70
                                                      : Color(int.parse(
                                                          firebaseProvider
                                                              .packageList[
                                                                  index]
                                                              .colors[idx])),
                                                  shape: BoxShape.circle),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          )),
                  firebaseProvider.packageList[index].size.length == 0
                      ? SizedBox()
                      : Container(
                          // width: size.height*.5,
                          height: 20,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Size:',
                                style: TextStyle(
                                  fontSize: publicProvider.isWindows
                                      ? size.height * .025
                                      : size.width * .025,
                                ),
                              ),
                              ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: firebaseProvider
                                      .packageList[index].size.length,
                                  itemBuilder: (_, idx) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        firebaseProvider
                                            .packageList[index].size[idx],
                                        style: TextStyle(
                                          fontSize: publicProvider.isWindows
                                              ? size.height * .025
                                              : size.width * .025,
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        'Discount Amount: ${firebaseProvider.packageList[index].discountAmount}',
                        style: TextStyle(
                          fontSize: publicProvider.isWindows
                              ? size.height * .025
                              : size.width * .025,
                        ),
                      )),
                  Text(
                    'Upload Date: ${firebaseProvider.packageList[index].date}',
                    style: TextStyle(
                      fontSize: publicProvider.isWindows
                          ? size.height * .025
                          : size.width * .025,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () {
                  publicProvider.subCategory = 'Update Package';
                  publicProvider.category = '';
                  Navigator.pop(context);
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(width: 1, color: Colors.green)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50.0,
                        vertical: 5,
                      ),
                      child: Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: publicProvider.isWindows
                              ? size.height * .03
                              : size.width * .03,
                        ),
                      ),
                    ))),
          )
        ],
      ),
    );
  }
}
