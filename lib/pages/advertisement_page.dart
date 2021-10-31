import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/model/file_DataModel.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';
import 'package:makb_admin_pannel/widgets/form_decoration.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'dart:html' as html;
class Advertisement extends StatefulWidget {
  @override
  _AdvertisementState createState() => _AdvertisementState();
}

class _AdvertisementState extends State<Advertisement> {
  var titleTextController = TextEditingController();
  var rateTextController = TextEditingController();

  VideoPlayerController? _controller;
  File_Data_Model? file;


  var path;

 String url='';
 String? videoName;

  String? video_size;
 //double? e;


  // @override
  // void initState() {
  //   super.initState();
  //   _controller = VideoPlayerController.network(url
  //      )
  //     ..initialize().then((_) {
  //       // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
  //       setState(() {});
  //     });
  // }



  Uint8List? fileBytes;
  String? videoUrl;
  int counter=0;

  _customInit(FirebaseProvider firebaseProvider, String url){

    setState(() {
      counter++;
    });

    _controller = VideoPlayerController.network(url
    )
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider publicProvider = Provider.of<PublicProvider>(context);
    final FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(context);

    if(counter==0){

      _customInit(firebaseProvider,firebaseProvider.advertisementList[0].videoUrl);
    }
    return Container(
      width: publicProvider.pageWidth(size),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: publicProvider.pageWidth(size) * .5,
            child:ListView(
              children: [
                fileBytes == null?
                _controller !=null?
                Center(
                  child: Stack(
                    children: [
                      Container(
                        height: 400,
                        width: 500,
                        child: Center(
                          child: _controller!.value.isInitialized
                              ? AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          )
                              : Container(),
                        ),
                      ),

                      Positioned.fill(child: _controller !=null? Align(
                        alignment: Alignment.center,
                        child: FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              _controller!.value.isPlaying
                                  ? _controller!.pause()
                                  : _controller!.play();
                            });
                          },
                          child: Center(
                            child: Icon(
                              _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                          ),


                        ),
                      ):Container())



                    ],
                  ),
                ):Container():Container(
                  height: 400,
                  width: 500,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Container(
                          width: 300,
                          child: Text('Video Name: $videoName')),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Video Size: $video_size MB '),
                      ),
                    ],),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SizedBox(
                        height: 20,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: publicProvider.pageWidth(size) * .45,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: TextField(
                                  controller: titleTextController,
                                  decoration:
                                      textFieldFormDecoration(size)
                                          .copyWith(
                                    labelText: 'Title',
                                    hintText: 'Video Title',
                                    hintStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _isLoading? fadingCircle: TextButton(
                                  onPressed: () {

    if(firebaseProvider.advertisementList.length<5){

      setState(() {
        _isLoading=true;
      });

      final String uuid = Uuid().v1();
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('Advertisement')
          .child(uuid);
      firebase_storage.UploadTask storageUploadTask =
      storageReference.putData(fileBytes!);
      firebase_storage.TaskSnapshot taskSnapshot;
      storageUploadTask.then((value) {
        taskSnapshot = value;
        taskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl) {
          final downloadUrl = newImageDownloadUrl;
          setState(() {
            videoUrl=downloadUrl;
          });
          _submitData(firebaseProvider,uuid);
        });
      });
    }
    else {
      showToast('You Have Already Five Videos');
    }




                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          border: Border.all(
                                              width: 1, color: Colors.green)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 50.0,
                                          vertical: 5,
                                        ),
                                        child: Text(
                                          'Upload',
                                          style:
                                              TextStyle(color: Colors.white),
                                        ),
                                      ))),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
          Container(
            width: publicProvider.pageWidth(size) * .5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
              //  mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: publicProvider.pageWidth(size) * .5,
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Video List',textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20,color: Colors.white),
                          ),

                          Container(
                              child: IconButton(onPressed: () async{
                                FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);
                                if (result != null) {
                                  //   File files =  result.files as File;
                                  PlatformFile file = result.files.first;
                                  setState(() {
                                    fileBytes = result.files.first.bytes;
                                    videoName = file.name;
                                    video_size = (file.size/ (1024 * 1024)).toStringAsFixed(3);
                                  });



                                }
                              }, icon: Icon(Icons.add,color: Colors.white,))


                          ),

                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: size.height,
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: firebaseProvider.advertisementList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [

                              Divider(
                                height: 2,
                              ),
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    fileBytes = null;
                                  });

                                  _customInit(firebaseProvider,firebaseProvider.advertisementList[index].videoUrl);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.video_call_outlined,size: 40,color: Colors.green,),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(firebaseProvider.advertisementList[index].title),
                                                Text('Upload Date: ${firebaseProvider.advertisementList[index].date}'),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),



                                      IconButton(onPressed: (){

                                        showDialog(context: context, builder: (_){
                                          return   AlertDialog(
                                            title: Text('Alert'),
                                            content: Container(
                                              height: publicProvider.isWindows?size.height*.2:size.width*.2,
                                              width: publicProvider.isWindows?size.height*.4:size.width*.4,
                                              child:Column(
                                                children: [
                                                  Icon(Icons.warning_amber_outlined,color: Colors.yellow,size: 50,),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                    child: Text('Are You Confirm ?',style: TextStyle(fontSize: 20),),
                                                  ),

                                                  ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          primary: Colors.green,
                                                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                                                      ),
                                                      onPressed: (){

                                                        FirebaseFirestore.instance.collection('Advertisement').doc(firebaseProvider.advertisementList[index].id).delete().then((value)
                                                        {
                                                                              showToast('Success');
                                                                              Navigator.pop(context);
                                                                              firebaseProvider.getVideo();
                                                                            });


                                                  }, child: Text('Delete',style: TextStyle(color: Colors.white),))


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
                                            ],
                                          );
                                        }) ;




                                      }, icon: Icon(Icons.cancel_outlined))



                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitData(FirebaseProvider firebaseProvider, String uuid) async {
    DateTime date = DateTime.now();
    String dateData = '${date.month}-${date.day}-${date.year}';



      Map<String, dynamic> map = {
        'videoUrl': videoUrl,
        'id': uuid,
        'date': dateData,
        'title': titleTextController.text,

      };
      await firebaseProvider.addVideoData(map).then((value) {
        if (value) {
          setState(() {
            _isLoading = false;
          });
          showToast('Success');
          _emptyFiledCreator();
          firebaseProvider.getVideo();


        } else {
          setState(() => _isLoading = false);
          showToast('Failed');
        }
      });


   // setState(() => _isLoading = true);


  }

  _emptyFiledCreator() {
    titleTextController.clear();
  }
}
