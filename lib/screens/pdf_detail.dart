import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

import 'package:ielts/widgets/adsHelper.dart';

class PDFViewerScreen extends StatefulWidget {
  final String pdfUrl;
  const PDFViewerScreen({super.key, required this.pdfUrl});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  PDFDocument? document;

  void initialisePdf() async {
    document = await PDFDocument.fromURL(widget.pdfUrl);

    setState(() {});
  }

  final _adController = NativeAdController();

  @override
  void initState() {
    super.initState();
    initialisePdf();
  }

  @override
  Widget build(BuildContext context) {
    _adController.ad = AdHelper.loadNativeAd(adController: _adController);

    return Scaffold(
      // bottomNavigationBar:
      //     _adController.ad != null && _adController.adLoaded.isTrue
      //         ? SizedBox(
      //             height: 110,
      //             child: AdWidget(
      //                 ad: _adController.ad!), // Create and load a new ad object
      //           )
      //         : null,
      body: document != null
          ? PDFViewer(
              document: document!,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
