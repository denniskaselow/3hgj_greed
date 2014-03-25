library stock_element;

import 'package:canvas_query/color_tools.dart';
import 'package:intl/intl.dart';
import 'package:polymer/polymer.dart';

import 'package:3hgj_greed/shared.dart';

@CustomTag('stock-element')
class StockElement extends PolymerElement {
  final absoluteFormat = new NumberFormat('+0.000;-0.000');
  final relativeFormat = new NumberFormat('+0.00;-0.00');
  final Color _color = new Color.fromHsl(0.0, 0.0, 0.5);
  @observable String symbol;
  @observable String name;
  @observable String priceFormatted;
  @observable double initialPrice;
  @observable String absoluteChangeFormatted;
  @observable String relativeChangeFormatted;
  @observable String bgColor = 'grey';
  StockElement.created() : super.created();

  @override
  void enteredView() {
    super.enteredView();
    onMouseEnter.listen((_) => _changeLightness(0.8));
    onMouseLeave.listen((_) => _changeLightness(0.5));
    onClick.listen((_) => eventBus.fire(toggleGraphEvent, new ToggleGraph(symbol)));
  }

  void _changeLightness(double l) {
    _color.setHsl(l: l);
    bgColor = _color.toHex();
  }

  void set price(double value) {
    priceFormatted = value.toStringAsFixed(3);
  }
  void set absoluteChange(double value) {
    absoluteChangeFormatted = absoluteFormat.format(value);
  }
  void set relativeChange(double value) {
    relativeChangeFormatted = relativeFormat.format(value);
    if (value > 0.0) {
      _color.setHsl(h: 0.35, s: value / maxPosRelativeChange);
      bgColor = _color.toHex();
    } else if (value < 0.0) {
      _color.setHsl(h: 0.0, s: value / maxNegRelativeChange);
      bgColor = _color.toHex();
    }
  }
}