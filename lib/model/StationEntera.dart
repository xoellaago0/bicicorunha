import 'dart:io';

import 'package:bicicorunha/model/Station.dart';
import 'package:bicicorunha/model/StationStatus.dart';

class Stationentera {
  Station info;
  Stationstatus estado;
  bool isExpanded = false;

  Stationentera({
    required this.info,
    required this.estado,
    this.isExpanded = false,
  });
}
