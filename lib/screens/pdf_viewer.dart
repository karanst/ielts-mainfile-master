import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:ielts/screens/pdf_detail.dart';
import 'package:ielts/screens/premium_screen.dart';

import 'onboarding/thumbnail.dart';

class PDF extends StatefulWidget {
  @override
  State<PDF> createState() => _PDFState();
}

class _PDFState extends State<PDF> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool premium_user_google_play = false; // Assume premium user status
  List<Map<String, dynamic>> pdfData = [];
  List pdfUrls = [];
  // late List<PdfThumbnailInfo> _pdfThumbnailInfos;
  @override
  void initState() {
    super.initState();
    getAllpdf();
  }

  List<Map<String, String>> pdfList = [];

  void getAllpdf() async {
    final snapshot = await FirebaseFirestore.instance.collection('pdfs').get();

    snapshot.docs.forEach((document) {
      String name = document.data()['name'];
      String url = document.data()['url'];
      pdfList.add({'name': name, 'url': url});
    });
    setState(() {});

    print('Data: $pdfList');
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

  Widget _buildPdfTile(index) {
    return GestureDetector(
      onTap: () {
        // Handle tile tap
      },
      child: Card(elevation: 2.0, child: Text('pdf ${index + 1}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('PDF Books'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 15.0,
              childAspectRatio: 0.8),
          itemCount: pdfList.length,
          itemBuilder: (context, index) {
            final item = pdfList[index];
            return InkWell(
                onTap: () {
                  if (!premium_user_google_play) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PDFViewerScreen(
                          pdfUrl: pdfList[index]['url'].toString(),
                        ),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Upgrade to Premium"),
                          content: Text(
                              "Upgrade to premium to read all the books at very low price in PDF form."),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.red,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PDFViewerScreen(
                                      pdfUrl: pdfList[index]['url'].toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                "Upgrade",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.green,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Thumbnail(
                  pdfUrl: item['url']!,
                  pdfName: item['name']!,
                ));
          },
        ),
      ),
    );
  }
}
