import 'package:flutter/material.dart';
import '../services/progress_service.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool isLoading = true;
  bool _handled = false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_handled) {
      _handled = true;
      _handleResult();
    }
  }
  
  Future<void> _handleResult() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final won = args?['won'] ?? false;
    
    if (!won) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }
    
    try {
      await ProgressService.completeLevel(args!['level'] as int).timeout(
        const Duration(seconds: 1),
        onTimeout: () {},
      );
    } catch (e) {
    }
    
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final level = args?['level'] ?? 1;
    final score = args?['score'] ?? 0;
    final won = args?['won'] ?? false;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth > 800 ? 800.0 : constraints.maxWidth;
          final isTablet = constraints.maxWidth > 600;
          
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 32.0 : 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      won ? Icons.check_circle : Icons.cancel,
                      size: isTablet ? 120 : 80,
                      color: won ? Colors.green : Colors.red,
                    ),
                    SizedBox(height: isTablet ? 32 : 24),
                    Text(
                      won ? 'LEVEL COMPLETE!' : 'GAME OVER',
                      style: TextStyle(
                        fontSize: isTablet ? 48 : 36,
                        fontWeight: FontWeight.bold,
                        color: won ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Level $level',
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 20,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Final Score: $score',
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isTablet ? 48 : 32),
                    if (!isLoading) ...[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/levels',
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 48 : 32,
                            vertical: isTablet ? 20 : 16,
                          ),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.black,
                          textStyle: TextStyle(
                            fontSize: isTablet ? 20 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Back to Levels'),
                      ),
                      SizedBox(height: 16),
                      if (won)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/game',
                              arguments: level + 1,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 48 : 32,
                              vertical: isTablet ? 20 : 16,
                            ),
                            backgroundColor: Colors.green.withOpacity(0.3),
                            foregroundColor: Colors.green,
                            textStyle: TextStyle(
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.green),
                            ),
                          ),
                          child: const Text('Next Level'),
                        ),
                    ] else
                      const CircularProgressIndicator(color: Colors.green),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

