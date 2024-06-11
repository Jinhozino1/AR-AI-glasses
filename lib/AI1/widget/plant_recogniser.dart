// Copyright (c) 2022 Kodeco LLC

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
// distribute, sublicense, create a derivative work, and/or sell copies of the
// Software in any work that is designed, intended, or marketed for pedagogical
// or instructional purposes related to programming, coding,
// application development, or information technology.  Permission for such use,
// copying, modification, merger, publication, distribution, sublicensing,
// creation of derivative works, or sale is expressly withheld.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:untitled/effect/ar_effect1.dart';
import 'package:untitled/effect/ar_effect2.dart';
import 'package:untitled/effect/ar_effect3.dart';
import 'package:untitled/effect/ar_effect4.dart';
import 'package:untitled/faceType/face_0.dart';
import 'package:untitled/faceType/face_1.dart';
import 'package:untitled/faceType/face_2.dart';
import 'package:untitled/faceType/face_3.dart';
import '../classifier/classifier.dart';
import '../styles.dart';
import 'plant_photo_view.dart';

import 'package:untitled/models/model_item_provider.dart';
import 'package:provider/provider.dart';

const _labelsFileName = 'assets/labels.txt';
const _modelFileName = 'model_unquant.tflite';

class PlantRecogniser extends StatefulWidget {
  const PlantRecogniser({super.key});

  @override
  State<PlantRecogniser> createState() => _PlantRecogniserState();
}

enum _ResultStatus {
  notStarted,
  notFound,
  found,
}

class _PlantRecogniserState extends State<PlantRecogniser> {
  bool _isAnalyzing = false;
  final picker = ImagePicker();
  File? _selectedImageFile;

  // Result
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  String _plantLabel = ''; // Name of Error Message
  double _accuracy = 0.0;

  late Classifier? _classifier;

  @override
  void initState() {
    super.initState();
    _loadClassifier();
  }

  Future<void> _loadClassifier() async {
    debugPrint(
      'Start loading of Classifier with '
      'labels at $_labelsFileName, '
      'model at $_modelFileName',
    );

    final classifier = await Classifier.loadWith(
      labelsFileName: _labelsFileName,
      modelFileName: _modelFileName,
    );
    _classifier = classifier;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBgColor,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            //child: _buildTitle(),
          ),
          const SizedBox(height: 20),
          _buildPhotolView(),
          const SizedBox(height: 10),
          _buildResultView(),
          const Spacer(flex: 5),
          _buildPickPhotoButton(
            title: '사진찍기',
            source: ImageSource.camera,
          ),
          _buildPickPhotoButton(
            title: '사진 가져오기',
            source: ImageSource.gallery,
          ),
          /*
          TextButton(
            onPressed: () {Navigator.pop(context);},
            child: Text('뒤로가기'),
          ),
          */
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildPhotolView() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        PlantPhotoView(file: _selectedImageFile),
        _buildAnalyzingText(),
      ],
    );
  }

  Widget _buildAnalyzingText() {
    if (!_isAnalyzing) {
      return const SizedBox.shrink();
    }
    return const Text('Analyzing...', style: kAnalyzingTextStyle);
  }
