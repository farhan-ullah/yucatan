import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RiveAnimation extends StatefulWidget {
  final String riveFileName;
  final String riveAnimationName;
  final String placeholderImage;
  final int startAnimationAfterMilliseconds;

  RiveAnimation({
    Key? key,
    required this.riveFileName,
    required this.riveAnimationName,
    required this.placeholderImage,
    required this.startAnimationAfterMilliseconds,
  }) : super(key: key);

  @override
  _RiveAnimationState createState() {
    return _RiveAnimationState();
  }
}

class _RiveAnimationState extends State<RiveAnimation> {
   Artboard? _riveArtboard;
   RiveAnimationController? _controller;

  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/rive/${widget.riveFileName}').then(
      (data) async {
        // Load the RiveFile from the binary data.
        // var rive = RiveFile();
        final rive = RiveFile.import(data);
        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = rive.mainArtboard;

        // Add a controller to play back a known animation on the main/default
        // artboard.We store a reference to it so we can toggle playback.
        _controller = SimpleAnimation(widget.riveAnimationName);

        artboard.addController(_controller!);

        if (widget.startAnimationAfterMilliseconds > 0) {
          _controller!.isActive = false;

          Future.delayed(
              Duration(milliseconds: widget.startAnimationAfterMilliseconds),
              () {
            setState(() {
              _controller!.isActive = true;
            });
          });
        }

        setState(() {
          _riveArtboard = artboard;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _riveArtboard == null
        ? Image.asset(
            widget.placeholderImage,
            fit: BoxFit.cover,
          )
        : Rive(
            artboard: _riveArtboard!,
            fit: BoxFit.contain,
          );
  }
}
