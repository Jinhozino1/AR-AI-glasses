// import 'dart:io';
//
// import 'package:camera_deep_ar/camera_deep_ar.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
//
// import 'package:untitled/models/model_item_provider.dart';
// //import 'package:untitled/models/model_item.dart';
// import 'package:provider/provider.dart';
//
// DeepArConfig config = DeepArConfig(
//   androidKey:
//   "54d22e348b78fcafdfd411de889fdf9435db47ac4550a187cc0b6d45489f2e7c85cd3ea98f3ca78d",
//   ioskey:
//   "3854351d472c9794f911815bd60ba909c6f60d7729d6baae005f067e6e5abef9db5948347c11ed56",
//   displayMode: DisplayMode.camera,
// // displayMode: DisplayMode.camera,
// );
//
// class AREffect2_1 extends StatefulWidget {
//   @override
//   _AREffect2_1State createState() => _AREffect2_1State();
// }
//
// class _AREffect2_1State extends State<AREffect2_1> {
//   // CameraDeepArControllerX cameraDeepArController;
//   // Effects currentEffect = Effects.none;
//   // Filters currentFilter = Filters.none;
//   // Masks currentMask = Masks.empty;
//
//
//   final deepArController = CameraDeepArController(config);
//
//   bool isRecording = false;
//   CameraMode cameraMode = config.cameraMode;
//   DisplayMode displayMode = config.displayMode;
//   int currentEffect = 0;
//
//   List get effectList {
//     switch (cameraMode) {
//       case CameraMode.mask:
//         return masks;
//       default:
//         return masks;
//     }
//   }
//
//   List masks = [
//     "assets/ar/sunglasses2.deepar",
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     CameraDeepArController.checkPermissions();
//     deepArController.setEventHandler(DeepArEventHandler(
//         onCameraReady: (v) {
//           setState(() {});
//         }, onSnapPhotoCompleted: (v) {
//       setState(() {});
//     }, onVideoRecordingComplete: (v) {
//       setState(() {});
//     }, onSwitchEffect: (v) {
//       setState(() {});
//     }));
//   }
//
//   @override
//   void dispose() {
//     deepArController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int photoMode = 0;
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.black,
//         body: Stack(
//
//           children: [
//             DeepArPreview(deepArController),
//             Container(
//               //margin: EdgeInsets.only(left: 30),
//               child: Row(
//                 children: [
//                   SizedBox(
//                     height: 150,
//                   ),
//                   InkWell(
//                     borderRadius: BorderRadius.circular(100),
//                     onTap: () {
//                       deepArController.stopVideoRecording();
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       child: Icon(
//                         Icons.chevron_left_rounded,
//                         color: Colors.white,
//                         size: 60,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//
//                 padding: EdgeInsets.all(20),
//                 //height: 250,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     //       Text("ar",style: TextStyle(color: Colors.white),),
//                     SizedBox(
//                       //height: 20,
//                     ),
//                     Container(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               child: InkWell(
//                                 child: SizedBox(
//                                   width: 80,
//                                   height: 30,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment
//                                         .center,
//                                     children: [
//                                       Text("AR",
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontFamily: 'NanumGothic',
//                                             fontWeight: FontWeight.w400
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 onTap: () {
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                             ),
//                           ),
//
//                           Expanded(
//                             child: Container(
//                               child: InkWell(
//                                 child: SizedBox(
//                                   width: 80,
//                                   height: 30,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment
//                                         .center,
//                                     children: [
//                                       Text("Photo",
//                                         style: TextStyle(
//                                             color: Colors.orangeAccent,
//                                             fontFamily: 'NanumGothic',
//                                             fontWeight: FontWeight.w600
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 onTap: () {},
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     SingleChildScrollView(
//                       padding: EdgeInsets.all(15),
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: List.generate(effectList.length, (p) {
//                           bool active = currentEffect == p;
//                           String imgPath = effectList[p];
//                           return Container(
//                             margin: EdgeInsets.all(6),
//                             width: active ? 70 : 55,
//                             height: active ? 70 : 55,
//                             alignment: Alignment.center,
//
//                             decoration: BoxDecoration(
//                               color: Colors.transparent,
//                               borderRadius: BorderRadius.circular(50),
//                               border: Border.all(
//                                 width: 3,
//                                 color: Colors.white,
//                                 style: BorderStyle.solid,
//                               ),
//                             ),
//                             child: InkWell(
//                               borderRadius: BorderRadius.circular(100),
//                               onTap: () {
//                                 deepArController.snapPhoto();
//                               },
//                               child: Icon(
//                                 Icons.camera_alt_outlined,
//                                 color: Colors.white,
//                                 size: 40,
//                               ),
//
//
//                             ),
//                           );
//
//                         }),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }