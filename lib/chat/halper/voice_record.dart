import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ielts/chat/api/apis.dart';
import 'package:ielts/chat/models/chat_user.dart';

class VoiceRecord extends StatefulWidget {
  final ChatUser user;
  // final Function(Media) recordingCallback;

  const VoiceRecord({Key? key, required this.user
    // , required this.recordingCallback
  })
      : super(key: key);

  @override
  State<VoiceRecord> createState() => _VoiceRecordState();
}

class _VoiceRecordState extends State<VoiceRecord> {
  late final RecorderController recorderController;

  bool isRecorded = false;

  String? recordingPath;

  @override
  void initState() {
    recorderController = RecorderController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startRecording();
    });
    super.initState();
  }

  startRecording() async {
    await recorderController.record();
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
              borderRadius: BorderRadius.circular(20)),
          // color: AppColorConstants.backgroundColor,
          child: AudioWaveforms(
            waveStyle: WaveStyle(
              waveColor: Colors.red
            ),
            size: const Size(double.infinity, 200.0),
            recorderController: recorderController,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap:(){
                  setState(() {
                    if (isRecorded == true) {
                      sendRecording();
                    } else {
                      stopRecording();
                      isRecorded = true;
                    }
                  });
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  // color: AppColorConstants.backgroundColor,
                  child: Center(
                    child: Icon(
                      isRecorded == true ? Icons.send : Icons.stop,
                      color: Colors.blue,
                      // color: AppColorConstants.iconColor,
                      size: 25,
                    ),
                  ),
                ),
              ),
              //     .circular.ripple(() {
              //   setState(() {
              //     if (isRecorded == true) {
              //       sendRecording();
              //     } else {
              //       stopRecording();
              //       isRecorded = true;
              //     }
              //   });
              // }),
              const SizedBox(
                width: 50,
              ),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  // color: AppColorConstants.backgroundColor,
                  child: Center(
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      // color: AppColorConstants.iconColor,
                      size: 25,
                    ),
                  ),
                ),
              )
              //     .circular.ripple(() {
              //   Get.back();
              // })
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  stopRecording() async {
    recordingPath = await recorderController.stop();
    recordingPath = recordingPath?.replaceAll('file://', '');
  }

  sendRecording() {
    File file = File(recordingPath!);
    // Uint8List data = file.readAsBytesSync();

    if (recordingPath != null) {
      APIs.sendAudioMessage(widget.user, file);
      // Media media = Media(
      //   file: File(recordingPath!),
      //   fileSize: data.length,
      //   id: randomId(),
      //   creationTime: DateTime.now(),
      //   mediaType: GalleryMediaType.audio,
      // );
      // widget.recordingCallback(media);
    }
    Navigator.pop(context);
    // Get.back();
  }
}
