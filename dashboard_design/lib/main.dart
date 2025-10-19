import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Design',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Dashboard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row (logo + name + icon)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.dashboard_customize, size: 32.0),
                    const SizedBox(width: 12.0),
                    Text(
                      'Jared App',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                const Icon(Icons.notifications, size: 28.0),
              ],
            ),
            
            const SizedBox(height: 24.0),
            
            // Row with three colored cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 120,
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Center(child: Text('Card 1')),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 120,
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Center(child: Text('Card 2')),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 120,
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Center(child: Text('Card 3')),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24.0),
            
            // Two large containers in a column
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: Colors.purple.shade200,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Center(child: Text('Data Section 1')),
              ),
            ),
            
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.teal.shade300,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Center(child: Text('Data Section 2')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
