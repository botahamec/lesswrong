class TagName {
  final String name;

  const TagName({required this.name});

  TagName.fromJson(Map<String, dynamic> json) : name = json['name'];
}
