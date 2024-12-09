import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class CustomButton extends StatelessWidget {
  String title;
  Color backgroundColor;
  Color foregroundColor;
  VoidCallback callback;
  bool isLoading = false;

  CustomButton(
      {required this.title,
      required this.backgroundColor,
      required this.foregroundColor,
      required this.callback,
      isLoading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          height: 50,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: isLoading
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  title,
                  style: TextStyle(color: foregroundColor, fontSize: 24,fontWeight: FontWeight.w500),
                ),
        ),
      ),
    );
  }
}


Future<bool> downloadFileAtAnyLocation(
    String fileUrl, String filePathName, String fileType) async {
  final String fileName = fileUrl.split('/').last;
  String timeString = DateFormat('dd-MM-yyy HH:mm:ss').format(DateTime.now());
  try {
    // Download image
    final http.Response response = await http.get(Uri.parse(fileUrl));
    // Get temporary directory
    final dir = await getTemporaryDirectory();
    // Create an image name
    var filename = '${dir.path}/${fileType} ${timeString} ${fileName}';
    log("filenamefilename :: ${filename}");
    // Save to filesystem
    final file = File(filename);
    await file.writeAsBytes(response.bodyBytes);
    // Ask the user to save it
    final params = SaveFileDialogParams(sourceFilePath: file.path);
    final finalPath = await FlutterFileDialog.saveFile(params: params);
    log("finalPathfinalPath :: ${finalPath}");
    if (finalPath != null) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    log("eeeeeeeeeeeeeeee :: ${e}");
    return false;
  }
}



/*

hello friend,
myself nikunj asodariya from trueline institute,
ame college vidharthio ne IT course mate training provide karia chia jeva ke flutter development , full stack development , digital marketing , graphic and video editing jeva trending course students ne offer karia chia. so jo tame ava tech candidate ne find karta hov to tame directly amaro contact kari shko cho.

amari main prirority tamne sara ma sara candidate mali rahe te hashe.

 */











