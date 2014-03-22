library shared;

import 'dart:math';
export 'dart:math';
import 'dart:collection';

import 'package:gamedev_helpers/gamedev_helpers_shared.dart';

part 'src/shared/components.dart';

//part 'src/shared/systems/name.dart';
part 'src/shared/systems/logic.dart';

Random random = new Random();

var maxPosRelativeChange = 0.0;
var maxNegRelativeChange = 0.0;