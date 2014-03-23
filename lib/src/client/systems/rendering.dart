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

    SelectElement stockSelection = querySelector('#stockSelection');
    var option = new OptionElement(data: '${s.symbol} - ${s.name}', value: s.symbol);
    stockSelection.append(option);

    initialized = true;
  }

  bool checkProcessing() => !initialized;
}


class OverviewRenderingSystem extends EntityPerTickProcessingSystem {
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

class AccountRenderingSystem extends EntityPerTickProcessingSystem {
  ComponentMapper<Account> am;
  ComponentMapper<Price> pm;
  TagManager tm;
  bool updateImmediately = false;
  AccountRenderingSystem() : super(Aspect.getAspectForAllOf([Account]));

  @override
  void initialize() {
    eventBus.on(orderExecutionEvent).listen((_) => updateImmediately = true);
  }

  @override
  void processEntity(Entity entity) {
    var a = am.get(entity);

    double boundMargin = 0.0;
    double change = 0.0;
    a.investments.forEach((investment) {
      Price price = pm.get(tm.getEntity(investment.symbol));
      boundMargin += investment.amount.abs() * investment.firstPrice;
      change += investment.amount * investment.leverage * (investment.firstPrice - price.price);
    });
    double unboundMargin = a.cash + change;

    querySelector('#boundMargin').setInnerHtml('${boundMargin.toStringAsFixed(2)} G');
    querySelector('#unboundMargin').setInnerHtml('${unboundMargin.toStringAsFixed(2)} G');
    querySelector('#total').setInnerHtml('${(boundMargin + unboundMargin).toStringAsFixed(2)} G');

    updateImmediately = false;
  }

  @override
  bool checkProcessing() => super.checkProcessing() || updateImmediately;
}