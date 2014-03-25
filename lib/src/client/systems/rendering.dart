part of client;

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

class OpenPositionUpdatingSystem extends EntityPerTickProcessingSystem {
  OpenPositionsElement ope = querySelector('open-positions-element');
  ComponentMapper<StockId> sm;
  ComponentMapper<OpenPosition> opm;
  StockManager stockManager;
  AccountManager am;
  OpenPositionUpdatingSystem() : super(Aspect.getAspectForAllOf([StockId, OpenPosition]));

  @override
  void begin() {
    am.account.unrealizedProfitOrLoss = 0.0;
  }

  @override
  void processEntity(Entity entity) {
    var op = opm.get(entity);
    var s = sm.get(entity);

    op.currentPrice = stockManager.getPrice(s.symbol);
    ope.updateProfitLoss(entity.uniqueId, op.profitOrLoss);
    am.account.unrealizedProfitOrLoss += op.profitOrLoss;
  }
}

class AccountRenderingSystem extends EntityPerTickProcessingSystem {
  ComponentMapper<Account> am;
  ComponentMapper<Price> pm;
  StockManager sm;
  AccountRenderingSystem() : super(Aspect.getAspectForAllOf([Account]));

  @override
  void initialize() {
    eventBus.on(orderExecutionEvent).listen((_) => updateImmediately = true);
  }

  @override
  void processEntity(Entity entity) {
    var a = am.get(entity);

    querySelector('#boundMargin').setInnerHtml('${a.boundMargin.toStringAsFixed(2)} G');
    querySelector('#unboundMargin').setInnerHtml('${(a.cash + a.unrealizedProfitOrLoss).toStringAsFixed(2)} G');
    querySelector('#total').setInnerHtml('${(a.cash + a.unrealizedProfitOrLoss + a.boundMargin).toStringAsFixed(2)} G');
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