class Task {
  String description = "";
  String groupName = "";
  int pomosDone = 0;
  int pomosTotal = 0;
  int posInGroup = 0;

  Task(
      {required this.description,
      required this.pomosTotal,
      required this.groupName,
      required this.posInGroup});
}
