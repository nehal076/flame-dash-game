import 'dart:math';

import 'package:devfest_game/game/joypad.dart';
import 'package:devfest_game/game/score.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

import 'game/helpers/directions.dart';
import 'game/player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingleton<DashManager>(DashManager());
  // getIt.registerSingleton<ScoreDisplay>(ScoreDisplay());
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  MainGameState createState() => MainGameState();
}

class MainGameState extends State<Home> {
  DashGame game = DashGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Joypad(onDirectionChanged: game.onJoypadDirectionChanged),
            ),
          )
        ],
      ),
    );
  }
}

class DashGame extends FlameGame {
  final World _world = World();
  final Player _player = Player();
  final DashManager _dash = DashManager();
  // ScoreDisplay scoreDisplay = ScoreDisplay();

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    await add(_world);
    await add(_player);
    await add(_dash);
    // await add(scoreDisplay);
  }

  void onJoypadDirectionChanged(Direction direction) {
    _player.direction = direction;
  }
}

class World extends ParallaxComponent<DashGame> {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData('game/bg5.png'),
      ],
      baseVelocity: Vector2(50, 0),
      velocityMultiplierDelta: Vector2(1.8, 1.0),
    );
  }
}

class Dash extends SpriteComponent with HasGameRef {
  Dash({
    Vector2? position,
  }) : super(
          size: Vector2(100, 50),
          position: position,
        );

  @override
  void update(double dt) {
    super.update(dt);

    position -= Vector2(1, 0) * 250 * dt;

    if (position.x < -50) {
      removeFromParent();
    }
  }

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('game/dash.png');
    add(RectangleHitbox());
  }
}

class DashManager extends Component with HasGameRef<DashGame> {
  late Timer _timer;
  final Random random = Random();

  DashManager() : super() {
    _timer = Timer(1, onTick: _spawnDash, repeat: true);
  }

  void _spawnDash() {
    Dash dash = Dash(
      position: Vector2(gameRef.size.x,
          random.nextInt(gameRef.size.y.floor() - 70).toDouble()),
    );

    add(dash);
  }

  void start() {
    _timer.start();
  }

  void stop() {
    _timer.stop();
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
  }

  int score = 0;
  Direction? direction;
  bool gameOver = false;

  increaseScore() {
    score += 1;
  }

  resetScore() {
    score = 0;
  }

  releaseControl() {
    direction = null;
  }

  setDirection(Direction dashDirection) {
    direction = dashDirection;
  }

  setGameOver(bool isOver) {
    gameOver = isOver;
  }
}
