import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled9/Home/task_list/task_list_item.dart';
import 'package:untitled9/provider/list_provider.dart';

import '../../provider/user_provider.dart';

class TaskListTab extends StatefulWidget {
  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    if (listProvider.tasksList.isEmpty) {
      listProvider.getAllTasksFromFireStore(userProvider.currentUser!.id);
    }
    return Container(
      child: Column(
        children: [
          EasyDateTimeLine(
            initialDate: DateTime.now(),
            onDateChange: (selectedDate) {
              listProvider.changeSelectDate(
                  selectedDate, userProvider.currentUser!.id);

              //selectedDate the new date selected.
            },
            headerProps: const EasyHeaderProps(
              monthPickerType: MonthPickerType.switcher,
              dateFormatter: DateFormatter.fullDateDMY(),
            ),
            dayProps: const EasyDayProps(
              dayStructure: DayStructure.dayStrDayNum,
              activeDayStyle: DayStyle(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff3371FF),
                      Color(0xff8426D6),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: listProvider.tasksList.isEmpty
                ? Text('No Tasks is added')
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return TaskListItem(task: listProvider.tasksList[index]);
                    },
                    itemCount: listProvider.tasksList.length,
                  ),
          )
        ],
      ),
    );
  }
}
