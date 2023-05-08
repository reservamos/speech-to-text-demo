import 'dart:developer';

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
      body: Center(
          child: RecordButton(
        isRecording: isRecording,
        isLoading: isLoading,
        onPressed: onPressed,
      )),
    );
  }
}