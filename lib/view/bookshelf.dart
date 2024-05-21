import 'package:flutter/material.dart';

class BookshelfView extends StatelessWidget {
  const BookshelfView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('本棚'),
      ),
      body: const Center(
          child: Text('本棚', style: TextStyle(fontSize: 32.0))),
    );
  }
}