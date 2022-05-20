// import 'package:flutter/material.dart';
// import 'package:my_wallpapers/pages/main_page.dart';
// import 'package:video_player/video_player.dart';

// import '../authentification/constants.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   late VideoPlayerController _controller;
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset("assets/splash-screen.mp4")
//       ..initialize().then((_) {
//         setState(() {});
//       })
//       ..setVolume(0.0);
//     _playVideo();
//   }

//   void _playVideo() async {
//     _controller.play();
//     await Future.delayed(Duration(seconds: 6));
//     Navigator.of(context)
//         .push(MaterialPageRoute(builder: (context) => MainPage()));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kPrimaryColor,
//       body: Center(
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               _controller.value.isInitialized
//                   ? AspectRatio(
//                       aspectRatio: _controller.value.aspectRatio,
//                       child: VideoPlayer(_controller),
//                     )
//                   : Container(),
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     child: Container(
//                     height: 30,
//                     width: 100,
//                     color: kPrimaryColor,
//                   ))
//             ],
//           )),
//     );
//   }
// }
