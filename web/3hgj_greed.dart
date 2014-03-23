import 'package:3hgj_greed/client.dart';

@MirrorsUsed(targets: const [InitializationSystem, StockElementUpdatingSystem,
                             TickerSystem, AccountRenderingSystem,
                             OrderUpdateSystem, OrderExecutionSystem
                            ])
import 'dart:mirrors';

import 'package:polymer/polymer.dart';

void main() {
  initPolymer().run(() => new Game().start());
}

class Game extends GameBase {

  Game() : super.noAssets('3hgj_greed', 'canvas', 800, 600);

  @override
  Future onInit() {
    world.addManager(new TagManager());
  }

  void createEntities() {
    TagManager tm = world.getManager(TagManager);
    stocks.forEach((stock) {
      var firstPrice = 20 + random.nextDouble() * 150;
      var price = new Price(firstPrice);
      var e = addEntity([new StockId(stock[0], stock[1]),
                 price,
                 new PriceHistory(firstPrice)]);
      tm.register(e, stock[0]);
    });
    addEntity([new Account(50000.0)]);
  }

  List<EntitySystem> getSystems() {
    return [
            new InitializationSystem(),
            new TickerSystem(),
            new OrderUpdateSystem(),
            new OrderExecutionSystem(),
            new AccountRenderingSystem(),
            new StockElementUpdatingSystem()
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