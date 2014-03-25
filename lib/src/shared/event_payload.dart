part of shared;

class OrderExecution {
  final Order order;
  final double price;
  final double provision;
  OrderExecution(this.order, this.price, this.provision);
}

class ToggleGraph {
  String symbol;
  ToggleGraph(this.symbol);
}