/*
  Widget _buildTitle() {
    return const Text(
      'Plant Recogniser',
      style: kTitleTextStyle,
      textAlign: TextAlign.center,
    );
  }
*/
  Widget _buildPickPhotoButton({
    required ImageSource source,
    required String title,
  }) {
    return TextButton(
      onPressed: () => _onPickPhoto(source),
      child: Container(
        width: 300,
        height: 50,
        color: kColorBrown,
        child: Center(
            child: Text(title,
                style: const TextStyle(
                  fontFamily: kButtonFont,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: kColorLightYellow,
                ))),
      ),
    );
  }

  void _setAnalyzing(bool flag) {
    setState(() {
      _isAnalyzing = flag;
    });
  }

  void _onPickPhoto(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) {
      return;
    }

    final imageFile = File(pickedFile.path);
    setState(() {
      _selectedImageFile = imageFile;
    });

    _analyzeImage(imageFile);
  }

  void _analyzeImage(File image) {
    _setAnalyzing(true);

    final imageInput = img.decodeImage(image.readAsBytesSync())!;

    final resultCategory = _classifier!.predict(imageInput);

    final result = resultCategory.score >= 0.6
        ? _ResultStatus.found
        : _ResultStatus.notFound;
    final plantLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    _setAnalyzing(false);

    setState(() {
      _resultStatus = result;
      _plantLabel = plantLabel;
      _accuracy = accuracy;
    });
  }

  Widget _buildResultView() {
    var title = '';
    final itemProvider = Provider.of<ItemProvider>(context);

    if (_resultStatus == _ResultStatus.notFound) {
      title = '다시 시도하세요.';
    } else if (_resultStatus == _ResultStatus.found) {
      title = _plantLabel;
    } else {
      title = '';
    }
  Widget _recommendScreen() {
    if (_resultStatus == _ResultStatus.found) {
      if(_plantLabel == '각진형 얼굴') {
        return Container(
          width: 300,
          height: 270,
          color: Colors.white,
          child: GestureDetector(
            onTap:() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => face0()),);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzSsFsLXmvt3ZvhohqabfmSjFArGa5s6AEJg&usqp=CAU',
                    width: 150,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Text('pinhole glasses',
                    style: TextStyle(fontSize: 13,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.w400),
                  ),
                  Text('100,000원',
                    style: TextStyle(fontSize: 14,
                        color: Colors.red,
                        decoration: TextDecoration.none,
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.white,
                    width: 80,
                    height: 80,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzSsFsLXmvt3ZvhohqabfmSjFArGa5s6AEJg&usqp=CAU'),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: GestureDetector(
                          //borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AREffect1()),);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      else if(_plantLabel == '긴형 얼굴') {
        return Container(
          width: 300,
          height: 270,
            color: Colors.white,
            child: GestureDetector(
              onTap:() {
                Navigator.push(context, MaterialPageRoute(builder: (context) => face1()),);
              },
                child: Container(
            padding: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8h5sXeN1deBxB3a7EFoGvQuRimnMVx-kBzA&usqp=CAU',
                width: 150,
                height: 120,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 0,
              ),
              Text('sunglasses',
                style: TextStyle(fontSize: 13,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontFamily: 'NanumGothic',
                    fontWeight: FontWeight.w400),
              ),
              Text('200,000원',
                style: TextStyle(fontSize: 14,
                    color: Colors.red,
                    decoration: TextDecoration.none,
                    fontFamily: 'NanumGothic',
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                width: 80,
                height: 80,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8h5sXeN1deBxB3a7EFoGvQuRimnMVx-kBzA&usqp=CAU'),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: GestureDetector(
                        //borderRadius: BorderRadius.circular(100),
                        onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AREffect2()),);
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
            ),
        );
      }
      else if(_plantLabel == '계란형 얼굴') {
        return Container(
          width: 300,
          height: 270,
          color: Colors.white,
          child: GestureDetector(
            onTap:() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => face2()),);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network('https://www.sophiemoda.co.za/cdn/shop/products/K5B4368_1296x.jpg?v=1633417897',
                    width: 150,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Text('glasses',
                    style: TextStyle(fontSize: 13,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.w400),
                  ),
                  Text('300,000원',
                    style: TextStyle(fontSize: 14,
                        color: Colors.red,
                        decoration: TextDecoration.none,
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.white,
                    width: 80,
                    height: 80,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage('https://www.sophiemoda.co.za/cdn/shop/products/K5B4368_1296x.jpg?v=1633417897'),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: GestureDetector(
                          //borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AREffect3()),);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      else if(_plantLabel == '둥근형 얼굴') {
        return Container(
          width: 300,
          height: 270,
          color: Colors.white,
          child: GestureDetector(
            onTap:() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => face3()),);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR03yoUrHB5se9vFr1vkfYX5ktGaf4_Gq91bVizU5xo7Kfs3klzXB8Ckf6YmKmSj85b97g&usqp=CAU',
                    width: 150,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Text('red sunglasses',
                    style: TextStyle(fontSize: 13,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.w400),
                  ),
                  Text('400,000원',
                    style: TextStyle(fontSize: 14,
                        color: Colors.red,
                        decoration: TextDecoration.none,
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.white,
                    width: 80,
                    height: 80,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR03yoUrHB5se9vFr1vkfYX5ktGaf4_Gq91bVizU5xo7Kfs3klzXB8Ckf6YmKmSj85b97g&usqp=CAU'),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: GestureDetector(
                          //borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AREffect4()),);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      else return Container();
    }
    else return Container();
  }
    //
    var accuracyLabel = '';
    if (_resultStatus == _ResultStatus.found) {
      accuracyLabel = '정확도: ${(_accuracy * 100).toStringAsFixed(2)}%';
    }
    var recommend = '';
    if (_resultStatus == _ResultStatus.found) {
      recommend = '이런 상품은 어떠세요?';
    }

    return Column(
      children: [
        Text(title, style: kResultTextStyle),
        const SizedBox(height: 10),
        Text(accuracyLabel, style: kResultRatingTextStyle),
        _recommendScreen(),
        Text(recommend, style: kResultRatingTextStyle,),
      ],
    );
  }
}
