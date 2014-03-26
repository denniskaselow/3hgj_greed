library open_position_element;

import 'package:intl/intl.dart';
import 'package:polymer/polymer.dart';

@CustomTag('open-position-element')
class OpenPositionElement extends PolymerElement {
  final String colorPos = '#6C9500';
  final String colorNeg = '#DA6710';
  final moneyFormat = new NumberFormat('+0.00;-0.00');

  @observable String symbol;
  @observable String name;
  @observable int amount;
  @observable int leverage;
  @observable String marginFormatted;
  @observable String profitOrLossFormatted;
  @observable String profitOrLossColor;
  @observable String amountColor;
  OpenPositionElement.created() : super.created();

  void set margin(double value) {
    marginFormatted = value.toStringAsFixed(2);
  }

  void set profitOrLoss(double value) {
    profitOrLossFormatted = moneyFormat.format(value);
    if (value < 0.0) {
      profitOrLossColor = colorNeg;
    } else {
      profitOrLossColor = colorPos;
    }
  }

  amountChanged(int oldValue) {
    if (amount < 0) {
      amountColor = colorNeg;
    } else {
      amountColor = colorPos;
    }
  }

}