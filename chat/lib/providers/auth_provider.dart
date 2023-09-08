import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider((ref) {
  return FirebaseAuth.instance;
});

final userProvider = StreamProvider((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  return firebaseAuth.userChanges();
});

final uidProvider = StreamProvider((ref) {
  final userAsyncValue = ref.watch(userProvider);

  // AsyncValueからストリームを取得し、そのストリームをマップ
  final uidStream = userAsyncValue.when(
    data: (user) => Stream.value(user?.uid),
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
  return uidStream;
});