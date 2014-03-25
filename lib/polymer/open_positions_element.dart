library open_positions_element;

import 'dart:html';

import 'package:intl/intl.dart';
import 'package:polymer/polymer.dart';

import 'package:3hgj_greed/shared.dart';
import 'package:3hgj_greed/polymer/open_position_element.dart';

@CustomTag('open-positions-element')
class OpenPositionsElement extends PolymerElement {
  OpenPositionsElement.created() : super.created();

  void createOpenPositionElement(int id, StockId stockId, OpenPosition openPosition) {
    OpenPositionElement op = new Element.tag('open-position-element');
    op.id = 'op_${id}';
    op.amount = openPosition.amount;
    op.symbol = stockId.symbol;
    op.name = stockId.name;
    op.margin = openPosition.margin;
    op.leverage = openPosition.leverage;
    op.profitOrLoss = openPosition.profitOrLoss;
    shadowRoot.querySelector('#container').append(op);
  }

  void updateProfitLoss(int id, double profitOrLoss) {
    OpenPositionElement op = shadowRoot.querySelector('#op_${id}');
    op.profitOrLoss = profitOrLoss;
  }
}