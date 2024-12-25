import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goritmi_task/Core/Constants/colors.dart';
import 'package:goritmi_task/ui/screens/intro/introduction_screen_vm.dart';
import 'package:goritmi_task/ui/screens/task_screen/tasks_screen.dart';
import 'package:provider/provider.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => IntroductionScreenVm(),
      child: Consumer<IntroductionScreenVm>(
        builder: (context, vm, child) {
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [kSecondaryColor, kPrimaryColor],
                    ),
                  ),
                ),
                PageView.builder(
                  controller: vm.pageController,
                  itemCount: vm.pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      vm.currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            vm.pictures[index],
                          ),
                          Text(
                            vm.pages[index]['title']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: kWhite,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            vm.pages[index]['description']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 120,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      vm.pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        height: 10,
                        width: vm.currentPage == index ? 20 : 10,
                        decoration: BoxDecoration(
                          color:
                              vm.currentPage == index ? kWhite : Colors.white54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      vm.currentPage == vm.pages.length - 1
                          ? const SizedBox.shrink()
                          : GestureDetector(
                              onTap: () {
                                Get.off(() => const TasksScreen());
                              },
                              child: const Text(
                                'Skip',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                      vm.currentPage == vm.pages.length - 1
                          ? AnimatedOpacity(
                              opacity: 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kSecondaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  Get.off(() => const TasksScreen());
                                },
                                child: const Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: kWhite,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
