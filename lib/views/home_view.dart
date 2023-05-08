import 'dart:developer';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:sttdemo/controllers/home_controller.dart';
import 'package:sttdemo/widgets/record_button.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: DecoratedBox(
                decoration: BoxDecoration(
                    gradient: RadialGradient(
                        radius: 0.6,
                        colors: [Colors.blue[600]!, Colors.black])))),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '¿Dinos a dónde quieres viajar?',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
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
                  builder: (context, snapshot) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      snapshot.data!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                StreamBuilder<bool>(
                  stream: controller.isValidTranscription,
                  initialData: false,
                  builder: (context, snapshot) => Visibility(
                    visible: snapshot.data!,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: MaterialButton(
                        onPressed: () {},
                        shape: const StadiumBorder(),
                        height: 50,
                        color: Colors.blue[600],
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Buscar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
