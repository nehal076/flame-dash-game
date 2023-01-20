import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import './helpers/helpers.dart';

// class Player extends SpriteAnimationComponent with HasGameRef {
//   late final SpriteAnimation _runRightAnimation;

//   Player() : super(size: Vector2.all(60.0), position: Vector2(80, 400));

//   @override
//   Future<void> onLoad() async {
//     super.onLoad();
//     _loadAnimations().then((_) => {animation = _runRightAnimation});
//   }

//   Future<void> _loadAnimations() async {
//     final spriteSheet = SpriteSheet(
//       image: await gameRef.images.load('game/player_spritesheet.png'),
//       srcSize: Vector2(29, 32),
//     );

//     _runRightAnimation =
//         spriteSheet.createAnimation(row: 3, stepTime: 0.5, to: 4);
//   }
// }

class Player extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  final double _playerSpeed = 300.0;
  final double _animationSpeed = 0.15;

  late final SpriteAnimation _runDownAnimation;
  late final SpriteAnimation _runLeftAnimation;
  late final SpriteAnimation _runUpAnimation;
  late final SpriteAnimation _runRightAnimation;
  late final SpriteAnimation _standingAnimation;

  Direction direction = Direction.none;

  Player() : super(size: Vector2.all(60.0), position: Vector2(80, 400));
  @override
  Future<void> onLoad() async {
    super.onLoad();
    _loadAnimations().then((_) => {animation = _standingAnimation});
    add(RectangleHitbox());
  }

  @override
  void onCollision(
      Set<Vector2> intersectionPoints, PositionComponent other) async {
    super.onCollision(intersectionPoints, other);
    print('COLLISION!!');

    // getIt<DashManager>().increaseScore();
  }

  @override
  void update(double dt) {
    super.update(dt);
    movePlayer(dt);
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('game/player_spritesheet.png'),
      srcSize: Vector2(29.0, 32.0),
    );

    _runDownAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 4);

    _runLeftAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 4);

    _runUpAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 4);

    _runRightAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 4);

    _standingAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 1);
  }

  void movePlayer(double delta) {
    switch (direction) {
      case Direction.up:
        animation = _runUpAnimation;
        moveUp(delta);
        break;
      case Direction.down:
        animation = _runDownAnimation;
        moveDown(delta);
        break;
      case Direction.left:
        animation = _runLeftAnimation;
        moveLeft(delta);
        break;
      case Direction.right:
        animation = _runRightAnimation;
        moveRight(delta);
        break;
      case Direction.none:
        animation = _standingAnimation;
        break;
    }
  }

  void moveUp(double delta) {
    position.add(Vector2(0, delta * -_playerSpeed));
  }

  void moveDown(double delta) {
    position.add(Vector2(0, delta * _playerSpeed));
  }

  void moveLeft(double delta) {
    position.add(Vector2(delta * -_playerSpeed, 0));
  }

  void moveRight(double delta) {
    position.add(Vector2(delta * _playerSpeed, 0));
  }
}
