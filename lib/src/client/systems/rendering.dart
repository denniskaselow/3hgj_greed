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
    stock.title = s.name;

    stock.classes.add('stock');
    stock.id = s.symbol;
    var label = new LabelElement();
    label.appendText(s.symbol);

    var price = new SpanElement();
    price.id = '${s.symbol}_price';
    price.classes.add('price');
    var change = new SpanElement();
    change.id = '${s.symbol}_change';
    change.classes.add('change');

    stock.append(label);
    stock.append(price);
    stock.append(change);
    div.append(stock);

    initialized = true;
  }

  bool checkProcessing() => !initialized;
}


class OverviewRenderingSystem extends EntityProcessingSystem {
  ComponentMapper<StockId> sm;
  ComponentMapper<Price> pm;
  ComponentMapper<PriceHistory> phm;

  OverviewRenderingSystem() : super(Aspect.getAspectForAllOf([StockId, Price, PriceHistory]));

  @override
  void processEntity(Entity entity) {
    var s = sm.get(entity);
    var p = pm.get(entity);
    var ph = phm.get(entity);

    var price = querySelector('#${s.symbol}_price');
    price.setInnerHtml('${p.price.toStringAsFixed(3)} G');

    var change = querySelector('#${s.symbol}_change');
    change.setInnerHtml('${ph.absoluteChange.toStringAsFixed(3)} G ${ph.relativeChange.toStringAsFixed(2)} %');

    var stock = querySelector('#${s.symbol}');
    var bColor = 'grey';
    if (ph.relativeChange > 0.0) {
      bColor = new Color.fromHsl(0.35, min(ph.relativeChange / maxPosRelativeChange, 1.0), 0.5).toHex();
    } else if (ph.relativeChange < 0.0) {
      bColor = new Color.fromHsl(0.0, min(ph.relativeChange / maxNegRelativeChange, 1.0), 0.5).toHex();
    }
    stock.style.backgroundColor = bColor;
  }
}