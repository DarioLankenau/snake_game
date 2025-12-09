import 'package:flutter/material.dart';
import '../services/progress_service.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  List<int> unlockedLevels = [1];
  final List<String> levelNames = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final completed = await ProgressService.getCompletedLevels();
    setState(() {
      unlockedLevels = completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Level',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth > 800 ? 800.0 : constraints.maxWidth;
          final isTablet = constraints.maxWidth > 600;
          
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 32.0 : 16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet ? 3 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final level = index + 1;
                    final isUnlocked = unlockedLevels.contains(level);
                    
                    return GestureDetector(
                      onTap: isUnlocked
                          ? () {
                              Navigator.pushNamed(
                                context,
                                '/game',
                                arguments: level,
                              );
                            }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isUnlocked ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                          border: Border.all(
                            color: isUnlocked ? Colors.green : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isUnlocked ? Icons.play_circle : Icons.lock,
                              size: isTablet ? 48 : 36,
                              color: isUnlocked ? Colors.green : Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Level $level',
                              style: TextStyle(
                                fontSize: isTablet ? 20 : 18,
                                fontWeight: FontWeight.bold,
                                color: isUnlocked ? Colors.green : Colors.grey,
                              ),
                            ),
                            Text(
                              levelNames[index % levelNames.length],
                              style: TextStyle(
                                fontSize: isTablet ? 14 : 12,
                                color: isUnlocked ? Colors.grey : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

