import 'package:flutter/material.dart';
import 'package:sttdemo/views/home_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech to Text Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: HomeView(),
    );
  }
}
