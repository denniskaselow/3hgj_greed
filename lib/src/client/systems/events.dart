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

      int leverage = 0;
      try {
        leverage = int.parse((querySelector('#leverage') as InputElement).value);
      } catch (e) {
        isValid = false;
      };
      // quick and dirty
      var priceWithUnit = querySelector('#${symbol}_price').innerHtml;
      var price = double.parse(priceWithUnit.substring(0, priceWithUnit.length - 2));
      var margin = price * amount;
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
        eventBus.fire(orderExecutionEvent, new OrderExecution(new Order(symbol, amount, isBuy ? 0 : 1, leverage), price));
      }
    }
    if (isValid) {
      executor.disabled = false;
    } else {
      executor.disabled = true;
    }
  }

}