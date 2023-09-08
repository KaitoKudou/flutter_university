import 'package:objectbox/objectbox.dart';

@Entity()
class LifeEvent {
  int id = 0;
  String title; /// イベント名
  int count; /// イベントの回数

  LifeEvent({
    required this.title,
    required this.count,
  });
}
