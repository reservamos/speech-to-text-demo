import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class RecordButton extends StatelessWidget {
  const RecordButton({
    Key? key,
    this.isRecording = false,
    this.isLoading = false,
    this.onPressed,
  }) : super(key: key);

  final bool isRecording;
  final bool isLoading;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      endRadius: 60,
      glowColor: Colors.red[600]!,
      showTwoGlows: true,
      animate: isRecording,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: onPressed,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: isRecording ? Colors.red[600] : Colors.blue[600],
              child: Icon(
                isRecording ? Icons.stop : Icons.mic_sharp,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: Transform.scale(
              scale: 1.75,
              child: CircularProgressIndicator(
                color: Colors.blue[600],
              ),
            ),
          )
        ],
      ),
    );
  }
}
