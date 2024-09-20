import 'package:flutter/material.dart';
import 'package:untitled9/Firebase%20-utils.dart';
import 'package:untitled9/model/task.dart';

class ListProvider extends ChangeNotifier {
  List<Task> tasksList = [];
  var selectDate = DateTime.now();

  void getAllTasksFromFireStore(String uId) async {
    var querySnapshot = await FirebaseUtils.getTaskCollection(uId).get();

    // Ensure each doc is mapped to a Task object
    tasksList = querySnapshot.docs.map((doc) {
      return Task.fromFireStore(doc.data()
          as Map<String, dynamic>); // Assuming Task has a fromJson constructor
    }).toList();

    // Filter tasks by selected date
    tasksList = tasksList.where((task) {
      return selectDate.day == task.dateTime.day &&
          selectDate.month == task.dateTime.month &&
          selectDate.year == task.dateTime.year;
    }).toList();

    // Sort tasks by dateTime
    tasksList.sort((task1, task2) {
      return task1.dateTime.compareTo(task2.dateTime);
    });

    // Notify listeners after all changes
    notifyListeners();
  }

  void changeSelectDate(DateTime newDate, String uId) {
    selectDate = newDate;
    getAllTasksFromFireStore(uId);
  }
}