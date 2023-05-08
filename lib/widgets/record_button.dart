import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({
    Key? key,
    this.isRecording = false,
    this.onPressed,
  }) : super(key: key);

  final bool isRecording;
  final Function()? onPressed;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      endRadius: 60,
      glowColor: Colors.red[600]!,
      showTwoGlows: true,
      animate: widget.isRecording,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: CircleAvatar(
          radius: 30,
          backgroundColor:
              widget.isRecording ? Colors.red[600] : Colors.blue[600],
          child: Icon(
            widget.isRecording ? Icons.stop : Icons.mic_sharp,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
