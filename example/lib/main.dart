import 'package:flutter/material.dart';
import 'package:smart_gantt_layout_view/smart_gantt_layout_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: 100,
                width: 300,
                child: SmartGanttLayoutView(
                  algorithmType: GanttLayoutAlgorithmType.smartSpacing,
                  events: const [
                    (left: 0, length: 0.2),
                    (left: 0.1, length: 0.5),
                    (left: 0.3, length: 0.2),
                    (left: 0.3, length: 0.2),
                    (left: 0.7, length: 0.05),
                    (left: 0.7, length: 0.2),
                    (left: 0.8, length: 0.05),
                  ],
                  ganttCardBuilder: (index) {
                    return GanttCard(
                      index + 1,
                      width: double.infinity,
                      color: Colors.red,
                    );
                  },
                ),
              ),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class GanttCard extends StatelessWidget {
  final int index;
  final double? height;
  final double width;
  final Color color;

  const GanttCard(this.index,
      {super.key, this.height, required this.width, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: color,
      child: Text('$index'),
    );
  }
}
