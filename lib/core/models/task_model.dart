class TaskModel {
  final int? id;
  final String title;
  final String description;
  final int done;
  final String createDate;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.done,
    required this.createDate,
  });

  TaskModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        description = res["description"],
        done = res["done"],
        createDate = res["createDate"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'done': done,
      'createDate': createDate,
    };
  }
}
