import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:sttdemo/controllers/home_controller.dart';
import 'package:sttdemo/widgets/record_button.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RecordButton(
              onRecord: () => controller.startRecord(),
              onStop: () => controller.stopRecord(),
            ),
            StreamBuilder<bool>(
              stream: controller.isLoading,
              initialData: false,
              builder: (context, snapshot) => Visibility(
                visible: snapshot.data!,
                replacement: const SizedBox(height: 2),
                child: SizedBox(
                  height: 2,
                  width: 200,
                  child: LinearProgressIndicator(
                    color: Colors.blue[600],
                  ),
                ),
              ),
            ),
            StreamBuilder<String>(
                stream: controller.transcription,
                initialData: '',
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      snapshot.data!,
                      style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
