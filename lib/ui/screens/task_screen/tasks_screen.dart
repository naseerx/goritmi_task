import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goritmi_task/core/enums/task_sorting.dart';
import 'package:goritmi_task/core/enums/task_filter.dart';
import 'package:goritmi_task/core/providers/task_provider.dart';
import 'package:goritmi_task/ui/widgets/custom_snackbars.dart';
import 'package:goritmi_task/ui/widgets/task_block.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'add_task_screen.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final GlobalKey _filterDropdownKey = GlobalKey();
  final GlobalKey _sortDropdownKey = GlobalKey();
  final GlobalKey _taskListKey = GlobalKey();
  final GlobalKey _addButtonKey = GlobalKey();

  late TutorialCoachMark tutorialCoachMark;
  bool _tutorialShown = false;

  Future<void> requestNotificationPermissions() async {
    var status = await Permission.notification.request();

    if (status.isGranted) {
      print("Notification permission granted");
    } else if (status.isDenied) {
      print("Notification permission denied");
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> checkTutorialStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _tutorialShown = prefs.getBool('tutorialShown') ?? false;

    if (!_tutorialShown) {
      createTutorial();
      Future.delayed(Duration.zero, showTutorial);

      // Mark tutorial as shown
      await prefs.setBool('tutorialShown', true);
    }
  }

  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
    checkTutorialStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(builder: (context, taskProvider, child) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Goritmi ToDos',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    'Filter By',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kBlack),
                  ),
                  Spacer(),
                  Text(
                    'Sorted By',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kBlack),
                  ),
                ],
              ),
              Row(
                children: [
                  DropdownButton<TaskFilter>(
                    key: _filterDropdownKey,
                    iconEnabledColor: kSecondaryColor,
                    value: taskProvider.currentFilter,
                    onChanged: (TaskFilter? newValue) {
                      if (newValue != null) {
                        taskProvider.updateFilter(newValue);
                        taskProvider.updateSortOption(TaskSortOption.none);
                      }
                    },
                    items: TaskFilter.values.map((TaskFilter filter) {
                      String filterText = '';
                      if (filter == TaskFilter.all) {
                        filterText = 'All Tasks';
                      } else if (filter == TaskFilter.done) {
                        filterText = 'Done';
                      } else if (filter == TaskFilter.pending) {
                        filterText = 'Pending';
                      }
                      return DropdownMenuItem<TaskFilter>(
                        value: filter,
                        child: Text(filterText),
                      );
                    }).toList(),
                  ),
                  const Spacer(),
                  DropdownButton<TaskSortOption>(
                    key: _sortDropdownKey,
                    value: taskProvider.currentOption,
                    iconEnabledColor: kSecondaryColor,
                    onChanged: (TaskSortOption? newValue) {
                      if (newValue != null) {
                        taskProvider.updateSortOption(newValue);
                        taskProvider.updateFilter(TaskFilter.all);
                      }
                    },
                    items: TaskSortOption.values.map((TaskSortOption option) {
                      String optionText = '';
                      if (option == TaskSortOption.none) {
                        optionText = 'None';
                      }else if (option == TaskSortOption.titleAscending) {
                        optionText = 'Title (A-Z)';
                      } else if (option == TaskSortOption.titleDescending) {
                        optionText = 'Title (Z-A)';
                      }
                      return DropdownMenuItem<TaskSortOption>(
                        value: option,
                        child: Text(optionText),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Expanded(
                child: taskProvider.tasks.isEmpty
                    ? Center(
                        child: Text(
                          key: _taskListKey,
                          'No tasks available. Add one!',
                          style: const TextStyle(fontSize: 18, color: kBlack),
                        ),
                      )
                    : ListView.builder(
                        key: _taskListKey,
                        itemCount: taskProvider.tasks.length,
                        itemBuilder: (context, index) {
                          final task = taskProvider.tasks[index];
                          return Dismissible(
                            key: Key(task.id.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) async {
                              taskProvider.deleteTask(task.id!);
                              CustomSnackBar.showSuccess(
                                  'Task Deleted Successfully');
                            },
                            child: TaskCard(
                              title: task.title,
                              description: task.description,
                              done: task.done,
                              onDone: () {
                                taskProvider.updateTaskStatus(task.id!, 1);
                              },
                              createDate: task.createDate,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            key: _addButtonKey,
            backgroundColor: kPrimaryColor,
            foregroundColor: kSecondaryColor,
            onPressed: () async {
              Get.to(() => const AddTaskScreen());
            },
            child: const Icon(Icons.add, size: 40)),
      );
    });
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: _filterDropdownKey,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Use this dropdown to filter tasks based on their status. You can view all tasks, only completed tasks, or pending tasks.",
                    style: TextStyle(
                      color: kBlack,
                      fontSize: 16,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation2",
        keyTarget: _sortDropdownKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Use this dropdown to sort tasks. You can sort by creation date, or organize tasks alphabetically (A-Z or Z-A).",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation3",
        keyTarget: _taskListKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "This is your task list. When you add tasks, they will appear here. Swipe left on a task to delete it.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      tutorialCoachMark.goTo(0);
                    },
                    child: const Text('Go to index 0'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: _addButtonKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Add New Tasks",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Tap this button to create a new task. You can add a title, description, and other details to organize your tasks.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }
}
