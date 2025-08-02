import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class Mappage extends StatefulWidget {
  const Mappage({super.key});

  @override
  _MappageState createState() => _MappageState();
}

class _MappageState extends State<Mappage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(),
            children: [],
          ),
        ],
      ),
    );
  }
}
