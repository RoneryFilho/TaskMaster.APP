class Task {
  int id;
  String description;
  DateTime dateTime;
  String priority;
  bool isCompleted;

  Task({
    required this.id,
    required this.description,
    required this.dateTime,
    required this.priority,
    required this.isCompleted,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
      priority: json['priority'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }
}
