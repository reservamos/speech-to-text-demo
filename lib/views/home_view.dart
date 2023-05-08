import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:sttdemo/controllers/home_controller.dart';
import 'package:sttdemo/widgets/record_button.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key) {
    controller = HomeController();
  }

  late final HomeController controller;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isRecording = false;
  bool isLoading = false;

  @override
  void initState() {
    widget.controller.isLoading.stream.listen(onLoading);
    super.initState();
  }

  void onLoading(value) {
    setState(() => isLoading = value);
  }

  void onPressed() {
    if (!isRecording) {
      setState(() => isRecording = true);
      widget.controller.startRecord();
      return;
    }

    setState(() => isRecording = false);
    widget.controller.stopRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: RecordButton(
              isRecording: isRecording,
              isLoading: isLoading,
              onPressed: onPressed,
            ),
          ),
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: SizedBox(
              width: 250.0,
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 20.0, color: Colors.grey[600]),
                child: StreamBuilder<String>(
                    stream: widget.controller.transcription.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return AnimatedTextKit(
                          repeatForever: false,
                          totalRepeatCount: 1,
                          animatedTexts: [
                            TyperAnimatedText(snapshot.data!),
                          ],
                        );
                      }
                      return Container();
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
