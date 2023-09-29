const String tableNotes = "notes";

class NotesFields {

  static final List<String> values = [
    id, isImportant, number, title, description, time
  ];

  static const String id = "_id";
  static const String isImportant = "isImportant";
  static const String number = "number";
  static const String title = "title";
  static const String description = "description";
  static const String time = "time";
}

class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime
  });

  static Note fromJson(Map<String, Object?> json) => Note(
      id : json[NotesFields.id] as int?,
      isImportant: json[NotesFields.isImportant] == 1,
      number: json[NotesFields.number] as int,
      title: json[NotesFields.title] as String,
      description: json[NotesFields.description] as String,
      createdTime: DateTime.parse(json[NotesFields.time] as String)
  );

  Map<String, Object?> toJson() => {
    NotesFields.id : id,
    NotesFields.isImportant : isImportant ? 1 : 0,
    NotesFields.number : number,
    NotesFields.title : title,
    NotesFields.description : description,
    NotesFields.time : createdTime.toIso8601String(),
  };

  Note copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime

  }) => Note(
      id: id ?? this.id,
      isImportant: isImportant ?? this.isImportant,
      number: number ?? this.number,
      title: title ?? this.title,
      description: description ?? this.description,
      createdTime: createdTime ?? this.createdTime
  );

}
