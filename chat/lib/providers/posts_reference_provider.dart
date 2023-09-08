import 'package:chat/post.dart';
import 'package:chat/providers/firestore_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postsReferenceProvider = Provider((ref) {
  final firestore = ref.read(firestoreProvider);
  return firestore.collection('post').withConverter<Post>(
      fromFirestore: (snapshot, _) {
        return Post.fromFirestore(snapshot);
      },
      toFirestore: (post, _) {
        return post.toMap();
      }
  );
});