part of client;


class InitializationSystem extends EntityProcessingSystem {
  ComponentMapper<StockId> sm;
  bool initialized = false;

  InitializationSystem() : super(Aspect.getAspectForAllOf([StockId]));

  @override
  void processEntity(Entity entity) {
    var s = sm.get(entity);

    DivElement div = querySelector('#stocks');
    var stock = new DivElement();
    stock.classes.add('stock');
    stock.id = s.symbol;
    var label = new LabelElement();
    label.appendText(s.symbol);
    label.title = s.name;

    var price = new SpanElement();
    price.id = '${s.symbol}_price';

    stock.append(label);
    stock.append(price);
    div.append(stock);

    initialized = true;
  }

  bool checkProcessing() => !initialized;
}


class OverviewRenderingSystem extends EntityProcessingSystem {
  ComponentMapper<StockId> sm;
  ComponentMapper<Price> pm;

  OverviewRenderingSystem() : super(Aspect.getAspectForAllOf([StockId, Price]));

  @override
  void processEntity(Entity entity) {
    var s = sm.get(entity);
    var p = pm.get(entity);

    var price = querySelector('#${s.symbol}_price');
    price.setInnerHtml('${p.price.toStringAsFixed(3)}');
  }
}