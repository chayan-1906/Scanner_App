import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'custom_image_picker.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String selectedFeature = '';
  File? pickedImage;
  var imageFile;
  bool isImageLoaded = false;
  var result = '';
  List<CustomImagePicker> imagePickers = [
    // camera
    const CustomImagePicker(
      name: 'Camera',
      icon: Icon(
        MaterialCommunityIcons.camera,
        color: Color(0xFF192A56),
      ),
    ),
    // gallery
    const CustomImagePicker(
      name: 'Gallery',
      icon: Icon(
        MaterialIcons.image,
        color: Color(0xFF192A56),
      ),
    ),
  ];

  void detectMLFeature(String selectedFeature) {
    switch (selectedFeature) {
      case 'Text Scanner':
        readTextImage();
        break;
      case 'Barcode Scanner':
        decodeBarCode();
        break;
      case 'Label Scanner':
        labelsRead();
        break;
    }
  }

  pickImageCamera() async {
    var tempStore = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      pickedImage = File(tempStore!.path);
      isImageLoaded = true;
      imageFile = imageFile;
    });
    detectMLFeature(selectedFeature);
  }

  pickImageGallery() async {
    var tempStore = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      pickedImage = File(tempStore!.path);
      isImageLoaded = true;
      imageFile = imageFile;
    });
    detectMLFeature(selectedFeature);
  }

  Future<void> readTextImage() async {
    result = '';
    FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(firebaseVisionImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          print(word.text);
          setState(() {
            result = result + ' ' + word.text;
          });
        }
      }
    }
  }

  Future<void> decodeBarCode() async {
    result = '';
    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(pickedImage);
    BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
    List barCodes = await barcodeDetector.detectInImage(myImage);
    for (Barcode readableCode in barCodes) {
      setState(() {
        result = readableCode.displayValue;
      });
    }
    print(result);
  }

  Future<void> labelsRead() async {
    result = '';
    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(pickedImage);
    ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
    List labels = await labeler.processImage(myImage);
    for (ImageLabel label in labels) {
      final String text = label.text;
      final double confidence = label.confidence;
      setState(() {
        result = result + ' ' + '$text     $confidence' + '\n';
      });
    }
    print(result);
  }

  Widget getWidget() {
    if (selectedFeature == 'Text Scanner') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            'Pick an image containing some texts',
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(
              'Lora',
              fontSize: 90.0,
              fontWeight: FontWeight.w700,
              color: Colors.redAccent,
            ),
          ),
        ),
      );
    } else if (selectedFeature == 'Barcode Scanner') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            'Pick a barcode',
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(
              'Lora',
              fontSize: 90.0,
              fontWeight: FontWeight.w700,
              color: Colors.redAccent,
            ),
          ),
        ),
      );
    } else if (selectedFeature == 'Label Scanner') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            'Pick an image',
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(
              'Lora',
              fontSize: 90.0,
              fontWeight: FontWeight.w700,
              color: Colors.redAccent,
            ),
          ),
        ),
      );
    } else if (selectedFeature == 'Face Detection') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            'Take a selfie',
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(
              'Lora',
              fontSize: 90.0,
              fontWeight: FontWeight.w700,
              color: Colors.redAccent,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    selectedFeature = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedFeature,
          style: GoogleFonts.getFont(
            'Lora',
            fontSize: 22.0,
            fontWeight: FontWeight.w600,
            color: Colors.lightBlueAccent,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton(
              onChanged: (CustomImagePicker? customImagePicker) {
                setState(() {
                  customImagePicker;
                });
                print('${customImagePicker!.name} clicked');
                if (customImagePicker.name == 'Camera') {
                  pickImageCamera();
                } else if (customImagePicker.name == 'Gallery') {
                  pickImageGallery();
                }
              },
              underline: const SizedBox(),
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ),
              items: imagePickers.map((CustomImagePicker? customImagePicker) {
                return DropdownMenuItem(
                  value: customImagePicker,
                  child: Row(
                    children: [
                      customImagePicker!.icon,
                      const SizedBox(width: 10.0),
                      Text(
                        customImagePicker.name,
                        style: GoogleFonts.getFont(
                          'Lora',
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF192A56),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100.0),
            isImageLoaded
                ? Center(
                    child: Container(
                      height: 250.0,
                      width: 250.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(pickedImage!),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  )
                : Container(
                    child: getWidget(),
                  ),
            const SizedBox(height: 30.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                result,
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  'Lora',
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.lightBlueAccent,
                ),
              ),
            ),
            selectedFeature == 'Barcode Scanner' && result.isNotEmpty
                ? ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.grey.shade200),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: result),
                      );
                      Fluttertoast.showToast(
                        msg: "Copied to Clipboard",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    },
                    child: Text(
                      'Copy Text',
                      style: GoogleFonts.getFont(
                        'Lora',
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).canPop() ? Navigator.of(context).pop() : null;
        },
        child: const Icon(Icons.check_rounded),
      ),
    );
  }
}
