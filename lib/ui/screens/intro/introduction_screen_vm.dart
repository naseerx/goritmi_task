import 'package:flutter/cupertino.dart';
import 'package:goritmi_task/core/constants/assets.dart';

class IntroductionScreenVm extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;

  List<String> pictures = [
    AppAssets.intro1,
    AppAssets.intro2,
    AppAssets.intro3
  ];

  final List<Map<String, String>> pages = [
    {
      'title': 'Welcome to Our App!',
      'description': 'Discover the easiest way to manage your tasks.',
    },
    {
      'title': 'Track Your Progress',
      'description':
          'Stay on top of your tasks with powerful filters and sorting options.',
    },
    {
      'title': 'Get Started!',
      'description': 'Let\'s help you get started with adding your first task.',
    },
  ];
}
