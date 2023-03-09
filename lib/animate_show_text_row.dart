import 'dart:async';
import 'package:flutter/material.dart';

class AnimateShowTextRow extends StatefulWidget {
  final String child;
  final int delay;
  final AnimationController animController;

  AnimateShowTextRow(
      {required this.child, required this.delay, required this.animController});

  @override
  _AnimateShowTextRowState createState() => _AnimateShowTextRowState();
}

class _AnimateShowTextRowState extends State<AnimateShowTextRow>
    with TickerProviderStateMixin {
  // late AnimationController _animController;
  late Animation<Offset> _animOffset;

  late List words;

  @override
  void initState() {
    super.initState();

    final curve = CurvedAnimation(
        curve: Curves.decelerate, parent: widget.animController);
    _animOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero)
            .animate(curve);

    words = widget.child.split(' ');

    print(words);
    // if (widget.delay == null) {
    //   _animController.forward();
    // } else {
    //   Timer(Duration(milliseconds: widget.delay), () {
    //     _animController.forward();
    //   });
    // }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _animController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          words.length,
          (index) => FadeTransition(
            child: SlideTransition(
              position: _animOffset,
              child: Text(
                words[index],
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            opacity: widget.animController,
          ),
        ),
      ],
    );
  }
}
