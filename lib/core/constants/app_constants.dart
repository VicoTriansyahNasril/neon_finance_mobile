class AppConstants {
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double cardRadius = 16.0;
  static const double buttonHeight = 56.0;

  static const List<String> expenseCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Education',
    'Travel',
    'Others',
  ];

  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Business',
    'Investment',
    'Gift',
    'Others',
  ];

  static const int xpPerLevel = 100;

  static int calculateLevel(int xp) {
    return (xp / xpPerLevel).floor() + 1;
  }

  static int calculateXpToNextLevel(int xp) {
    final currentLevel = calculateLevel(xp);
    return (currentLevel * xpPerLevel) - xp;
  }
}
