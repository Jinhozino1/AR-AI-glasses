import 'dart:io';

import 'package:camera_deep_ar/camera_deep_ar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:untitled/models/model_item_provider.dart';
//import 'package:untitled/models/model_item.dart';
import 'package:provider/provider.dart';

DeepArConfig config = DeepArConfig(
  androidKey:
  "54d22e348b78fcafdfd411de889fdf9435db47ac4550a187cc0b6d45489f2e7c85cd3ea98f3ca78d",
  ioskey:
  "3854351d472c9794f911815bd60ba909c6f60d7729d6baae005f067e6e5abef9db5948347c11ed56",
  displayMode: DisplayMode.camera,
// displayMode: DisplayMode.camera,
);

//https://github.com/daptee/question-color-deepAr-modified.git
//https://github.com/mtellect/CameraDeepAR.git

class AREffect2 extends StatefulWidget {
  @override
  _AREffect2State createState() => _AREffect2State();
}

class _AREffect2State extends State<AREffect2> {
  // CameraDeepArControllerX cameraDeepArController;
  // Effects currentEffect = Effects.none;
  // Filters currentFilter = Filters.none;
  // Masks currentMask = Masks.empty;


  final deepArController = CameraDeepArController(config);

  bool isRecording = false;
  CameraMode cameraMode = config.cameraMode;
  DisplayMode displayMode = config.displayMode;
  int currentEffect = 0;

  List get effectList {
    switch (cameraMode) {
      case CameraMode.mask:
        return masks;
      default:
        return masks;
    }
  }

  List masks = [
    "assets/ar/sunglasses2.deepar",
  ];

  @override
  void initState() {
    super.initState();
    CameraDeepArController.checkPermissions();
    deepArController.setEventHandler(DeepArEventHandler(
        onCameraReady: (v) {
          setState(() {});
        }, onSnapPhotoCompleted: (v) {
      setState(() {});
    }, onVideoRecordingComplete: (v) {
      setState(() {});
    }, onSwitchEffect: (v) {
      setState(() {});
    }));
  }

  @override
  void dispose() {
    deepArController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(

          children: [
            DeepArPreview(deepArController),
            Container(
              //margin: EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      deepArController.stopVideoRecording();
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white,
                        size: 70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(

                padding: EdgeInsets.all(20),
                //height: 250,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    //    Text("ar1",style: TextStyle(color: Colors.white),),
                    SizedBox(
                      //height: 20,
                    ),
                    Container(
                      child: Row(
                        children: [

                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SingleChildScrollView(
                      padding: EdgeInsets.all(15),
                      scrollDirection: Axis.horizontal,
                      child: Row(

                        children: List.generate(effectList.length, (p) {
                          bool active = currentEffect == p;
                          String imgPath = effectList[p];
                          return GestureDetector(
                            onTap: () async {
                              if (!deepArController.value.isInitialized) return;
                              currentEffect = p;
                              deepArController.switchEffect(
                                  cameraMode, imgPath);
                              setState(() {});
                            },
                            child: Container(
                              margin: EdgeInsets.all(6),
                              width: active ? 70 : 55,
                              height: active ? 70 : 55,
                              alignment: Alignment.center,

                              decoration: BoxDecoration(
                                  color: active ? Colors.orange : Colors.white,
                                  border: Border.all(
                                      color:
                                      active ? Colors.orange : Colors.white,
                                      width: active ? 2 : 0),
                                  shape: BoxShape.circle),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(
                      //  height: 5,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Future<File> _loadFile(String path, String name) async {
    final ByteData data = await rootBundle.load(path);
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/$name');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    return tempFile;
  }
}