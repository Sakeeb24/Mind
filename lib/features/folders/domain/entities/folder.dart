class Folder {
  const Folder({
    required this.id,
    required this.name,
    this.color,
    this.parentId,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String? color;
  final String? parentId;
  final DateTime createdAt;

  Folder copyWith({String? name, String? color, String? parentId}) {
    return Folder(
      id: id,
      name: name ?? this.name,
      color: color ?? this.color,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Folder && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Folder(id: $id, name: $name)';
}
