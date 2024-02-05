import 'dart:io';
import 'package:flutter/material.dart';
import 'package:explorak5/screens/constants.dart';

class FileView extends StatelessWidget {
  final file;
  final removeFile;

  FileView({this.file, this.removeFile});
  final imageExtensions = [
    "jpg",
    "jpeg",
    "png",
    "heic",
    "gif",
    "tiff",
    "tif",
    "webp"
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: PADDING_LARGE,
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: PALLETE_BLUE,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            width: MediaQuery.of(context).size.width - 50,
            child: Padding(
                padding: PADDING_SMALL,
                child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      imageExtensions.contains(file.extension)
                          ? Image.file(
                              File(file.path),
                              fit: BoxFit.fitWidth,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                  Icon(
                                    Icons.description,
                                    color: PALLETE_BLUE,
                                    size: 100,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    file.name,
                                    style: FILE_PICKER_TEXT_STYLE,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  )
                                ]),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: PALLETE_RED),
                              child: IconButton(
                                  iconSize: 40,
                                  icon: Icon(Icons.delete, color: Colors.white),
                                  onPressed: () {
                                    removeFile(file);
                                  })))
                    ]))));
  }
}
