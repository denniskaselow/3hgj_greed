import 'package:3hgj_greed/client.dart';

@MirrorsUsed(targets: const [InitializationSystem, OverviewRenderingSystem,
                             TickerSystem
                            ])
import 'dart:mirrors';

void main() {
  new Game().start();
}

class Game extends GameBase {

  Game() : super.noAssets('3hgj_greed', 'canvas', 800, 600);

  void createEntities() {
    stocks.forEach((stock) {
      var firstPrice = 20 + random.nextDouble() * 150;
      addEntity([new StockId(stock[0], stock[1]),
                 new Price(firstPrice),
                 new PriceHistory(firstPrice)]);
    });
  }

  List<EntitySystem> getSystems() {
    return [
            new TickerSystem(),
            new InitializationSystem(),
            new OverviewRenderingSystem(),
            new CanvasCleaningSystem(canvas),
            new FpsRenderingSystem(ctx)
    ];
  }
}

var stocks = [['NNNN', '4N Co'],
              ['ASP', 'America On Speed Co'],
              ['ABC', 'AB & C Inc'],
              ['BB', 'Boing Boing Co'],
              ['DOG', 'Dogepillar Inc'],
              ['VCX', 'Vechron Corp'],
              ['COCO', 'Coco System Inc'],
              ['CC', 'Double C Corp'],
              ['XES', 'Oxxem Static Corp'],
              ['CE', 'Common Energy Co'],
              ['SF', 'Silverwoman Frank Group Inc'],
              ['HS', 'House Store'],
              ['ENTC', 'Entil Corp'],
              ['NCP', 'National Company People Co'],
              ['JOJ', 'Jane | Jane'],
              ['PJH', 'PJEvening Hunters and Co'],
              ['FFD', 'Fast Food Scrooge Corp'],
              ['CKE', 'CK Erm & Co Inc'],
              ['MHRD', 'Macrohard Corp'],
              ['KNE', 'Kine Inc'],
              ['BPL', 'Blue Pill Inc'],
              ['PAG', 'Protector & Gambler Co'],
              ['COCA', 'Cold Caffeine Co'],
              ['SHC', 'Staying Home Companies Inc'],
              ['STS', 'Separated Tools Corp'],
              ['FTE', 'Fitness Ensemble Inc'],
              ['ZV', 'Zorevin Connections Inc'],
              ['S', 'Savi Inc'],
              ['CCC', 'Cheap Cheap Cheaper Depot Inc'],
              ['VTN', 'Vault This Nay Co'],
              ];