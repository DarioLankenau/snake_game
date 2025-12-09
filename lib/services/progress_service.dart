import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _completedLevelsKey = 'completed_levels';
  
  static Future<List<int>> getCompletedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    final String? completedLevels = prefs.getString(_completedLevelsKey);
    if (completedLevels == null) {
      return [1];
    }
    return completedLevels.split(',').map((e) => int.parse(e)).toList();
  }
  
  static Future<void> completeLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    final completedLevels = await getCompletedLevels();
    if (!completedLevels.contains(level)) {
      completedLevels.add(level);
      await prefs.setString(_completedLevelsKey, completedLevels.join(','));
    }
    if (!completedLevels.contains(level + 1)) {
      completedLevels.add(level + 1);
      await prefs.setString(_completedLevelsKey, completedLevels.join(','));
    }
  }
  
  static Future<bool> isLevelUnlocked(int level) async {
    final completedLevels = await getCompletedLevels();
    return completedLevels.contains(level);
  }
}

