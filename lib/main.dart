import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  File? _videoFile;
  VideoPlayerController? _controller;
  bool _isPlaying = false;

  Future<void> _pickVideo() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        _videoFile = File(video.path);
        _controller = VideoPlayerController.file(_videoFile!)
          ..initialize().then((_) {
            setState(() {
              _isPlaying = true;
            });
          });
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_videoFile != null)
                AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                )
              else
                Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.video_library,
                    size: 60,
                    color: Colors.grey[800],
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickVideo,
                child: Text('Pick Video'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller != null) {
              if (_isPlaying) {
                _controller!.pause();
                _isPlaying = false;
              } else {
                _controller!.play();
                _isPlaying = true;
              }
            }
          });
        },
        child: _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ),
    );
  }
}
