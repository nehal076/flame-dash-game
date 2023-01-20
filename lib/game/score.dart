import 'package:devfest_game/main.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class ScoreDisplay extends TextComponent with HasGameRef {
  ScoreDisplay()
      : super(
          text: 'Score: 80',
          priority: 10,
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 24.0,
              package: 'GoogleFonts',
              fontFamily: 'Lobster',
              color: Color.fromARGB(255, 1, 74, 111),
            ),
          ),
        );

  // @override
  // void update(double dt) {
  //   int score = getIt<DashManager>().score;
  //   super.text = 'Score\n${score.toString()}';
  // }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    super.anchor = Anchor.topRight;
    super.x = gameRef.size.x - 15;
    super.y = 15.0;
  }
}
