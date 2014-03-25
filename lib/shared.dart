library shared;

import 'dart:math';
export 'dart:math';
import 'dart:collection';

import 'package:gamedev_helpers/gamedev_helpers_shared.dart';
import 'package:event_bus/event_bus.dart';

part 'src/shared/business.dart';
part 'src/shared/components.dart';
part 'src/shared/event_payload.dart';
part 'src/shared/manager.dart';

part 'src/shared/systems/logic.dart';

Random random = new Random();
EventBus eventBus = new EventBus();

var maxPosRelativeChange = 0.0;
var maxNegRelativeChange = 0.0;

final EventType<OrderExecution> orderExecutionEvent = new EventType<OrderExecution>();
final EventType<ToggleGraph> toggleGraphEvent = new EventType<ToggleGraph>();
