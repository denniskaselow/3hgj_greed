part of client;

class OrderUpdateSystem extends EntityProcessingSystem {
  ComponentMapper<Account> am;
  ButtonElement executor;
  bool execute = false;
  OrderUpdateSystem() : super(Aspect.getAspectForAllOf([Account]));

  @override
  void initialize() {
    executor = querySelector('#executeOrder');
    executor.onClick.listen((event) {
      execute = true;
    });
  }

  @override
  void processEntity(Entity entity) {
    bool isValid = false;
    String symbol = (querySelector('#stockSelection') as SelectElement).value;

    if (symbol.isNotEmpty) {
      isValid = true;
      int amount = 0;
      try {
        amount = int.parse((querySelector('#amount') as InputElement).value);
      } catch (e) {
        isValid = false;
      };

      int leverage = 1;
      try {
        leverage = int.parse((querySelector('#leverage') as InputElement).value);
      } catch (e) {
        isValid = false;
      };
      // quick and dirty
      var stockElement = querySelector('#${symbol}_container') as StockElement;
      var price = double.parse(stockElement.priceFormatted);
      var margin = price * amount / leverage;
      querySelector('#margin').setInnerHtml('${margin.toStringAsFixed(2)}');
      querySelector('#leveragedValue').setInnerHtml('${(margin * leverage).toStringAsFixed(2)}');

      var isBuy = (querySelector('#buy') as InputElement).checked;
      var isSell = (querySelector('#sell') as InputElement).checked;
      if (!isBuy && !isSell) {
        isValid = false;
      }
      var account = am.get(entity);
      if (account.cash < margin) {
        isValid = false;
      }

      if (isValid && execute) {
        execute = false;
        var orderExecution = new OrderExecution(new Order(symbol, amount, isBuy ? 0 : 1, leverage), price, 10.0);
        eventBus.fire(orderExecutionEvent, orderExecution);
      }
    }
    if (isValid) {
      executor.disabled = false;
    } else {
      executor.disabled = true;
    }
  }
}

class OrderExecutionSystem extends OnInvestmentActionSystem {
  OpenPositionsElement ope = querySelector('open-positions-element');
  ComponentMapper<Account> am;
  StockManager sm;
  OrderExecutionSystem() : super(Aspect.getAspectForAllOf([Account]));

  @override
  void processEntity(Entity entity) {
    var a = am.get(entity);
    var execution = orderExecution.removeFirst();
    var boundMargin = execution.order.amount.abs() * execution.price / execution.order.leverage;
    a.cash -= boundMargin + execution.provision;
    a.boundMargin += boundMargin;
    var stockId = sm.createStockId(execution.order.symbol);
    var openPosition = new OpenPosition(execution.order.amount, execution.order.leverage, execution.price);

    var e = world.createAndAddEntity([stockId, openPosition]);
    ope.createOpenPositionElement(e.uniqueId, stockId, openPosition);
  }
}