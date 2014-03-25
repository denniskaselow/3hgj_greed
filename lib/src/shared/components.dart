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
  double unrealizedProfitOrLoss = 0.0;
  double boundMargin = 0.0;
  Account(this.cash);
}

class OpenPosition extends Component {
  int amount;
  int leverage;
  double orderPrice;
  double currentPrice;
  OpenPosition(this.amount, this.leverage, this.orderPrice) {
    currentPrice = orderPrice;
  }

  double get profitOrLoss => amount * (currentPrice - orderPrice);
  double get margin => amount.abs() * orderPrice / leverage;
}