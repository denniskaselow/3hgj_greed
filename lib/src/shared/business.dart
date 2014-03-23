part of shared;


class OrderExecution {
  final Order order;
  final double price;
  OrderExecution(this.order, this.price);
}

class Order {
  final String symbol;
  final int _amount;
  final int _type;
  final int leverage;
  Order(this.symbol, this._amount, this._type, this.leverage);
  int get amount => _type == 1 ? _amount : -_amount;
}

class Investment {
  final String symbol;
  final int amount;
  final double firstPrice;
  final int leverage;
  Investment(OrderExecution execution)
      : symbol = execution.order.symbol,
        amount = execution.order.amount,
        firstPrice = execution.price,
        leverage = execution.order.leverage;
}
