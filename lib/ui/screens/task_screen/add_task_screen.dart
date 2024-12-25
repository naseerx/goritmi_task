import 'package:flutter/material.dart';
import 'package:goritmi_task/core/providers/task_provider.dart';
import 'package:goritmi_task/ui/widgets/custom_buttons.dart';
import 'package:goritmi_task/ui/widgets/custom_snackbars.dart';
import 'package:goritmi_task/ui/widgets/custom_textfield.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(builder: (context, taskProvider, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhite,
          foregroundColor: kPrimaryColor,
          title: const Text('Adding  Task Screen'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/add.png',
                    height: 200,
                  ),
                ),
                CustomTextField(
                  prefixIcon: const Icon(
                    Icons.title,
                    color: kPrimaryColor,
                  ),
                  controller: titleController,
                  hintText: 'Title',
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  prefixIcon: const Icon(
                    Icons.description,
                    color: kPrimaryColor,
                  ),
                  controller: descriptionController,
                  hintText: 'Description...',
                ),
                const SizedBox(height: 10.0),
                CustomTextField(
                  readOnly: true,
                  prefixIcon: const Icon(
                    Icons.calendar_today,
                    color: kPrimaryColor,
                  ),
                  controller: TextEditingController(
                    text: taskProvider.selectedDueDate != null
                        ? DateFormat('yyyy-MM-dd HH:mm')
                            .format(taskProvider.selectedDueDate!)
                        : 'Select Due Date & Time',
                  ),
                  hintText: 'Due Date & Time',
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate:
                          taskProvider.selectedDueDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );

                    if (selectedDate != null) {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            taskProvider.selectedDueDate ?? DateTime.now()),
                      );

                      if (selectedTime != null) {
                        final DateTime fullDateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );

                        taskProvider.selectedDueDate = fullDateTime;

                        taskProvider.notifyListeners();
                      }
                    }
                  },
                ),
                const SizedBox(height: 40.0),
                CustomButton(
                    name: 'Add Task',
                    onTap: () {
                      if (titleController.text.isEmpty ||
                          descriptionController.text.isEmpty) {
                        return CustomSnackBar.showError(
                            'Please provide task details');
                      }
                      taskProvider.addTask(
                          titleController.text,
                          descriptionController.text,
                          context,
                          taskProvider.selectedDueDate);
                    }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
