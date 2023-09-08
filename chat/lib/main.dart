import 'package:chat/chat_page.dart';
import 'package:chat/providers/auth_provider.dart';
import 'package:chat/providers/firestore_provider.dart';
import 'package:chat/sign_in_page.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // runApp 前に何かを実行したいときに必要
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      overrides: [
        /// FirebaseFirestoreのモックを注入
        firestoreProvider.overrideWithValue(FakeFirebaseFirestore()),
        firebaseAuthProvider.overrideWithValue(
          MockFirebaseAuth(
            signedIn: true,
            mockUser: MockUser(
              isAnonymous: false,
              uid: 'someuid',
              email: 'sample@gmail.com',
              displayName: '山田　太郎',
              photoURL: 'https://1.bp.blogspot.com/-yNEMpyTyX3o/X7zMjPLJdjI/AAAAAAABcdE/ZjQGxrQ2yQU5CATJhEOXrqr4cU8r7GRbwCNcBGAsYHQ/s726/shibasuberi_danbo-ru_boy.png'
            )
          )
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(),
      home: ref.watch(userProvider).maybeWhen(data: (data) {
        if (data == null) {
          return const SignInPage();
        }
        return const ChatPage();
      }, orElse: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
