import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/collection.dart';

final collectionProvider = StreamProvider<List<Collection>>(
  (ref) => const Stream<List<Collection>>.empty(),
);