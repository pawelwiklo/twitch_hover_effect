import 'dart:async';

import 'package:flutter/material.dart';
import 'package:twitch_hover_effect/animate_show_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Color iconColor = Colors.white54;
  bool _visible = false;
  String sentence =
      'This grid was kinda hard to do although ebe aaa aa aaa aaa aaa aaa';
  List words = [];
  late List animControllers;

  void _mouseEnter(PointerEvent details) {
    setState(() {
      iconColor = Colors.white;
      _visible = true;
    });
    for (var i = 0; i != animControllers.length; i++) {
      Timer(Duration(milliseconds: 50 * i), () {
        if (_visible) {
          animControllers[i].forward();
        }
      });
    }
  }

  void _mouseExit(PointerEvent details) {
    setState(() {
      iconColor = Colors.white54;
      _visible = false;
    });
    for (var i = 0; i != animControllers.length; i++) {
      animControllers[i].reset();
    }
  }

  void _updateLocation(PointerEvent details) {
    setState(() {});
  }

  @override
  void initState() {
    List sentenceList = sentence.split(' ');
    print(sentenceList);
    animControllers = List.generate(
        sentenceList.length,
        (index) => AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));

    List combined = [];
    for (var i = 0; i != sentenceList.length; i++) {
      combined.add({'text': sentenceList[i], 'controller': animControllers[i]});
      print({'text': sentenceList[i], 'controller': animControllers[i]});
    }
    sentenceList = combined;

    var chunks = [];
    int chunkSize = 5;
    for (var i = 0; i < sentenceList.length; i += chunkSize) {
      chunks.add(sentenceList.sublist(
          i,
          i + chunkSize > sentenceList.length
              ? sentenceList.length
              : i + chunkSize));
    }
    setState(() {
      words = chunks;
    });

    print('words.length: ${words.length}');
    print('words[0].length: ${words[0].length}');
    // print('words[0]: ${words[0]}');
    // print('words[1]: ${words[1]}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.8),
      body: Center(
        child: Stack(
          children: [
            Container(
              width: 400,
              height: 700,
              margin: EdgeInsets.all(25.0),
              child: _drawGridDots(),
            ),
            Container(
              width: 400,
              height: 700,
              margin: EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                  border: Border.all(color: Colors.lightBlue, width: 5)),
            ),
            AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 100),
              child: Container(
                width: 450.0,
                height: 750.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                    // colors: [Colors.green, Color.fromARGB(255, 29, 221, 163)],
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: 440.0,
                height: 740.0,
                margin: EdgeInsets.all(20.0),
                child: _drawGridDots(),
              ),
            ),
            Positioned(
              top: 200,
              left: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                      // words.length,
                      words.length,
                      (index) => Row(
                            children: [
                              ...List.generate(
                                  // words[index].length,
                                  words[index].length,
                                  (i) => AnimateShowText(
                                        // child: 'This grid was kinda hard to do although',
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            // words[index][i]['text'],
                                            words[index][i]['text'],
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white),
                                          ),
                                        ),
                                        animController: words[index][i]
                                            ['controller'],
                                        // animController: animControllers[0],
                                      )),
                            ],
                          )),
                ],
              ),
            ),
            Positioned(
              child: Icon(
                Icons.ac_unit_rounded,
                size: 100,
                color: iconColor,
              ),
              left: 40,
              bottom: 80,
            ),
            MouseRegion(
              onEnter: _mouseEnter,
              onHover: _updateLocation,
              onExit: _mouseExit,
              child: Container(
                margin: EdgeInsets.all(25.0),
                width: 400,
                height: 700,
              ),
            ),
            Positioned(
              top: 40,
              left: 40,
              child: Text(
                'Cool Effect\nReally Cool',
                style: TextStyle(color: Colors.white, fontSize: 50),
              ),
            )
          ],
        ),
      ),
    );
  }

  _drawGridDots({double space = 50, Color color = Colors.white54}) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        var dot = Container(width: 4, height: 4, color: color);
        int rows = (width / space).round();
        int columns = (height / space).round() + 1;
        return Stack(
          children: <Widget>[
            for (int i = 0; i < rows; i++)
              ...List.generate(
                columns,
                (index) =>
                    Positioned(left: i * space, top: index * space, child: dot),
              ),
          ],
        );
      },
    );
  }
}
