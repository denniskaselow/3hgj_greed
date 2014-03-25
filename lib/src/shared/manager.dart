part of shared;

class StockManager extends Manager {
  ComponentMapper<Price> _pm;
  ComponentMapper<StockId> _sm;
  var _stocks = new Map<String, Entity>();

  void addStock(String symbol, Entity e) {
    _stocks[symbol] = e;
  }

  double getPrice(String symbol) => _pm.get(_stocks[symbol]).price;

  String getName(String symbol) => _sm.get(_stocks[symbol]).name;

  StockId createStockId(String symbol) => new StockId(symbol, getName(symbol));
}

class AccountManager extends Manager {
  Entity _entity;
  ComponentMapper<Account> _am;
  void set accountEntity(Entity accountEntity) {
    _entity = accountEntity;
  }

  Account get account => _am.get(_entity);
}