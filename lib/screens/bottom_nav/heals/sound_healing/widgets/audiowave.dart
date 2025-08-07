// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
//
// class AudioPlayerWaveUI extends StatefulWidget {
//   const AudioPlayerWaveUI({super.key});
//
//   @override
//   State<AudioPlayerWaveUI> createState() => _AudioPlayerWaveUIState();
// }
//
// class _AudioPlayerWaveUIState extends State<AudioPlayerWaveUI> {
//   late final AudioPlayer _player;
//   bool _isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _player = AudioPlayer();
//     _loadAudio();
//   }
//
//   Future<void> _loadAudio() async {
//     await _player.setUrl(
//       'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
//     );
//   }
//
//   void _togglePlayPause() {
//     if (_isPlaying) {
//       _player.pause();
//     } else {
//       _player.play();
//     }
//
//     setState(() {
//       _isPlaying = !_isPlaying;
//     });
//   }
//
//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFDE7C2), // Soft beige
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Play button
//             GestureDetector(
//               onTap: _togglePlayPause,
//               child: Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.brown, width: 2),
//                 ),
//                 child: Icon(
//                   _isPlaying ? Icons.pause : Icons.play_arrow,
//                   color: Colors.brown,
//                   size: 30,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//
//             // Smooth waveform inside red border
//             CustomCurvedWaveform(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Smooth wave UI
// class CustomCurvedWaveform extends StatelessWidget {
//   const CustomCurvedWaveform({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: CurvedWaveformPainter(),
//       size: const Size(double.infinity, double.infinity),
//     );
//   }
// }
//
// class CurvedWaveformPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFF8B0000) // dark red
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;
//
//     final path = Path();
//     double waveHeight = size.height / 2;
//     double width = size.width;
//
//     // Start at left middle
//     path.moveTo(0, waveHeight);
//
//     // Draw curved waveform using quadraticBezierTo
//     for (double x = 0; x < width; x += 20) {
//       double controlX = x + 10;
//       double controlY = (x ~/ 20) % 2 == 0
//           ? waveHeight - 20
//           : waveHeight + 20; // wave peaks alternate
//       double endX = x + 20;
//       path.quadraticBezierTo(controlX, controlY, endX, waveHeight);
//     }
//
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWaveUI extends StatefulWidget {
  const AudioPlayerWaveUI({super.key});

  @override
  State<AudioPlayerWaveUI> createState() => _AudioPlayerWaveUIState();
}

class _AudioPlayerWaveUIState extends State<AudioPlayerWaveUI> {
  late final AudioPlayer _player;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    await _player.setUrl(
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    );
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDE7C2), // Soft beige
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Play button
            GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.brown, width: 2),
                ),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.brown,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Waveform (NO container)
            SizedBox(
              width: 250,
              height: 80,
              child: CustomPaint(
                painter: CurvedWaveformPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedWaveformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF652B1C) // Similar deep brown
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    double waveHeight = size.height / 2;

    path.moveTo(0, waveHeight);

    // Manually mapped wave to closely match your image visually
    path.cubicTo(5, waveHeight - 45, 10, waveHeight + 55, 20, waveHeight);
    path.cubicTo(25, waveHeight - 60, 30, waveHeight + 40, 40, waveHeight);
    path.cubicTo(45, waveHeight - 20, 50, waveHeight + 20, 60, waveHeight);
    path.cubicTo(65, waveHeight - 35, 70, waveHeight + 30, 80, waveHeight);
    path.cubicTo(85, waveHeight - 25, 90, waveHeight + 20, 100, waveHeight);
    path.cubicTo(105, waveHeight - 90, 110, waveHeight + 70, 120, waveHeight);
    path.cubicTo(125, waveHeight - 70, 130, waveHeight + 50, 140, waveHeight);
    path.cubicTo(145, waveHeight - 55, 150, waveHeight + 35, 160, waveHeight);
    path.cubicTo(165, waveHeight - 70, 170, waveHeight + 20, 180, waveHeight);
    path.cubicTo(185, waveHeight - 60, 190, waveHeight + 30, 200, waveHeight);
    path.cubicTo(205, waveHeight - 90, 210, waveHeight + 70, 220, waveHeight);
    path.cubicTo(225, waveHeight - 80, 230, waveHeight + 60, 240, waveHeight);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
