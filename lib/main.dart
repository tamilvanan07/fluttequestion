import 'dart:math';
import 'package:flutter/material.dart';
import 'question_database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterQuest - Master Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF070A13),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1), // Indigo
          secondary: Color(0xFF06B6D4), // Cyan
          surface: Color(0xFF0F172A), // Slate 900
          background: Color(0xFF070A13), // Deep Space Black
          error: Color(0xFFEF4444), // Crimson Red
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainLayout(),
    );
  }
}

enum AppScreen { landing, quiz, summary, browse }

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  AppScreen _currentScreen = AppScreen.landing;
  String _selectedLevel = 'Beginner';
  List<Question> _quizQuestions = [];
  int _currentQuestionIndex = 0;
  int _selectedOptionIndex = -1;
  List<int?> _userAnswers = []; // Stores user selections
  int _score = 0;

  // Search & filter state for Browse Mode
  String _searchQuery = '';
  String _browseFilter = 'All';

  // Navigation handlers
  void _navigateTo(AppScreen screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  void _startQuiz(String level) {
    final filtered = questionDatabase.where((q) => q.category == level).toList();
    // Shuffle and pick 10 questions (or all if less than 10)
    final random = Random();
    final List<Question> selected = List.from(filtered);
    selected.shuffle(random);
    
    setState(() {
      _selectedLevel = level;
      _quizQuestions = selected.take(10).toList();
      _currentQuestionIndex = 0;
      _selectedOptionIndex = -1;
      _userAnswers = List.filled(_quizQuestions.length, null);
      _score = 0;
      _currentScreen = AppScreen.quiz;
    });
  }

  void _selectOption(int index) {
    if (_selectedOptionIndex != -1) return; // Prevent double selection
    setState(() {
      _selectedOptionIndex = index;
      _userAnswers[_currentQuestionIndex] = index;
      if (index == _quizQuestions[_currentQuestionIndex].correctOptionIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = _userAnswers[_currentQuestionIndex] ?? -1;
      });
    } else {
      _navigateTo(AppScreen.summary);
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedOptionIndex = _userAnswers[_currentQuestionIndex] ?? -1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Orbs for glow effect
          Positioned(
            top: -200,
            right: -200,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.12),
                    blurRadius: 120,
                    spreadRadius: 80,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -200,
            left: -200,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF06B6D4).withOpacity(0.12),
                    blurRadius: 120,
                    spreadRadius: 80,
                  ),
                ],
              ),
            ),
          ),
          // Main layout content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 850),
                          child: _buildActiveScreen(),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Common Custom Header
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.4),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Glowing Logo
          GestureDetector(
            onTap: () => _navigateTo(AppScreen.landing),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.insights,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFF8FAFC), Color(0xFFCBD5E1)],
                    ).createShader(bounds),
                    child: const Text(
                      'FlutterQuest',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Nav buttons
          Row(
            children: [
              _buildNavButton('Dashboard', AppScreen.landing, _currentScreen == AppScreen.landing),
              const SizedBox(width: 16),
              _buildNavButton('Browse Database', AppScreen.browse, _currentScreen == AppScreen.browse),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String title, AppScreen screen, bool isActive) {
    return TextButton(
      onPressed: () => _navigateTo(screen),
      style: TextButton.styleFrom(
        foregroundColor: isActive ? const Color(0xFF06B6D4) : const Color(0xFF94A3B8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF070A13).withOpacity(0.8),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.04),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Text(
          'FlutterQuest • Level Up Your Skills • Hostable on GitHub Pages',
          style: TextStyle(
            color: const Color(0xFF64748B),
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // Screen Routing Builder
  Widget _buildActiveScreen() {
    switch (_currentScreen) {
      case AppScreen.landing:
        return _buildLandingScreen();
      case AppScreen.quiz:
        return _buildQuizScreen();
      case AppScreen.summary:
        return _buildSummaryScreen();
      case AppScreen.browse:
        return _buildBrowseScreen();
    }
  }

  // ==================== SCREEN: LANDING ====================
  Widget _buildLandingScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        // Hero Section
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFF6366F1).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flash_on, color: Color(0xFF06B6D4), size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Ready for Flutter 3.x Interview Questions?',
                      style: TextStyle(
                        color: Color(0xFF06B6D4),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Master Flutter Development',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: const Text(
                  'Challenge yourself with custom quiz partitions matching your experience levels, complete with rigorous visual code snippets and academic explanations.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF94A3B8),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),

        // Difficulty Header
        const Text(
          'Choose Your Difficulty',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),

        // Level Cards Grid/List (Responsive layout)
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 650;
            final cardWidth = isMobile
                ? constraints.maxWidth
                : (constraints.maxWidth - 16) / 2;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _buildLevelCard(
                    title: 'Beginner Level',
                    desc: 'Core UI blocks: StatelessWidget vs StatefulWidget, layout properties, and package configurations.',
                    icon: Icons.school_outlined,
                    color: const Color(0xFF06B6D4),
                    level: 'Beginner',
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _buildLevelCard(
                    title: 'Intermediate Level',
                    desc: 'Lifecycle states, InheritedWidget data flow, async Streams/Futures, Keys, and custom painters.',
                    icon: Icons.workspace_premium_outlined,
                    color: const Color(0xFF6366F1),
                    level: 'Intermediate',
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _buildLevelCard(
                    title: 'Advanced Level',
                    desc: 'RenderObjects, repaint boundaries, Isolates, MethodChannels, and memory leaks profiling.',
                    icon: Icons.psychology_outlined,
                    color: const Color(0xFFEC4899),
                    level: 'Advanced',
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _buildLevelCard(
                    title: 'Dart & DSA',
                    desc: 'Pure logic: Two Sum, reversing lists, balanced brackets, memoized recursion, and Kadane\'s (No UI widgets).',
                    icon: Icons.code_rounded,
                    color: const Color(0xFF10B981),
                    level: 'Dart & DSA',
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 48),

        // Quick Database Stats/Shortcut Card
        _buildBrowseQuickCard(),
      ],
    );
  }

  Widget _buildLevelCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required String level,
  }) {
    return _HoverCard(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              desc,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF94A3B8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _startQuiz(level),
              style: ElevatedButton.styleFrom(
                backgroundColor: color.withOpacity(0.12),
                foregroundColor: color,
                elevation: 0,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: color.withOpacity(0.3), width: 1),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Start Challenge', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseQuickCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0F172A).withOpacity(0.6),
            const Color(0xFF1E293B).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Study Mode / Complete Database',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Skip the timed quizzes and browse all 30 Flutter concepts directly. Use key filters or query terms to expand exact code explanations at your own pace.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF94A3B8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          ElevatedButton(
            onPressed: () => _navigateTo(AppScreen.browse),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: const Color(0xFF6366F1).withOpacity(0.3),
            ),
            child: const Row(
              children: [
                Text('Browse Now', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.menu_book, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== SCREEN: QUIZ INTERFACE ====================
  Widget _buildQuizScreen() {
    if (_quizQuestions.isEmpty) return const SizedBox();

    final question = _quizQuestions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _quizQuestions.length;
    final isAnswered = _userAnswers[_currentQuestionIndex] != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8)),
              onPressed: () {
                _navigateTo(AppScreen.landing);
              },
            ),
            Text(
              '${_selectedLevel.toUpperCase()} CHALLENGE',
              style: const TextStyle(
                color: Color(0xFF06B6D4),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 12,
              ),
            ),
            Text(
              'Score: $_score/${_quizQuestions.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFF8FAFC),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Visual Progress Bar
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 6,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFF1E293B),
                    color: _currentLevelColor(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              '${_currentQuestionIndex + 1} of ${_quizQuestions.length}',
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // Question Glass Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withOpacity(0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.06),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.questionText,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                  color: Color(0xFFF8FAFC),
                ),
              ),
              if (question.codeSnippet != null) ...[
                const SizedBox(height: 20),
                _buildCodeBlock(question.codeSnippet!),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Options List
        Column(
          children: List.generate(question.options.length, (index) {
            final optionText = question.options[index];
            return _buildOptionButton(index, optionText, isAnswered, question);
          }),
        ),
        const SizedBox(height: 24),

        // Explanation & Next Button Container
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isAnswered
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Explanation box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.lightbulb_outline, size: 16, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Concept Explanation',
                                style: TextStyle(
                                  color: Color(0xFF10B981),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            question.explanation,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFE2E8F0),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Previous button if not first question
                        _currentQuestionIndex > 0
                            ? TextButton.icon(
                                onPressed: _previousQuestion,
                                icon: const Icon(Icons.arrow_back_ios_new, size: 14),
                                label: const Text('Back'),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF94A3B8),
                                ),
                              )
                            : const SizedBox(),

                        // Next/Finish Button
                        ElevatedButton(
                          onPressed: () {
                            if (_currentQuestionIndex < _quizQuestions.length - 1) {
                              setState(() {
                                _currentQuestionIndex++;
                                _selectedOptionIndex = _userAnswers[_currentQuestionIndex] ?? -1;
                              });
                            } else {
                              _navigateTo(AppScreen.summary);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentLevelColor(),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                _currentQuestionIndex == _quizQuestions.length - 1 ? 'Show Summary' : 'Next Question',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.navigate_next, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Color _currentLevelColor() {
    switch (_selectedLevel) {
      case 'Beginner':
        return const Color(0xFF06B6D4);
      case 'Intermediate':
        return const Color(0xFF6366F1);
      case 'Advanced':
        return const Color(0xFFEC4899);
      case 'Dart & DSA':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF6366F1);
    }
  }

  Widget _buildOptionButton(int index, String optionText, bool isAnswered, Question question) {
    Color cardColor = const Color(0xFF0F172A).withOpacity(0.4);
    Color borderColor = Colors.white.withOpacity(0.06);
    Widget statusIcon = const SizedBox();

    if (isAnswered) {
      final userChoice = _userAnswers[_currentQuestionIndex];
      final isCorrectChoice = index == question.correctOptionIndex;

      if (isCorrectChoice) {
        // Highlight correct choice in Green
        cardColor = const Color(0xFF10B981).withOpacity(0.08);
        borderColor = const Color(0xFF10B981);
        statusIcon = const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20);
      } else if (userChoice == index) {
        // Highlight wrong user selection in Red
        cardColor = const Color(0xFFEF4444).withOpacity(0.08);
        borderColor = const Color(0xFFEF4444);
        statusIcon = const Icon(Icons.cancel, color: Color(0xFFEF4444), size: 20);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: MouseRegion(
        cursor: isAnswered ? SystemMouseCursors.basic : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if (!isAnswered) {
              _selectOption(index);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isAnswered && index == question.correctOptionIndex
                        ? const Color(0xFF10B981).withOpacity(0.15)
                        : Colors.white.withOpacity(0.04),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isAnswered && index == question.correctOptionIndex
                          ? const Color(0xFF10B981)
                          : Colors.white.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isAnswered && index == question.correctOptionIndex
                            ? const Color(0xFF10B981)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    optionText,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFFE2E8F0),
                    ),
                  ),
                ),
                statusIcon,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== SCREEN: QUIZ SUMMARY ====================
  Widget _buildSummaryScreen() {
    final percentage = (_score / _quizQuestions.length) * 100;
    String badge = 'Rookie Developer';
    String message = 'Keep learning! Practice makes perfect.';
    Color badgeColor = const Color(0xFF06B6D4);

    if (percentage == 100) {
      badge = 'Dart Master 👑';
      message = 'Outstanding! You answered every single question perfectly.';
      badgeColor = const Color(0xFFF59E0B);
    } else if (percentage >= 80) {
      badge = 'Flutter Expert 🚀';
      message = 'Excellent job! You have a deep understanding of Flutter.';
      badgeColor = const Color(0xFF8B5CF6);
    } else if (percentage >= 60) {
      badge = 'App Architect 🛠️';
      message = 'Good effort! A few topics require review, but you\'re doing great.';
      badgeColor = const Color(0xFF10B981);
    } else if (percentage >= 40) {
      badge = 'Active Learner 📚';
      message = 'Consistent practice will strengthen your foundation.';
      badgeColor = const Color(0xFF3B82F6);
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        // Glass card summary header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withOpacity(0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.06),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              const Text(
                'Quiz Results',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24),

              // Circular Score
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: CircularProgressIndicator(
                      value: _score / _quizQuestions.length,
                      strokeWidth: 10,
                      color: badgeColor,
                      backgroundColor: const Color(0xFF1E293B),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${percentage.toInt()}%',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFF8FAFC),
                        ),
                      ),
                      Text(
                        '$_score / ${_quizQuestions.length} Right',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: badgeColor.withOpacity(0.3), width: 1),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Controls
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _startQuiz(_selectedLevel),
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.04),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _navigateTo(AppScreen.landing),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Choose Level', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 48),

        // Question Review Header
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Review Questions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Expanded Questions List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _quizQuestions.length,
          itemBuilder: (context, qIndex) {
            final question = _quizQuestions[qIndex];
            final userChoice = _userAnswers[qIndex];
            final isCorrect = userChoice == question.correctOptionIndex;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isCorrect ? const Color(0xFF10B981).withOpacity(0.2) : const Color(0xFFEF4444).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: ExpansionTile(
                title: Row(
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Question ${qIndex + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 36.0, top: 4.0),
                  child: Text(
                    question.questionText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                ),
                childrenPadding: const EdgeInsets.all(24),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.questionText,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (question.codeSnippet != null) ...[
                    const SizedBox(height: 16),
                    _buildCodeBlock(question.codeSnippet!),
                  ],
                  const SizedBox(height: 16),
                  const Text('Options:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  Column(
                    children: List.generate(question.options.length, (optIndex) {
                      final optText = question.options[optIndex];
                      final isCorrectOption = optIndex == question.correctOptionIndex;
                      final isUserSelection = optIndex == userChoice;

                      Color oColor = Colors.transparent;
                      Border oBorder = Border.all(color: Colors.transparent);
                      if (isCorrectOption) {
                        oColor = const Color(0xFF10B981).withOpacity(0.08);
                        oBorder = Border.all(color: const Color(0xFF10B981), width: 1);
                      } else if (isUserSelection) {
                        oColor = const Color(0xFFEF4444).withOpacity(0.08);
                        oBorder = Border.all(color: const Color(0xFFEF4444), width: 1);
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: oColor,
                          borderRadius: BorderRadius.circular(10),
                          border: oBorder,
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${String.fromCharCode(65 + optIndex)}) ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCorrectOption ? const Color(0xFF10B981) : Colors.white,
                              ),
                            ),
                            Expanded(child: Text(optText)),
                            if (isCorrectOption) const Icon(Icons.check, color: Color(0xFF10B981), size: 16),
                            if (isUserSelection && !isCorrectOption) const Icon(Icons.close, color: Color(0xFFEF4444), size: 16),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF10B981).withOpacity(0.15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Explanation:',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          question.explanation,
                          style: const TextStyle(fontSize: 14, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ==================== SCREEN: BROWSE ALL ====================
  Widget _buildBrowseScreen() {
    // Apply filters
    final filtered = questionDatabase.where((q) {
      final matchesFilter = _browseFilter == 'All' || q.category == _browseFilter;
      final matchesQuery = q.questionText.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          q.explanation.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesQuery;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Complete Question Base',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Freely browse, search, and study all 30 Flutter concepts in detail.',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 24),

        // Search & Filter Panel
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              // Search Input
              TextField(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search concepts, terms, or code snippets...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color(0xFF070A13).withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              // Filter Chips
              Row(
                children: [
                  const Text(
                    'Difficulty:',
                    style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['All', 'Beginner', 'Intermediate', 'Advanced', 'Dart & DSA'].map((lvl) {
                        final isSelected = _browseFilter == lvl;
                        return ChoiceChip(
                          label: Text(lvl),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _browseFilter = lvl;
                              });
                            }
                          },
                          backgroundColor: Colors.white.withOpacity(0.03),
                          selectedColor: _getLevelColor(lvl).withOpacity(0.15),
                          labelStyle: TextStyle(
                            color: isSelected ? _getLevelColor(lvl) : const Color(0xFFCBD5E1),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected ? _getLevelColor(lvl).withOpacity(0.3) : Colors.white.withOpacity(0.05),
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // List Counter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Showing ${filtered.length} of ${questionDatabase.length} questions',
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
            ),
            if (_searchQuery.isNotEmpty || _browseFilter != 'All')
              TextButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _browseFilter = 'All';
                  });
                },
                child: const Text('Reset Filters'),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Question List
        filtered.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48.0),
                  child: Column(
                    children: [
                      const Icon(Icons.search_off_rounded, size: 48, color: Color(0xFF64748B)),
                      const SizedBox(height: 16),
                      const Text(
                        'No questions found matching your search',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final question = filtered[index];
                  final color = _getLevelColor(question.category);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.04),
                        width: 1,
                      ),
                    ),
                    child: ExpansionTile(
                      leading: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: color.withOpacity(0.3), width: 1),
                        ),
                        child: Text(
                          question.category,
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        question.questionText,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      childrenPadding: const EdgeInsets.all(24),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (question.codeSnippet != null) ...[
                          _buildCodeBlock(question.codeSnippet!),
                          const SizedBox(height: 16),
                        ],
                        const Text(
                          'Selectable Options:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: List.generate(question.options.length, (optIndex) {
                            final isCorrect = optIndex == question.correctOptionIndex;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isCorrect ? const Color(0xFF10B981).withOpacity(0.06) : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isCorrect ? const Color(0xFF10B981).withOpacity(0.2) : Colors.transparent,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${String.fromCharCode(65 + optIndex)}) ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isCorrect ? const Color(0xFF10B981) : const Color(0xFF64748B),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      question.options[optIndex],
                                      style: TextStyle(
                                        color: isCorrect ? const Color(0xFFF8FAFC) : const Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ),
                                  if (isCorrect) const Icon(Icons.check, color: Color(0xFF10B981), size: 16),
                                ],
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF06B6D4).withOpacity(0.04),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF06B6D4).withOpacity(0.15)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Concept Explanation:',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF06B6D4)),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                question.explanation,
                                style: const TextStyle(fontSize: 14, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
        const SizedBox(height: 32),
      ],
    );
  }

  Color _getLevelColor(String level) {
    if (level == 'Beginner') return const Color(0xFF06B6D4);
    if (level == 'Intermediate') return const Color(0xFF6366F1);
    if (level == 'Advanced') return const Color(0xFFEC4899);
    if (level == 'Dart & DSA') return const Color(0xFF10B981);
    return const Color(0xFF94A3B8);
  }

  // ==================== CODE VIEWER WITH SYNTAX HIGHLIGHTING ====================
  Widget _buildCodeBlock(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16), // Dark coding panel background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: SelectableText.rich(
        _highlightDartCode(code),
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          height: 1.45,
        ),
      ),
    );
  }

  TextSpan _highlightDartCode(String code) {
    final List<TextSpan> spans = [];
    // Basic RegExp matching comments, string literals, language keywords, numeric values
    final regExp = RegExp(
      r'(//.*)|' // Group 1: Comments
      r'(".*?"|' + r"'.*?')" + r'|' // Group 2: Strings
      r'\b(class|void|final|const|return|await|async|import|as|super|setState|double|int|String|bool|var|false|true|override|yield|dynamic)\b|' // Group 3: Keywords
      r'\b(\d+)\b', // Group 4: Numbers
    );

    int lastIndex = 0;
    for (final match in regExp.allMatches(code)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: code.substring(lastIndex, match.start),
          style: const TextStyle(color: Color(0xFFCBD5E1)), // Standard code color
        ));
      }

      final text = match.group(0)!;
      if (match.group(1) != null) {
        // Comment: Slate-Green italic style
        spans.add(TextSpan(
          text: text,
          style: const TextStyle(color: Color(0xFF64748B), fontStyle: FontStyle.italic),
        ));
      } else if (match.group(2) != null) {
        // String literal: Bright Emerald Green style
        spans.add(TextSpan(
          text: text,
          style: const TextStyle(color: Color(0xFF34D399)),
        ));
      } else if (match.group(3) != null) {
        // Keyword: Neon Pink style
        spans.add(TextSpan(
          text: text,
          style: const TextStyle(color: Color(0xFFF472B6), fontWeight: FontWeight.bold),
        ));
      } else if (match.group(4) != null) {
        // Number value: Orange style
        spans.add(TextSpan(
          text: text,
          style: const TextStyle(color: Color(0xFFFB923C)),
        ));
      } else {
        spans.add(TextSpan(
          text: text,
          style: const TextStyle(color: Color(0xFFCBD5E1)),
        ));
      }
      lastIndex = match.end;
    }

    if (lastIndex < code.length) {
      spans.add(TextSpan(
        text: code.substring(lastIndex),
        style: const TextStyle(color: Color(0xFFCBD5E1)),
      ));
    }

    return TextSpan(children: spans);
  }
}

// Custom Helper Widget: Hover scale/shadow animations
class _HoverCard extends StatefulWidget {
  final Widget child;

  const _HoverCard({required this.child});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered
            ? (Matrix4.identity()
              ..translate(0, -6, 0)
              ..scale(1.02))
            : Matrix4.identity(),
        child: widget.child,
      ),
    );
  }
}
