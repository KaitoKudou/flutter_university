import 'package:flutter/material.dart';
import 'package:life_counter/AddLifeEventPage.dart';
import 'package:life_counter/life_event.dart';
import 'package:life_counter/objectbox.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LifeCounterPage(),
    );
  }
}

class LifeCounterPage extends StatefulWidget {
  const LifeCounterPage({Key? key}) : super(key: key);

  @override
  State<LifeCounterPage> createState() => _LifeCounterPageState();
}

class _LifeCounterPageState extends State<LifeCounterPage> {
  Store? store;
  Box<LifeEvent>? lifeEventBox;
  List<LifeEvent> lifeEvents = [];

  Future<void> initialize() async {
    store = await openStore();
    lifeEventBox = store?.box<LifeEvent>();
    fetchLifeEvents();
  }

  void fetchLifeEvents() {
    lifeEvents = lifeEventBox?.getAll() ?? [];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('人生カウンター'),
      ),
      body: ListView.builder(
        itemCount: lifeEvents.length,
        itemBuilder: (context, index) {
          final lifeEvent = lifeEvents[index];
          return Row(
            children: [
              Expanded(
                child: Text(
                  lifeEvent.title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                '${lifeEvent.count}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              IconButton(
                onPressed: () {
                  lifeEvent.count--;
                  if (lifeEvent.count < 0) {
                    lifeEvent.count = 0;
                  }
                  lifeEventBox?.put(lifeEvent);
                  fetchLifeEvents();
                },
                icon: const Icon(Icons.exposure_minus_1),
              ),
              IconButton(
                onPressed: () {
                  lifeEvent.count++;
                  lifeEventBox?.put(lifeEvent);
                  fetchLifeEvents();
                },
                icon: const Icon(Icons.plus_one),
              ),
              IconButton(
                  onPressed: () {
                    lifeEventBox?.remove(lifeEvent.id);
                    fetchLifeEvents();
                  },
                  icon: const Icon(Icons.delete),
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newLifeEvent = await Navigator.of(context).push<LifeEvent>(
            MaterialPageRoute(
              builder: (context) {
                return const AddLifeEventPage();
              },
            ),
          );
          if (newLifeEvent != null) {
            lifeEventBox?.put(newLifeEvent);
            fetchLifeEvents();
          }
        },
      ),
    );
  }
}
