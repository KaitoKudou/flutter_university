import 'package:chat/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider).value!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('マイページ'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            // ユーザアイコン
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL!),
              radius: 40,
            ),

            // ユーザ名
            Text(
              user.displayName!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),
            
            // ユーザ名ID
            Align(
              alignment: Alignment.centerLeft, // 部分的に左寄せ
              child: Text('ユーザ名: ${user.uid}'),
            ),

            // 登録日
            Align(
                alignment: Alignment.centerLeft,
                child: Text('登録日: ${user.metadata.creationTime}')
            ),

            const SizedBox(height: 16),

            ElevatedButton(
                onPressed: () async {
                  // Google からサインアウト
                  await GoogleSignIn().signOut();
                  // Firebase からサインアウト
                  await ref.read(firebaseAuthProvider).signOut();
                  Navigator.of(context).pop();
                },
                child: const Text('サインアウト'),
            )
          ],
        ),
      ),
    );
  }
}
