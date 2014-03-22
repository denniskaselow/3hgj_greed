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

class AccountRenderingSystem extends EntityProcessingSystem {
  ComponentMapper<Account> am;
  AccountRenderingSystem() : super(Aspect.getAspectForAllOf([Account]));


  @override
  void processEntity(Entity entity) {
    var a = am.get(entity);

    querySelector('#notInvested').setInnerHtml('${a.cash.toStringAsFixed(2)} G');

    double invested = 0.0;
    double borrowed = 0.0;
    a.investments.forEach((investment) {
      Price price = priceComponents[investment.symbol];
      invested += investment.amount * price.price * investment.leverage;
      borrowed += investment.amount * investment.firstPrice * investment.leverage - investment.firstPrice * investment.amount;
    });

    querySelector('#invested').setInnerHtml('${invested.toStringAsFixed(2)} G');
    querySelector('#borrowed').setInnerHtml('${borrowed.toStringAsFixed(2)} G');
    querySelector('#total').setInnerHtml('${(a.cash + invested - borrowed).toStringAsFixed(2)} G');
  }
}

class OrderUpdateSystem extends EntityProcessingSystem {
  ComponentMapper<Account> am;
  ButtonElement executor;
  bool execute = false;
  OrderUpdateSystem() : super(Aspect.getAspectForAllOf([Account]));

  @override
  void initialize() {
    executor = querySelector('#executeOrder');
    executor.onClick.listen((event) {
      print('submit');
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

        var investment = new Investment();
        investment..amount = amount * (isBuy ? 1 : -1)
                  ..firstPrice = price
                  ..leverage = leverage
                  ..symbol = symbol;
        account.investments.add(investment);
        account.cash -= margin * (isBuy ? 1 : -1);
      }
    }
    if (isValid) {
      executor.disabled = false;
    } else {
      executor.disabled = true;
    }
  }

}