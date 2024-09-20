import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:untitled9/Firebase%20-utils.dart';
import 'package:untitled9/model/task.dart';
import 'package:untitled9/provider/list_provider.dart';

import '../../app-colors.dart';
import '../../provider/user_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  String title = ' ';

  String description = '';
  var selectDate = DateTime.now();
  late ListProvider listProvider;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    return Container(
      padding: EdgeInsets.all(16.0), // Padding around the container
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // Stretch children to fill the width
          children: [
            Center(
              child: Text(
                AppLocalizations.of(context)!.add_new_task,
                style: TextStyle(
                  fontSize: 22,
                  color: AppColors.blackDarkColor,
                ),
              ),
            ),
            SizedBox(height: 16),
            // Space between title and first TextFormField
            Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      onChanged: (text) {
                        title = text;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter task title';
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter task title',
                      ),
                    ),
                    SizedBox(height: 16),
                    // Space between the two TextFormFields
                    TextFormField(
                      onChanged: (text) {
                        description = text;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter task description';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter task description',
                      ),
                      maxLines: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.select_date,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackDarkColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          showCalendar();
                        },
                        child: Text(
                          '${selectDate.day}/${selectDate.month}/${selectDate.year}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackDarkColor,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.add,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      Task task =
          Task(title: title, description: description, dateTime: selectDate);
      FirebaseUtils.addTaskToFireStore(task, userProvider.currentUser!.id)
          .then((value) {
        listProvider.getAllTasksFromFireStore(userProvider.currentUser!.id);
        Navigator.pop(context);
      }).timeout(
        Duration(seconds: 1),
        onTimeout: () {
          print('task added successfully');
          listProvider.getAllTasksFromFireStore(userProvider.currentUser!.id);
          Navigator.pop(context);
        },
      );
    }
  }

  void showCalendar() async {
    var chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (chosenDate != null) {
      selectDate = chosenDate;
      setState(() {});
    }
  }
}
