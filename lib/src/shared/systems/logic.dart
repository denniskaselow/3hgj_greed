part of shared;


class TickerSystem extends IntervalEntityProcessingSystem {
  ComponentMapper<Price> pm;
  ComponentMapper<PriceHistory> phm;
  TickerSystem() : super(1000, Aspect.getAspectForAllOf([Price, PriceHistory]));

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
    if (ph.prices.length > 60) {
      ph.prices.removeFirst();
    }
    p.price = nextPrice;
  }
}