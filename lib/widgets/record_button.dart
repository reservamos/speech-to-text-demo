import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({
    Key? key,
    required this.onRecord,
    required this.onStop,
  }) : super(key: key);

  final Function()? onRecord;
  final Function()? onStop;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      endRadius: 60,
      glowColor: Colors.red[600]!,
      showTwoGlows: true,
      animate: isRecording,
      child: GestureDetector(
        onTap: () {
          isRecording ? widget.onStop!() : widget.onRecord!();
          setState(() => isRecording = !isRecording);
        },
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
    );
  }
}
