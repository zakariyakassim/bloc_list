class TodoModel {
  int? id;
  final String description;
  DateTime created;
  bool isBusy;
  TodoModel(
      {this.id,
      required this.description,
      DateTime? created,
      this.isBusy = false})
      : created = created ?? DateTime.now();

  factory TodoModel.fromJson(Map<dynamic, dynamic> json) {
    return TodoModel(
        id: json['id'],
        description: json['description'],
        created:
            json['created'] != null ? DateTime.parse(json['created']) : null);
  }
}
