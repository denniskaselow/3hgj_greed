part of shared;

class OrderExecution {
  final Order order;
  final double price;
  OrderExecution(this.order, this.price);
}

class ToggleGraph {
  String symbol;
  ToggleGraph(this.symbol);
}