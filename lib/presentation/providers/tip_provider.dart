import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/tip.dart';

final tipProvider = StreamProvider<List<Tip>>(
  (ref) => const Stream<List<Tip>>.empty(),
);