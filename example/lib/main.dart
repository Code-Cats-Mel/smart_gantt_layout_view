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
                  events: const [
                    (left: 0.0, length: 0.1),
                    (left: 0.2, length: 0.2),
                    (left: 0.5, length: 0.1),
                    (left: 0.7, length: 0.1),
                  ],
                  ganttCardBuilder: (index) {
                    return const Line(
                      // height: 10,
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

class Line extends StatelessWidget {
  final double? height;
  final double width;
  final Color color;
  final double circularRadius;

  const Line({super.key, this.height, required this.width, required this.color})
      : circularRadius =
            (height != null && width > height) ? height / 2 : width / 2;

  @override
  Widget build(BuildContext context) {
    print('width: $width, height: $height, circularRadius: $circularRadius');
    return Container(
      // height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(circularRadius)),
      ),
    );
  }
}
