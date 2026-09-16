import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/report.dart';

final reportProvider = StreamProvider<List<Report>>(
  (ref) => const Stream<List<Report>>.empty(),
);