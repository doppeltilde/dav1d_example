import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/video_player_view.dart';
import 'package:fvp/fvp.dart' as fvp;

void setupFVP() {
  Map<String, dynamic> options = {};

  if (Platform.isWindows) {
    options['video.decoders'] = ['MFT:d3d=11', 'FFmpeg'];
  } else if (Platform.isAndroid) {
    options['video.decoders'] = ['AMediaCodec:surface=1', 'FFmpeg'];
  } else if (Platform.isIOS || Platform.isMacOS) {
    options['video.decoders'] = [
      'VT:copy=0:async=1:hardware=1:realTime=1:efficient=0',
      'dav1d:threads=0:tile_threads=4',
      'FFmpeg',
    ];
  } else if (Platform.isLinux) {
    options['video.decoders'] = ['VAAPI', 'FFmpeg'];
  }

  options['lowLatency'] = 1;

  options["global"] = {'logLevel': 'All'};

  fvp.registerWith(options: options);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupFVP();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),

      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  incrementCounter() async {
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'videos',

        extensions: <String>['mp4', 'mov', 'avi', 'mkv', 'webm'],
        uniformTypeIdentifiers: ['public.movie'],
      );
      final XFile? file = await openFile(
        acceptedTypeGroups: <XTypeGroup>[typeGroup],
      );

      if (file != null) {
        print('Selected video file path: ${file.path}');
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return VideoPlayerScreen(videoPath: file.path);
            },
          ),
        );
      }
    } catch (e, st) {
      print(e);
      print(st);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.shrink(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await incrementCounter(),
        tooltip: 'Add Video',
        child: const Icon(Icons.add),
      ),
    );
  }
}
