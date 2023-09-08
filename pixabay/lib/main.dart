import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PixabayPage(),
    );
  }
}

class PixabayPage extends StatefulWidget {
  const PixabayPage({Key? key}) : super(key: key);

  @override
  State<PixabayPage> createState() => _PixabayPageState();
}

class _PixabayPageState extends State<PixabayPage> {
  List<PixabayImage> pixabayImages = [];

  // 非同期の関数になったため返り値の型にFutureがつき、さらに async キーワードがつく
  Future<void> fetchImages(String text) async {
    final response =
        await Dio().get('https://pixabay.com/api/', queryParameters: {
      'key': '38892907-97658ed8adf42ef9b85633852',
      'q': text,
      'image_type': 'photo',
      'per_page': 100
    });
    final List hits =
        response.data['hits']; // この時点では要素の中身の型は Map<String, dynamic>
    // map メソッドを使って Map<String, dynamic> の型を一つひとつ PixabayImage 型に変換
    pixabayImages = hits.map((e) => PixabayImage.fromMap(e)).toList();
    setState(() {});
  }

  Future<void> shareImage(String url) async {
    // 一時保存に使えるフォルダ情報を取得
    final directory = await getTemporaryDirectory();
    final response = await Dio().get(
      url,
      options: Options(
        // 画像をダウンロードするときは ResponseType.bytes を指定
        responseType: ResponseType.bytes,
      ),
    );

    // フォルダの中に image.png という名前でファイルを作り、そこに画像データを保存
    final imageFile =
        await File('${directory.path}/image.png').writeAsBytes(response.data);
    final xFile = XFile(imageFile.path);
    await Share.shareXFiles([xFile]);
  }

  // この関数の中の処理は初回に一度だけ実行される
  @override
  void initState() {
    super.initState();
    fetchImages('花');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
          ),
          onFieldSubmitted: (text) {
            print(text);
            fetchImages(text);
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 横に並べる個数
        ),
        itemCount: pixabayImages.length,
        itemBuilder: (content, index) {
          final pixabayImage = pixabayImages[index];
          return InkWell(
            onTap: () async {
              shareImage(pixabayImage.webformatURL);
            },
            child: Stack(
              fit: StackFit.expand, // 領域いっぱいに広げる
              children: [
                Image.network(
                  pixabayImage.previewURL,
                  fit: BoxFit.cover, // 領域いっぱいに広げる
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.thumb_up_alt_outlined,
                          size: 14,
                        ),
                        Text('${pixabayImage.likes}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PixabayImage {
  final String previewURL;
  final int likes;
  final String webformatURL;

  PixabayImage(
      {required this.previewURL,
      required this.likes,
      required this.webformatURL});

  factory PixabayImage.fromMap(Map<String, dynamic> map) {
    return PixabayImage(
      previewURL: map['previewURL'],
      likes: map['likes'],
      webformatURL: map['webformatURL'],
    );
  }
}
