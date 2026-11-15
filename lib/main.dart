import 'package:flutter/material.dart';

void main() => runApp(const LoveVerseApp());

class LoveVerseApp extends StatefulWidget {
  const LoveVerseApp({super.key});

  @override
  State<LoveVerseApp> createState() => _LoveVerseAppState();
}

class _LoveVerseAppState extends State<LoveVerseApp> {
  String userName = 'You';
  String language = 'हिंदी';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LoveVerse',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF100D18),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB77AFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(
        userName: userName,
        language: language,
        onNameChanged: (value) => setState(() => userName = value),
        onLanguageChanged: (value) => setState(() => language = value),
      ),
    );
  }
}

class Story {
  final String title;
  final String subtitle;
  final String emoji;
  final String category;
  final String opening;

  const Story(this.title, this.subtitle, this.emoji, this.category, this.opening);
}

const stories = <Story>[
  Story(
    'My Childhood Love',
    'एक जुनी मैत्री… मनात दडलेलं प्रेम',
    '💗',
    'College Romance',
    'कॉलेजचा पहिला दिवस. कॅम्पसच्या गेटजवळ तुला अचानक रुचिका दिसते. ती हसत जवळ येते आणि म्हणते, “अरे! किती दिवसांनी भेटतोयस. आज कॉलेज संपल्यावर कॉफी प्यायला येशील का? मला तुला काहीतरी सांगायचं आहे.”',
  ),
  Story(
    'The Billionaire’s Daughter',
    'शहरातील सर्वात श्रीमंत घरातील मुलगी',
    '✨',
    'Rich Lifestyle',
    'कॉलेजच्या कॉरिडॉरमध्ये घाईत चालताना तुझी एका मुलीशी धडक होते. तिच्या हातातील पुस्तकं खाली पडतात. ती शांतपणे तुझ्याकडे पाहते. “काही हरकत नाही… पण पुढे जरा लक्ष देऊन चाल.”',
  ),
  Story(
    'A Second Chance',
    'दोन वर्षांनंतर पुन्हा समोरासमोर',
    '🌙',
    'Emotional Romance',
    'दोन वर्षांपूर्वी वेगळे झालेले तुम्ही दोघे आता एकाच अपार्टमेंटमध्ये शेजारी राहायला आला आहात. लिफ्टचं दार उघडतं… आणि समोर ती उभी असते. काही क्षण दोघेही शांत राहता.',
  ),
];

class HomeScreen extends StatelessWidget {
  final String userName;
  final String language;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onLanguageChanged;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.language,
    required this.onNameChanged,
    required this.onLanguageChanged,
  });

  void _editName(BuildContext context) {
    final controller = TextEditingController(text: userName == 'You' ? '' : userName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('तुझं नाव'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'First name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) onNameChanged(value);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoveVerse', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
        actions: [
          PopupMenuButton<String>(
            initialValue: language,
            onSelected: onLanguageChanged,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'हिंदी', child: Text('हिंदी')),
              PopupMenuItem(value: 'मराठी', child: Text('मराठी')),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Center(child: Text(language, style: const TextStyle(fontWeight: FontWeight.w600))),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF4A235F), Color(0xFF20172F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('YOUR STORY. YOUR CHOICES.', style: TextStyle(color: Color(0xFFE7C9FF), fontSize: 11, letterSpacing: 1.4)),
                const SizedBox(height: 10),
                const Text('Enter a world\nof endless stories.', style: TextStyle(fontSize: 27, height: 1.15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('Welcome, $userName 👋', style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () => _editName(context),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Set your first name'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text('Choose your story', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('तुझ्या निर्णयांनुसार कथा पुढे जाईल.', style: TextStyle(color: Colors.white60)),
          const SizedBox(height: 14),
          ...stories.map((story) => StoryCard(
                story: story,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StoryChatScreen(
                      story: story,
                      userName: userName,
                      language: language,
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'LOVEVERSE • FIRST PROTOTYPE',
              style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;

  const StoryCard({super.key, required this.story, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1D1827),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF392647),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(story.emoji, style: const TextStyle(fontSize: 27)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(story.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(story.subtitle, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    const SizedBox(height: 7),
                    Text(story.category.toUpperCase(), style: const TextStyle(color: Color(0xFFC99AFF), fontSize: 9, letterSpacing: 1)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatLine {
  final String text;
  final bool isUser;
  ChatLine(this.text, this.isUser);
}

class StoryChatScreen extends StatefulWidget {
  final Story story;
  final String userName;
  final String language;

  const StoryChatScreen({
    super.key,
    required this.story,
    required this.userName,
    required this.language,
  });

  @override
  State<StoryChatScreen> createState() => _StoryChatScreenState();
}

class _StoryChatScreenState extends State<StoryChatScreen> {
  final controller = TextEditingController();
  final scrollController = ScrollController();
  late final List<ChatLine> messages;

  @override
  void initState() {
    super.initState();
    messages = [
      ChatLine(widget.story.opening.replaceAll('तुला', widget.userName == 'You' ? 'तुला' : widget.userName), false),
    ];
  }

  void _send() {
    final value = controller.text.trim();
    if (value.isEmpty) return;
    setState(() {
      messages.add(ChatLine(value, true));
      messages.add(ChatLine(
        widget.language == 'मराठी'
            ? 'रुचिका तुझं बोलणं लक्ष देऊन ऐकते. तिच्या चेहऱ्यावर हलकंसं हसू उमटतं. “खरंच? मला तुझ्याशी अजून थोडं बोलायचं आहे…”\n\n(हा डेमो प्रतिसाद आहे. पुढील आवृत्तीत AI तुझ्या उत्तरानुसार कथा तयार करेल.)'
            : 'रुचिका तुम्हारी बात ध्यान से सुनती है। उसके चेहरे पर हल्की-सी मुस्कान आती है। “सच में? मुझे तुमसे अभी और बातें करनी हैं…”\n\n(यह डेमो जवाब है। अगले संस्करण में AI तुम्हारे जवाब के अनुसार कहानी आगे बढ़ाएगा।',
        false,
      ));
    });
    controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.story.title)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF20172F),
            child: const Text('DEMO STORY • AI CONNECTION NOT ADDED YET', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Color(0xFFE2C5FF), letterSpacing: 1)),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final message = messages[index];
                return Align(
                  alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .82),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: message.isUser ? const Color(0xFF603C7C) : const Color(0xFF252031),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Text(message.text, style: const TextStyle(height: 1.4)),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: widget.language == 'मराठी' ? 'तुझं उत्तर लिही…' : 'अपना जवाब लिखो…',
                        filled: true,
                        fillColor: const Color(0xFF252031),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _send,
                    icon: const Icon(Icons.send_rounded),
                    style: IconButton.styleFrom(backgroundColor: const Color(0xFF9C62D1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}  

