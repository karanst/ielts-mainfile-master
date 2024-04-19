import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ielts/screens/onboarding/webview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';

class Thumbnail extends StatefulWidget {
  final String pdfUrl;
  final String pdfName;

  Thumbnail({required this.pdfUrl, required this.pdfName});

  @override
  _ThumbnailState createState() => _ThumbnailState();
}

class _ThumbnailState extends State<Thumbnail> {
  Map<String, PdfPageImage?> _thumbnails = {};
  Map<String, bool> _loadingStates = {};

  @override
  void initState() {
    super.initState();
    _loadThumbnail(widget.pdfUrl);
  }

  Future<void> _loadThumbnail(String pdfUrl) async {
    if (_thumbnails.containsKey(pdfUrl)) return;

    // setState(() {
    // _loadingStates[pdfUrl] = true;
    // });

    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final String pdfName = 'temp.pdf';
    final Uri uri = Uri.parse(pdfUrl);

    try {
      final http.Response response = await http.get(uri);
      final File pdfFile = File('$tempPath/$pdfName');
      await pdfFile.writeAsBytes(response.bodyBytes);

      final PdfDocument doc = await PdfDocument.openFile(pdfFile.path);
      final PdfPage page = await doc.getPage(1);
      final PdfPageImage pageImage = await page.render();
      await pageImage.createImageIfNotAvailable();

      setState(() {
        _thumbnails[pdfUrl] = pageImage;
        // _loadingStates[pdfUrl] = false;
      });
    } catch (e) {
      print('Error downloading PDF and generating thumbnail: $e');
      // setState(() {
      //   _loadingStates[pdfUrl] = false;
      // });
    }
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      List<String> words = text.split(' ');
      if (words.length <= maxLength) {
        return text;
      } else {
        return words.sublist(0, maxLength).join(' ') + '...';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final PdfPageImage? thumbnail = _thumbnails[widget.pdfUrl];
    final bool isLoading = _loadingStates[widget.pdfUrl] ?? false;

    return Card(
      color: Colors.white,
      elevation: 4.0,
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : thumbnail != null
                    ? RawImage(
                        height: 180,
                        image: thumbnail.imageIfAvailable,
                        fit: BoxFit.fitHeight,
                      )
                    : Center(child: Image.asset('assets/pdf.png')),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(
              _truncateText(widget.pdfName.toString(), 3),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
    // Scaffold(
    // body:
    // // isLoading
    // //     ? Center(child: CircularProgressIndicator())
    // //     : thumbnail != null
    // //         ?
    // GestureDetector(
    //             onTap: () {
    //               Get.to(() => PdfViewerPage(pdfUrl: widget.pdfUrl, fileName: widget.pdfName,));
    //             },
    //             child: Card(
    //               elevation: 2.0,
    //               child: SizedBox(
    //                 width: 200,
    //                 height: 200,
    //                 child: isLoading
    //                     ? Center(child: CircularProgressIndicator())
    //                     : thumbnail != null
    //                     ?
    //                 RawImage(
    //                   image: thumbnail.imageIfAvailable,
    //                   fit: BoxFit.contain,
    //                 )
    //                     : Center(child: Image.asset('assets/pdf.png')),
    //               ),
    //             ),
    //           )
    //         // : Center(child: Image.asset('assets/pdf.png')),
    // );
  }
}
