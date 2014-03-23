part of shared;

abstract class EntityPerTickProcessingSystem extends IntervalEntityProcessingSystem {
  bool updateImmediately = false;
  EntityPerTickProcessingSystem(Aspect aspect) : super(1000, aspect);

  @override
  void end() {
    updateImmediately = false;
  }

  @override
  bool checkProcessing() => super.checkProcessing() || updateImmediately;
}

class TickerSystem extends EntityPerTickProcessingSystem {
  ComponentMapper<Price> pm;
  ComponentMapper<PriceHistory> phm;
  TickerSystem() : super(Aspect.getAspectForAllOf([Price, PriceHistory]));

  @override
  void begin() {
    maxNegRelativeChange = 0.0;
    maxPosRelativeChange = 0.0;
  }

  @override
  void processEntity(Entity entity) {
    var p = pm.get(entity);
    var ph = phm.get(entity);

    var nextPrice = p.price + random.nextDouble() * 0.001 * p.price * (random.nextBool() ? 1 : -1);
    ph.prices.add(p.price);
    ph.absoluteChange = p.price - ph.firstPrice;
    ph.relativeChange = 100 * (ph.absoluteChange / p.price);
    if (ph.relativeChange < maxNegRelativeChange) {
      maxNegRelativeChange = ph.relativeChange;
    } else if (ph.relativeChange > maxPosRelativeChange) {
      maxPosRelativeChange = ph.relativeChange;
    }
    if (ph.prices.length > 120) {
      ph.prices.removeFirst();
    }
    p.price = nextPrice;
  }
}

class OrderExecutionSystem extends EntityProcessingSystem {
  ComponentMapper<Account> am;
  OrderExecution orderExecution;
  OrderExecutionSystem() : super(Aspect.getAspectForAllOf([Account]));

  @override
  void initialize() {
    eventBus.on(orderExecutionEvent).listen((event) {
      orderExecution = event;
    });
  }

  @override
  void processEntity(Entity entity) {
    var a = am.get(entity);
    var investment = new Investment(orderExecution);
    a.investments.add(investment);
    a.cash -= investment.amount.abs() * investment.firstPrice;
    orderExecution = null;
  }

  @override
  bool checkProcessing() => orderExecution != null;

}