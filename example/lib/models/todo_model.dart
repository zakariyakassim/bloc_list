class TodoModel {
  final int id;
  final String description;
  DateTime created;

  TodoModel({
    required this.id,
    required this.description,
    DateTime? created,
  }) : created = created ?? DateTime.now();

  factory TodoModel.fromJson(Map<dynamic, dynamic> json) {
    return TodoModel(
        id: json['id'],
        description: json['description'],
        created:
            json['created'] != null ? DateTime.parse(json['created']) : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'created': created.toIso8601String(),
    };
  }
}
