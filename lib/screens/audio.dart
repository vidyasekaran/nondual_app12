import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioCard extends StatefulWidget {
  final String title;
  final String audioAsset;

  const AudioCard({super.key, required this.title, required this.audioAsset});

  @override
  State<AudioCard> createState() => _AudioCardState();
}

class _AudioCardState extends State<AudioCard> {
  late AudioPlayer _player;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.setAsset(widget.audioAsset);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      //margin: const EdgeInsets.symmetric(vertical: 8),
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          isPlaying ? Icons.pause_circle : Icons.play_circle,
          size: 40,
          color: Colors.blue,
        ),
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: _togglePlay,
      ),
    );
  }
}
