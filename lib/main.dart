import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restekueche/config/dependencies.dart';
import 'package:restekueche/routing/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


const bool useLocal = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: useLocal
    ? 'http://10.0.2.2:54321'
    : 'https://iczbgmlougcwphjecufo.supabase.co',
    publishableKey: useLocal
    ? 'sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH'
    : 'sb_publishable_pmr2ZU4NzHmVUgveFxPjrw_FbxVzyzf',
  );
  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router(),
    );
  }
}
