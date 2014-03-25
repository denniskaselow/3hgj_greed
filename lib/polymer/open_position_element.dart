library open_position_element;

import 'package:polymer/polymer.dart';

@CustomTag('open-position-element')
class OpenPositionElement extends PolymerElement {
  @observable String symbol;
  @observable String name;
  @observable int amount;
  @observable int leverage;
  @observable double margin;
  @observable double profitOrLoss;
  OpenPositionElement.created() : super.created();
}