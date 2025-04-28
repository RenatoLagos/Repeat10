import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/phrase.dart';
import '../services/database_helper.dart';
import 'phrase_list_screen.dart';

class LoadingScreen extends StatefulWidget {
  final UserProfile profile;
  const LoadingScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _generateAndSavePhrases();
  }

  Future<void> _generateAndSavePhrases() async {
    final List<Phrase> phrases = [];
    // 50 profile-based phrases
    phrases.addAll(_generateProfilePhrases(widget.profile, 50));
    // 20 common phrases based on region
    phrases.addAll(_generateCommonPhrases(widget.profile.englishType, 20));
    // 20 idioms
    phrases.addAll(_generateIdioms(20));
    // 10 random phrases
    phrases.addAll(_generateRandomPhrases(10));

    // Insert into database
    await DatabaseHelper.instance.insertPhrases(phrases);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PhraseListScreen()),
    );
  }

  List<Phrase> _generateProfilePhrases(UserProfile profile, int count) {
    final list = <Phrase>[];
    for (int i = 1; i <= count; i++) {
      final text = 'Como ${profile.profession}, disfruto de ${profile.hobbies} y quiero ingles para ${profile.motivation}.';
      list.add(Phrase(text: text, type: 'profile'));
    }
    return list;
  }

  List<Phrase> _generateCommonPhrases(String region, int count) {
    final Map<String, List<String>> commonMap = {
      'USA': [
        'Hello!', 'How are you?', 'Good morning.', 'Good afternoon.', 'Good evening.',
        'Thank you.', 'Please.', 'Excuse me.', 'I\'m sorry.', 'See you later.',
        'Have a great day.', 'What\'s your name?', 'I don\'t understand.', 'Can you help me?',
        'Where is the bathroom?', 'Can I get the bill, please?', 'I need directions.',
        'I\'m looking for a restaurant.', 'What\'s the time?', 'I\'d like a cup of coffee.'
      ],
      'UK': [
        'Hello!', 'How are you?', 'Good morning.', 'Good afternoon.', 'Good evening.',
        'Thank you.', 'Please.', 'Excuse me.', 'I\'m sorry.', 'See you later.',
        'Have a lovely day.', 'What\'s your name?', 'I don\'t understand.', 'Can you help me?',
        'Where is the loo?', 'Could I have the bill, please?', 'I need directions.',
        'I\'m looking for a pub.', 'What\'s the time?', 'I\'d like a cup of tea.'
      ],
      'AUD': [
        'G\'day mate!', 'How are you going?', 'Good morning.', 'Good afternoon.', 'Good evening.',
        'Thanks heaps.', 'Please.', 'Excuse me.', 'I\'m sorry.', 'See you later.',
        'Have a great arvo.', 'What\'s your name?', 'I don\'t follow.', 'Can you help me?',
        'Where\'s the dunny?', 'Can I get the bill, please?', 'I need directions.',
        'I\'m looking for a café.', 'What\'s the time?', 'I\'d like a flat white.'
      ],
    };
    final list = commonMap[region] ?? commonMap['USA']!;
    return list.take(count).map((t) => Phrase(text: t, type: 'common')).toList();
  }

  List<Phrase> _generateIdioms(int count) {
    const idioms = [
      'Break the ice', 'Hit the sack', 'Piece of cake', 'Once in a blue moon', 'When pigs fly',
      'Cost an arm and a leg', 'Bite the bullet', 'The ball is in your court',
      'Don\'t count your chickens before they hatch', 'Let the cat out of the bag', 'Spill the beans',
      'Hit the nail on the head', 'Under the weather', 'Burn the midnight oil', 'Kick the bucket',
      'Pull someone\'s leg', 'A dime a dozen', 'Beat around the bush', 'Break a leg', 'Call it a day'
    ];
    return idioms.take(count).map((t) => Phrase(text: t, type: 'idiom')).toList();
  }

  List<Phrase> _generateRandomPhrases(int count) {
    const randoms = [
      'He never skips leg day at the gym.', 'I love going for long hikes in the mountains.',
      'Feel free to ping me anytime you get stuck.', 'Could you lower the heat?', 'It slipped my mind.',
      'Let\'s sync up our calendars for the workshop.', 'Let\'s grab a coffee sometime.',
      'I optimized the CSS selectors.', 'We\'re laying the groundwork for a new microservice.',
      'We ran out of coffee.'
    ];
    return randoms.take(count).map((t) => Phrase(text: t, type: 'random')).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generando Frases')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando frases...'),
          ],
        ),
      ),
    );
  }
} 