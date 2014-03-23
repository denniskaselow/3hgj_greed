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
  }
}

class GraphRenderingSystem extends EntityPerTickProcessingSystem {
  ComponentMapper<StockId> sm;
  ComponentMapper<PriceHistory> phm;
  CanvasRenderingContext2D ctx;
  String symbol;
  GraphRenderingSystem(this.ctx) : super(Aspect.getAspectForAllOf([StockId, PriceHistory]));

  @override
  void initialize() {
    eventBus.on(toggleGraphEvent).listen((ToggleGraph event) {
      symbol = event.symbol;
      updateImmediately = true;
    });
  }

  @override
  void processEntity(Entity entity) {
    var s = sm.get(entity);
    if (s.symbol == symbol) {
      var ph = phm.get(entity);
      var x = 5;
      var moveBy = 790 / ph.prices.length;
      var minPrice = ph.firstPrice;
      var maxPrice = ph.firstPrice;
      ph.prices.forEach((price) {
        if (minPrice > price) {
          minPrice = price;
        } else if (maxPrice < price) {
          maxPrice = price;
        }
      });
      var diff = maxPrice - minPrice;
      var yMod = 580 / diff;

      ctx.clearRect(0, 0, 800, 600);
      ctx.beginPath();
      ctx.moveTo(x, 590 - yMod * (ph.prices.first - minPrice));
      ph.prices.forEach((price) {
        x += moveBy;
        ctx.lineTo(x, 590 - yMod * (price - minPrice));
      });
      ctx.stroke();
      ctx.closePath();
      ctx.fillText(s.symbol, 10, 15);
      ctx.fillText(s.name, 10, 30);

      ctx..beginPath()
         ..moveTo(5, 0)
         ..lineTo(5, 595)
         ..lineTo(795, 595)
         ..stroke()
         ..closePath();

      ctx..beginPath()
         ..moveTo(5, 590 - yMod * (ph.firstPrice - minPrice))
         ..lineTo(795, 590 - yMod * (ph.firstPrice - minPrice))
         ..stroke()
         ..closePath();

    }
  }
}