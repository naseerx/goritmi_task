import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goritmi_task/core/enums/task_sorting.dart';
import 'package:goritmi_task/core/enums/task_filter.dart';
import 'package:goritmi_task/core/providers/task_provider.dart';
import 'package:goritmi_task/ui/screens/task_screen/add_task_screen.dart';
import 'package:goritmi_task/ui/widgets/custom_snackbars.dart';
import 'package:goritmi_task/ui/widgets/task_block.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
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
                      } else if (option == TaskSortOption.creationDate) {
                        optionText = 'Create Date';
                      } else if (option == TaskSortOption.titleAscending) {
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
                    ? const Center(
                        child: Text(
                          'No tasks available. Add one!',
                          style: TextStyle(fontSize: 18, color: kBlack),
                        ),
                      )
                    : ListView.builder(
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
            backgroundColor: kPrimaryColor,
            foregroundColor: kSecondaryColor,
            onPressed: () {
              Get.to(() => const AddTaskScreen());
            },
            child: const Icon(Icons.add, size: 40)),
      );
    });
  }
}
