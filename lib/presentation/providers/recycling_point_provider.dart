import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/recycling_point.dart';

final recyclingPointProvider = StreamProvider<List<RecyclingPoint>>(
  (ref) => const Stream<List<RecyclingPoint>>.empty(),
);