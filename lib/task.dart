import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pomo_task/constants.dart';

class Task {
  String description = '';
  int pomosDone = 0;
  int pomosTotal = 0;
  String id = '';

  Task(
      {required this.id,
      required this.description,
      required this.pomosDone,
      required this.pomosTotal});

  Slidable getVisualisedTask() {
    return Slidable(
      startActionPane: const ActionPane(
        motion: BehindMotion(),
        children: [
          SlidableAction(
            autoClose: true,
            onPressed: null,
            //TODO usuń task
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          )
        ],
      ),
      endActionPane: const ActionPane(
        motion: BehindMotion(),
        children: [
          SlidableAction(
            autoClose: true,
            onPressed: null,
            //TODO edytuj task
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
          )
        ],
      ),
      child: ListTile(
        tileColor: taskColor,
        title: Text(description),
        trailing: SizedBox(
            width: 50,
            height: 40,
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
