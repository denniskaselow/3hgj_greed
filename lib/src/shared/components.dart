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

class PriceHistory extends Component {
  Queue<double> prices = new Queue<double>();
  double firstPrice;
  double absoluteChange = 0.0;
  double relativeChange = 0.0;
  PriceHistory(this.firstPrice) {
    prices.add(firstPrice);
  }
}

class StockIndex extends Component {}

class Account extends Component {
  double cash;
  List<Investment> investments = new List<Investment>();
  Account(this.cash);
}