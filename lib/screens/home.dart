import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/post.dart';
import '../widgets/logo.dart';
import '../widgets/post_item.dart';

const recommendedPostsQuery =
    """
{Recommendations(
  count: 2
  algorithm: {
    method: "sample",
    scoreOffset: 0,
    scoreExponent: 3,
    personalBlogpostModifier: 0,
    includePersonal: false,
    includeMeta: false,
    frontpageModifier: 10,
    curatedModifier: 50,
    onlyUnread: true,
  }
) {
  postedAt,
  title,
  user {displayName, _id},
  coauthors {displayName, _id},
  _id,
  baseScore,
  commentCount
}}
""";

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Logo()),
        body: ListView(
          padding: const EdgeInsets.only(left: 15, right: 15),
          children: [
            const SizedBox(height: 24),
            Text('Recommendations',
                style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 8),
            const Recommendations()
          ],
        ));
  }
}

class Recommendations extends StatelessWidget {
  const Recommendations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: gql(recommendedPostsQuery)),
      builder: (QueryResult<dynamic> result,
          {Future<QueryResult<dynamic>> Function(FetchMoreOptions)? fetchMore,
          Future<QueryResult<dynamic>?> Function()? refetch}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Center(child: CircularProgressIndicator()));
        }

        final List<Map<String, dynamic>> recommendedPosts =
            result.data!['Recommendations'].cast<Map<String, dynamic>>();
        final recommendations = recommendedPosts
            .map(PostItem.fromJson)
            .map((post) => PostItemCard(post))
            .toList();

        return Column(
          children: recommendations,
        );
      },
    );
  }
}
