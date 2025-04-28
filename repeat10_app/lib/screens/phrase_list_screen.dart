import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/phrase.dart';

class PhraseListScreen extends StatefulWidget {
  const PhraseListScreen({Key? key}) : super(key: key);

  @override
  State<PhraseListScreen> createState() => _PhraseListScreenState();
}

class _PhraseListScreenState extends State<PhraseListScreen> {
  List<Phrase> _phrases = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPhrases();
  }

  Future<void> _loadPhrases() async {
    final phrases = await DatabaseHelper.instance.getPhrases();
    setState(() {
      _phrases = phrases;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frases'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _phrases.length,
              itemBuilder: (context, index) {
                final phrase = _phrases[index];
                return ListTile(
                  title: Text(phrase.text),
                  subtitle: Text(phrase.type),
                );
              },
            ),
    );
  }
} 