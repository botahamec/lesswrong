class UserName {
  final String id;
  final String displayName;

  UserName({required this.id, required this.displayName});

  UserName.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        displayName = json['displayName'];

  @override
  String toString() {
    return displayName;
  }
}
