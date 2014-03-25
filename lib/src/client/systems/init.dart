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
    StockElement stockElement = new Element.tag('stock-element');
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