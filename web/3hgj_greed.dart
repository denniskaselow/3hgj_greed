import 'package:3hgj_greed/client.dart';

@MirrorsUsed(targets: const [
                            ])
import 'dart:mirrors';

void main() {
  new Game().start();
}

class Game extends GameBase {

  Game() : super.noAssets('3hgj_greed', 'canvas', 800, 600);

  void createEntities() {
    // addEntity([Component1, Component2]);
  }

  List<EntitySystem> getSystems() {
    return [
            new CanvasCleaningSystem(canvas),
            new FpsRenderingSystem(ctx)
    ];
  }
}
