part of client;


class InitializationSystem extends EntityProcessingSystem {
  ComponentMapper<StockId> sm;
  ComponentMapper<Price> pm;
  bool initialized = false;

  InitializationSystem() : super(Aspect.getAspectForAllOf([StockId, Price]));

  @override
  void processEntity(Entity entity) {
    var stockId = sm.get(entity);
    var price = pm.get(entity);

    DivElement div = querySelector('#stocks');
    var stockElement = new Element.tag('stock-element') as StockElement;
    stockElement.id = '${stockId.symbol}_container';
    stockElement.symbol = stockId.symbol;
    stockElement.name = stockId.name;
    stockElement.price = price.price;
    stockElement.initialPrice = price.price;
    div.append(stockElement);

    SelectElement stockSelection = querySelector('#stockSelection');
    var option = new OptionElement(data: '${stockId.symbol} - ${stockId.name}', value: stockId.symbol);
    stockSelection.append(option);

    initialized = true;
  }

  bool checkProcessing() => !initialized;
}


class StockElementUpdatingSystem extends EntityPerTickProcessingSystem {
  ComponentMapper<StockId> sm;
  ComponentMapper<Price> pm;
  ComponentMapper<PriceHistory> phm;

  StockElementUpdatingSystem() : super(Aspect.getAspectForAllOf([StockId, Price, PriceHistory]));

  @override
  void processEntity(Entity entity) {
    var s = sm.get(entity);
    var p = pm.get(entity);
    var ph = phm.get(entity);

    var elem = querySelector('#${s.symbol}_container') as StockElement;
    elem.price = p.price;
    elem.absoluteChange = ph.absoluteChange;
    elem.relativeChange = ph.relativeChange;
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