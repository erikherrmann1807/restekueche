import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restkueche/routing/routes.dart';

class FoodScanScreen extends StatefulWidget {
  const FoodScanScreen({super.key});

  @override
  State<FoodScanScreen> createState() => _FoodScanScreenState();
}

class _FoodScanScreenState extends State<FoodScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Food Scan')
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (diPop, r) {
                if (diPop) {
                  return;
                }
                context.go(Routes.home);
              },
              child: Column(
                children: [
                  const Text('Food Scan'),
                  TextButton(
                      onPressed: () => context.go(Routes.home),
                      child: const Text('Home')
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}
