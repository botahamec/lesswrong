import 'tag.dart';
import 'user.dart';

class PostItem {
  final String id;
  final int baseScore;
  final String title;
  final List<UserName> authors;
  final DateTime postedAt;
  final int commentCount;

  const PostItem(
      {required this.id,
      required this.baseScore,
      required this.title,
      required this.authors,
      required this.postedAt,
      required this.commentCount});

  PostItem.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        baseScore = json['baseScore'],
        title = json['title'],
        authors = (json['coauthors'] as List)
            .cast<Map<String, dynamic>>()
            .map(UserName.fromJson)
            .toList()
          ..insert(0, UserName.fromJson(json['user'])),
        postedAt = DateTime.parse(json['postedAt']),
        commentCount = json['commentCount'];
}

class PostData {
  final DateTime postedAt;
  final String title;
  final int wordCount;
  final String htmlBody;
  final List<UserName> authors;
  final List<String> tags;
  final int baseScore;
  final bool isFrontpaged;
  final int commentCount;

  PostData(
      {required this.postedAt,
      required this.title,
      required this.wordCount,
      required this.htmlBody,
      required this.authors,
      required this.tags,
      required this.baseScore,
      required this.isFrontpaged,
      required this.commentCount});

  PostData.fromJson(Map<String, dynamic> json)
      : postedAt = DateTime.parse(json['postedAt']),
        title = json['title'],
        wordCount = json['wordCount'],
        htmlBody = (json['htmlBody'] as String),
        authors = (json['coauthors'] as List)
            .cast<Map<String, dynamic>>()
            .map(UserName.fromJson)
            .toList()
          ..insert(0, UserName.fromJson(json['user'])),
        tags = json['tags']
            .cast<Map<String, dynamic>>()
            .map(TagName.fromJson)
            .map((t) => t.name)
            .toList()
            .cast<String>(),
        baseScore = json['baseScore'],
        isFrontpaged = json['frontpageDate'] != null,
        commentCount = json['commentCount'];
}
