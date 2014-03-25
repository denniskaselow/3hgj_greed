part of shared;

class Order {
  final String symbol;
  final int _amount;
  final int _type;
  final int leverage;
  Order(this.symbol, this._amount, this._type, this.leverage);
  int get amount => _type == 0 ? _amount : -_amount;
}
