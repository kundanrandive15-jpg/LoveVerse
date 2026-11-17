
import 'package:flutter/material.dart';

void main() {
  runApp(const LoveVerseApp());
}

class Story {
  final String title;
  final String description;
  final String category;
  final String emoji;

  const Story({
    required this.title,
    required this.description,
    required this.category,
    required this.emoji,
  });
}

const List<Story> stories = [
  Story(
    title: 'My Childhood Love',
    description: 'A childhood friendship that may become something more.',
    category: 'College Romance',
    emoji: '💗',
  ),
  Story(
    title: 'The Billionaire’s Daughter',
    description: 'An unexpected meeting with a wealthy businesswoman’s daughter.',
    category: 'Rich Lifestyle',
    emoji: '✨',
  ),
  Story(
    title: 'A Second Chance',
    description: 'Two former lovers become neighbours again after two years.',
    category: 'Emotional Romance',
    emoji: '🌙',
  ),
];

class LoveVerseApp extends StatefulWidget {
  const LoveVerseApp({super.key});

  @override
  State<LoveVerseApp> createState() => _LoveVerseAppState();
}

class _LoveVerseAppState extends State<LoveVerseApp> {
  ThemeMode themeMode = ThemeMode.light;
  String language = 'Hinglish';

  void changeTheme(bool dark) {
    setState(() {
      themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void changeLanguage(String value) {
    setState(() {
      language = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LoveVerse',
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Color(0xFFE5E5E5),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          onPrimary: Colors.black,
          surface: Colors.black,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Colors.black,
          indicatorColor: Color(0xFF333333),
        ),
      ),
      home: AppShell(
        themeMode: themeMode,
        language: language,
        onThemeChanged: changeTheme,
        onLanguageChanged: changeLanguage,
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  final ThemeMode themeMode;
  final String language;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<String> onLanguageChanged;

  const AppShell({
    super.key,
    required this.themeMode,
    required this.language,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;
  String userName = 'You';

  final List<String> pageTitles = [
    'LoveVerse',
    'Search',
    'Chats',
    'Profile',
  ];

  void openPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        userName: userName,
        language: widget.language,
      ),
      const SearchPage(),
      const ChatsPage(),
      ProfilePage(
        userName: userName,
        onNameChanged: (value) {
          setState(() => userName = value);
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitles[selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'App Comments',
            icon: const Icon(Icons.forum_outlined),
            onPressed: () => openPage(const FeedbackPage()),
          ),
        ],
      ),
      drawer: AppDrawer(
        themeMode: widget.themeMode,
        language: widget.language,
        onThemeChanged: widget.onThemeChanged,
        onLanguageChanged: widget.onLanguageChanged,
        onOpen: (page) {
          Navigator.pop(context);
          openPage(page);
        },
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final ValueChanged<Widget> onOpen;
  final ThemeMode themeMode;
  final String language;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<String> onLanguageChanged;

  const AppDrawer({
    super.key,
    required this.onOpen,
    required this.themeMode,
    required this.language,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'LoveVerse',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _item(context, Icons.bookmark_outline, 'Saved Stories'),
            _item(context, Icons.history, 'Recently Viewed'),
            _item(
              context,
              Icons.language,
              'Language Settings',
              page: LanguagePage(
                language: language,
                onLanguageChanged: onLanguageChanged,
              ),
            ),
            _item(
              context,
              Icons.palette_outlined,
              'Theme Settings',
              page: ThemePage(
                themeMode: themeMode,
                onThemeChanged: onThemeChanged,
              ),
            ),
            _item(context, Icons.notifications_outlined, 'Notifications'),
            _item(
              context,
              Icons.settings_outlined,
              'Settings',
              page: const SettingsPage(),
            ),
            _item(context, Icons.security_outlined, 'Privacy & Security'),
            _item(
              context,
              Icons.info_outline,
              'About LoveVerse',
              page: const AboutPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String title, {
    Widget? page,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        if (page != null) {
          onOpen(page);
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title will be available in a future update.'),
            ),
          );
        }
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final String userName;
  final String language;

  const HomePage({
    super.key,
    required this.userName,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'YOUR STORY. YOUR CHOICES.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Enter a world\nof endless stories.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Welcome, $userName 👋',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const Text(
          'Choose Your Story',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'Your choices shape every moment.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        ...stories.map(
          (story) => StoryCard(
            story: story,
            language: language,
          ),
        ),
      ],
    );
  }
}

class StoryCard extends StatelessWidget {
  final Story story;
  final String language;

  const StoryCard({
    super.key,
    required this.story,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark ? const Color(0xFF171717) : Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
        side: BorderSide(
          color: isDark ? Colors.white24 : Colors.black12,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: Colors.grey.withOpacity(0.15),
          child: Text(
            story.emoji,
            style: const TextStyle(fontSize: 23),
          ),
        ),
        title: Text(
          story.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(story.description),
              const SizedBox(height: 7),
              Text(
                story.category.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StoryChatPage(
                story: story,
                language: language,
              ),
            ),
          );
        },
      ),
    );
  }
}

class StoryChatPage extends StatefulWidget {
  final Story story;
  final String language;

  const StoryChatPage({
    super.key,
    required this.story,
    required this.language,
  });

  @override
  State<StoryChatPage> createState() => _StoryChatPageState();
}

class _StoryChatPageState extends State<StoryChatPage> {
  final TextEditingController controller = TextEditingController();
  final List<Map<String, String>> messages = [];

  void sendMessage() {
    final value = controller.text.trim();
    if (value.isEmpty) return;

    setState(() {
      messages.add({'text': value, 'type': 'user'});
      messages.add({
        'text': 'AI connection is not configured yet. This is a demo reply.',
        'type': 'character',
      });
    });

    controller.clear();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.story.title)),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Your Choices. Your Journey.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text(
                        'Your story opening will be added here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isUser = message['type'] == 'user';

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width * 0.82,
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Colors.black
                                : Colors.grey.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: Text(
                            message['text']!,
                            style: TextStyle(
                              color: isUser
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface,
                              height: 1.5,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 4,
                      onSubmitted: (_) => sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Write your response...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send),
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

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = '';

  final List<Map<String, String>> stories = [
    {
      'title': 'My Childhood Love',
      'category': 'Romance',
      'description': 'A beautiful story of childhood friendship and love.'
    },
    {
      'title': 'College Love',
      'category': 'College Romance',
      'description': 'A new beginning, unexpected meetings and feelings.'
    },
    {
      'title': 'Second Chance',
      'category': 'Romance',
      'description': 'Two hearts meet again after years apart.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final results = stories.where((story) {
      return story['title']!
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          story['category']!
              .toLowerCase()
              .contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Search Stories')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search stories...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: results.isEmpty
                  ? const Center(child: Text('No stories found'))
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final story = results[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.favorite_outline),
                            title: Text(story['title']!),
                            subtitle: Text(story['description']!),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 55),
            SizedBox(height: 12),
            Text(
              'Your conversations will appear here.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          CircleAvatar(
            radius: 45,
            child: Icon(Icons.person, size: 50),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              'Welcome to LoveVerse',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 24),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Personal Information'),
          ),
          ListTile(
            leading: Icon(Icons.bookmark_outline),
            title: Text('Saved Stories'),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Recently Viewed'),
          ),
        ],
      ),
    );
  }
}

class LanguagePage extends StatelessWidget {
  final String language;
  final ValueChanged<String> onLanguageChanged;

  const LanguagePage({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language Settings')),
      body: ListView(
        children: [
          RadioListTile<String>(
            title: const Text('Hinglish'),
            subtitle: const Text('Hindi in English letters'),
            value: 'Hinglish',
            groupValue: language,
            onChanged: (value) {
              if (value != null) onLanguageChanged(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('Minglish'),
            subtitle: const Text('Marathi in English letters'),
            value: 'Minglish',
            groupValue: language,
            onChanged: (value) {
              if (value != null) onLanguageChanged(value);
            },
          ),
          RadioListTile<String>(
            title: const Text('English'),
            value: 'English',
            groupValue: language,
            onChanged: (value) {
              if (value != null) onLanguageChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

class ThemePage extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const ThemePage({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Settings')),
      body: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: const Text('Light Mode'),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) onThemeChanged(value);
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark Mode'),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) onThemeChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Notifications'),
          ),
          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Privacy & Security'),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About LoveVerse'),
          ),
        ],
      ),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController controller = TextEditingController();

  final List<String> comments = [];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void postComment() {
    final message = controller.text.trim();

    if (message.isEmpty) return;

    setState(() {
      comments.insert(0, message);
      controller.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback added in this demo')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Comments & Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Write your feedback...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: postComment,
                child: const Text('Post Feedback'),
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Feedback',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: comments.isEmpty
                  ? const Center(
                      child: Text('No feedback yet'),
                    )
                  : ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.person_outline),
                            title: Text(comments[index]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About LoveVerse')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, size: 65),
            SizedBox(height: 16),
            Text(
              'LoveVerse',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Your Choices. Your Journey.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 16),
            Text(
              'LoveVerse is an interactive story experience where every choice shapes your journey.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text('Version 1.0.0'),
          ],
        ),
      ),
    );
  }
}

