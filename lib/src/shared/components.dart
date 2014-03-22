part of shared;

class Price extends Component {
  double price;
  Price(this.price);
}

class StockId extends Component {
  String name;
  String symbol;
  StockId(this.symbol, this.name);
}

class StockIndex extends Component {}