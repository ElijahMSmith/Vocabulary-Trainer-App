import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vocab_trainer_app/misc/colors.dart';
import 'package:vocab_trainer_app/misc/db_helper.dart';
import 'package:vocab_trainer_app/misc/shared_preferences_helper.dart';
import 'package:vocab_trainer_app/models/term.dart';
import 'package:vocab_trainer_app/pages/enter.dart';
import 'package:vocab_trainer_app/pages/practice.dart';
import 'package:vocab_trainer_app/pages/search.dart';
import 'package:vocab_trainer_app/pages/settings.dart';
import 'package:vocab_trainer_app/widgets/miscellaneous/splash.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Jost",
        fontFamilyFallback: const ["Arial"],
      ),
      home: const Framework(),
    );
  }
}

class Framework extends StatefulWidget {
  const Framework({super.key});

  @override
  State<Framework> createState() => _FrameworkState();
}

class _FrameworkState extends State<Framework> {
  DBHelper db = DBHelper();
  bool appReady = false;

  late PageController _pageController;
  int _pageIndex = 1;

  List<Term> _currentTerms = [];

  @override
  void initState() {
    _pageController = PageController(initialPage: _pageIndex, keepPage: true);
    performAsyncSetup();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> performAsyncSetup() async {
    await SPHelper.initializeSP();

    await db.openDB();
    _currentTerms.addAll(await db.getAllTerms());

    // TODO: await loadLanguagesList();

    setState(() {
      appReady = true;
    });
  }

  void _handleTap(int index) {
    setState(() {
      _pageIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    });
  }

  void _updateCurrentTerms({List<Term>? newTermsList}) {
    setState(() {
      if (newTermsList != null) _currentTerms = newTermsList;
    });
  }

  BottomNavigationBarItem createNavigationBarItem(
      IconData type, String label, int index) {
    const SIZE_ACTIVE = 35.0;
    const SIZE_INACTIVE = 30.0;

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Icon(
          type,
          size: _pageIndex == index ? SIZE_ACTIVE : SIZE_INACTIVE,
        ),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!appReady) return const SplashScreen();
    return Scaffold(
      backgroundColor: ThemeColors.accent,
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _pageIndex = index);
          },
          children: [
            Enter(
                currentTerms: _currentTerms, updateTerms: _updateCurrentTerms),
            Home(currentTerms: _currentTerms, updateTerms: _updateCurrentTerms),
            Search(
                currentTerms: _currentTerms, updateTerms: _updateCurrentTerms),
            Settings(
                currentTerms: _currentTerms, updateTerms: _updateCurrentTerms),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(.25))
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              createNavigationBarItem(Icons.add_circle_rounded, "Enter", 0),
              createNavigationBarItem(
                  Icons.fitness_center_rounded, "Practice", 1),
              createNavigationBarItem(Icons.search_rounded, "Search", 2),
              createNavigationBarItem(Icons.settings_rounded, "Settings", 3),
            ],
            type: BottomNavigationBarType.fixed,
            onTap: _handleTap,
            currentIndex: _pageIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: ThemeColors.secondary,
            unselectedItemColor: ThemeColors.black.withOpacity(.2),
          ),
        ),
      ),
    );
  }
}
