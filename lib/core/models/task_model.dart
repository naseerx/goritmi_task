class TaskModel {
  final int? id;
  final String title;
  final String description;
  final int done;
  final String createDate;
  final int dueDateTime;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.done,
    required this.createDate,
    required this.dueDateTime,
  });

  TaskModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        description = res["description"],
        done = res["done"],
        createDate = res["createDate"],
        dueDateTime = res["dueDateTime"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'done': done,
      'createDate': createDate,
      'dueDateTime': dueDateTime,
    };
  }
}
