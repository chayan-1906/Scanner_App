import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scanner App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color(0xFF192A56),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> itemsList = [
    'Text Scanner',
    'Barcode Scanner',
    'Label Scanner',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scanner',
          style: GoogleFonts.getFont(
            'Lora',
            fontSize: 22.0,
            fontWeight: FontWeight.w600,
            color: Colors.lightBlueAccent,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: itemsList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5.0,
            child: ListTile(
              tileColor: Colors.blueGrey.shade50,
              title: Text(
                itemsList[index],
                style: GoogleFonts.getFont(
                  'Lora',
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailsScreen(),
                    settings: RouteSettings(arguments: itemsList[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
