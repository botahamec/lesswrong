import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/post.dart';
import '../utils/time.dart';
import '../widgets/logo.dart';
import '../utils/text.dart';

const postQuery = """
query getPost(\$postId: String) {
  post(input: {selector: {_id: \$postId}}) {
    result {
      postedAt
      title
      user {displayName, _id}
      wordCount
      htmlBody
      shortform
      canonicalSource
      tags {name}
      _id
      baseScore
      isRead
      curatedDate
      metaDate
      frontpageDate
      coauthors {displayName, _id}
      collectionTitle
      meta
      commentCount
      pingbacks
    }
  }
}
""";

class PostPage extends StatelessWidget {
  const PostPage(this.postId, {Key? key}) : super(key: key);

  final String postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Logo()), body: _PostPageBody(postId));
  }
}

class _PostPageBody extends StatelessWidget {
  const _PostPageBody(this.postId, {Key? key}) : super(key: key);

  final String postId;

  @override
  Widget build(BuildContext context) {
    return Query(
      options:
          QueryOptions(document: gql(postQuery), variables: {'postId': postId}),
      builder: (QueryResult<dynamic> result,
          {Future<QueryResult<dynamic>> Function(FetchMoreOptions)? fetchMore,
          Future<QueryResult<dynamic>?> Function()? refetch}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return const Align(
              child: Expanded(child: CircularProgressIndicator()));
        }

        return _Post(PostData.fromJson(result.data!['post']['result']));
      },
    );
  }
}

class _Post extends StatelessWidget {
  const _Post(this.post, {Key? key}) : super(key: key);

  final PostData post;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [_PostHeader(post), _PostText(post.htmlBody)],
        ));
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader(this.post, {Key? key}) : super(key: key);

  final PostData post;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Flexible(
              child: Column(
            children: [
              const SizedBox(height: 8),
              Row(children: [
                Flexible(
                    child: Text(post.title,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.titleMedium))
              ]),
              Row(children: [
                Flexible(
                    child: Wrap(
                        spacing: 20,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                      RichText(
                          text: TextSpan(
                              text: 'by ',
                              style: DefaultTextStyle.of(context).style,
                              children: [
                            TextSpan(
                                text: post.authors.join(', '),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))
                          ])),
                      Text('${readLength(post.wordCount)} min read',
                          style: const TextStyle(
                              color: Color(0xff757575), fontSize: 10)),
                      Text(formatDate(post.postedAt),
                          style: const TextStyle(
                              color: Color(0xff757575), fontSize: 10)),
                      Text("${post.commentCount} comments",
                          style: const TextStyle(
                              color: Color(0xff757575), fontSize: 10))
                    ]))
              ]),
            ],
          )),
          Column(children: [
            SizedBox(
                width: 50,
                child: Center(child: Text(post.baseScore.toString())))
          ])
        ],
      ),
      Row(children: [
        Wrap(
          children: [],
        )
      ]),
    ]);
  }
}

class _PostText extends StatelessWidget {
  const _PostText(this.html, {Key? key}) : super(key: key);

  final String html;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: html,
      style: {
        'a': Style(color: Colors.green, textDecoration: TextDecoration.none),
        'blockquote': Style(
          border: const Border(left: BorderSide(color: Colors.grey, width: 3)),
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.only(left: 16, top: 1, bottom: 1),
        ),
        'hr': Style(
          backgroundColor: Colors.transparent,
          after: '•••',
          letterSpacing: 12,
          color: const Color(0xffb0b0b0),
          margin: const EdgeInsets.symmetric(vertical: 32),
          alignment: Alignment.center,
          textAlign: TextAlign.center,
        ),
        '.footnote-content': Style(display: Display.INLINE_BLOCK)
      },
    );
  }
}
