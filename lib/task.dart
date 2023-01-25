import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:pomo_task/calendar_client.dart';
import 'package:pomo_task/constants.dart';

class Task {
  String description = '';
  int pomosDone = 0;
  int pomosTotal = 0;
  String id = '';

  final ValueSetter<String> deleteEvent;
  final Function(BuildContext, String, String, int, int) editEvent;

  Task(
      {required this.id,
      required this.description,
      required this.pomosDone,
      required this.pomosTotal,
      required this.deleteEvent,
      required this.editEvent});

  Slidable getVisualisedTask() {
    return Slidable(
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            autoClose: true,
            onPressed: (BuildContext context) {
              deleteEvent(id);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          )
        ],
      ),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            autoClose: true,
            onPressed: (BuildContext context) {
              editEvent(context, id, description, pomosDone, pomosTotal);
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
          )
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        tileColor: taskColor,
        title: Text(description),
        trailing: SizedBox(
            width: 50,
            height: 30,
            child: Row(children: [
              Text('$pomosDone/$pomosTotal'),
              const Icon(
                Icons.hourglass_empty_rounded,
                color: Colors.red,
              ),
            ])),
      ),
    );
  }
}
