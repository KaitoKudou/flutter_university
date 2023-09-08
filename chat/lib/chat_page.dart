import 'package:chat/post.dart';
import 'package:chat/providers/auth_provider.dart';
import 'package:chat/providers/posts_provider.dart';
import 'package:chat/providers/posts_reference_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final controller = TextEditingController();

  Future<void> sendPost(String text) async {
    final user = ref.watch(userProvider).value!; // ログイン中のユーザーデータを取得
    final posterId = user.uid; // ログイン中のユーザーのID
    final posterName = user.displayName!; // Googleアカウントの名前
    final posterImageUrl = user.photoURL!; // Googleアカウントのアイコンデータ

    // doc の引数を空にするとランダムなIDが採番される
    final newPost = Post(
        text: text,
        createdAt: Timestamp.now(),
        // 投稿日時は現在とする
        posterName: posterName,
        posterImageUrl: posterImageUrl,
        posterId: posterId,
        reference: ref.read(postsReferenceProvider).doc());

    // set関数を実行するとそのドキュメントにデータが保存される
    // 通常は Map しか受け付けないが、
    // withConverter を使用したことにより Post インスタンスを受け取り可能
    await newPost.reference.set(newPost);
  }

  /// この dispose 関数はこのWidgetが使われなくなったときに実行される
  @override
  void dispose() {
    super.dispose();
    // TextEditingController は使われなくなったら必ず dispose する必要がある
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold 全体を GestureDetector で囲むことでタップ可能になる
    return GestureDetector(
      onTap: () {
        // キーボードを閉じる
        primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('チャット'),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  //return const MyPage();
                  return const ChatPage();
                }));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    ref.watch(userProvider).value!.photoURL!,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ref.watch(postsProvider).when(data: (data) {
                /// 値が取得できた場合に呼ばれる
                return ListView.builder(
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      final post = data.docs[index].data();
                      return PostWidget(post: post);
                    });
              }, error: (_, __) {
                /// 読み込み中にErrorが発生した場合に呼ばれる
                return const Center(
                  child: Text('不具合が発生しました。'),
                );
              }, loading: () {
                /// 読み込み中の場合に呼ばれる
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  // 未選択時の枠線
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.amber),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // 選択時の枠線
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.amber,
                      width: 2,
                    ),
                  ),
                  fillColor: Colors.amber[50],
                  filled: true,
                ),
                onFieldSubmitted: (text) {
                  sendPost(text);
                  controller.clear();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostWidget extends ConsumerWidget {
  const PostWidget({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.read(uidProvider).value ?? '';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(post.posterImageUrl),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 投稿文
                    Text(
                      post.posterName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),

                    // 投稿日時
                    Text(
                      DateFormat('MM/dd HH:mm').format(post.createdAt.toDate()),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 投稿文
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: uid == post.posterId
                            ? Colors.amber[100]
                            : Colors.blue[100],
                      ),
                      child: Text(post.text),
                    ),

                    // 編集ボタン
                    // List の中の場合は if 文であっても {} この波かっこはつけなくてよい
                    if (uid == post.posterId)
                      Row(
                        children: [
                          // 編集ボタン
                          if (uid == post.posterId)
                            IconButton(
                              onPressed: () {
                                //　ダイアログを表示する場合は `showDialog` 関数を実行
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: TextFormField(
                                          initialValue: post.text,
                                          autofocus: true,
                                          onFieldSubmitted: (newText) {
                                            post.reference
                                                .update({'text': newText});
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      );
                                    });
                              },
                              icon: const Icon(Icons.edit),
                            ),

                          // 削除ボタン
                          IconButton(
                            onPressed: () {
                              // 削除は reference に対して delete() を呼ぶだけ
                              post.reference.delete();
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
