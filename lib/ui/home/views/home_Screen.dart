import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restkueche/routing/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () => context.go(Routes.food_scan),
                child: const Text('Scanner')
            ),
            TextButton(
                onPressed: () => context.go(Routes.recipes),
                child: const Text('Recipes')
            ),
          ],
        ),
      ),
    );
  }
}