import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_account.dart';

final userProvider = StreamProvider<UserAccount?>(
  (ref) => const Stream<UserAccount?>.empty(),
);