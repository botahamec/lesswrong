import 'package:flutter/material.dart';

import '../models/post.dart';
import '../utils/time.dart';

import '../screens/post.dart';

class PostItemCard extends StatelessWidget {
  const PostItemCard(this.post, {Key? key}) : super(key: key);

  final PostItem post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: _ResponsivePostItemCard(post),
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (c) => PostPage(post.id))),
    );
  }
}

class _ResponsivePostItemCard extends StatelessWidget {
  const _ResponsivePostItemCard(this.post, {Key? key}) : super(key: key);

  final PostItem post;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return _PostItemCardPortrait(post);
    } else {
      return _PostItemCardLandscape(post);
    }
  }
}

class _PostItemCardLandscape extends StatelessWidget {
  const _PostItemCardLandscape(this.post, {Key? key}) : super(key: key);

  final PostItem post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(height: 46),
        SizedBox(
            width: 42,
            child: Text(post.baseScore.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color(0xff757575), fontFamily: 'Calibri'))),
        Expanded(child: Text(post.title, overflow: TextOverflow.ellipsis)),
        Text(
          post.authors.join(', '),
          style: const TextStyle(color: Colors.grey, fontFamily: 'Calibri'),
        ),
        SizedBox(
            width: 38,
            child: Text(fromNowString(post.postedAt),
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Calibri'))),
        Stack(children: [
          const Icon(Icons.chat_bubble),
          SizedBox(
              width: 24.5,
              height: 21,
              child: Center(
                  child: Text(post.commentCount.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 8,
                          fontFamily: 'Calibri',
                          color: Colors.white))))
        ]),
        const SizedBox(width: 6)
      ],
    );
  }
}

class _PostItemCardPortrait extends StatelessWidget {
  const _PostItemCardPortrait(this.post, {Key? key}) : super(key: key);

  final PostItem post;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(children: [
          Row(children: [
            const SizedBox(height: 26, width: 5),
            Flexible(
                child: Text(post.title,
                    overflow: TextOverflow.ellipsis, textAlign: TextAlign.left))
          ]),
          Row(
            children: [
              const SizedBox(height: 26, width: 5),
              Text(post.baseScore.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xff757575), fontFamily: 'Calibri')),
              const SizedBox(width: 8),
              Text(
                post.authors.join(', '),
                style:
                    const TextStyle(color: Colors.grey, fontFamily: 'Calibri'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(fromNowString(post.postedAt),
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontFamily: 'Calibri')),
              ),
              Stack(children: [
                const Icon(Icons.chat_bubble),
                SizedBox(
                    width: 24.5,
                    height: 21,
                    child: Center(
                        child: Text(post.commentCount.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 8,
                                fontFamily: 'Calibri',
                                color: Colors.white))))
              ]),
              const SizedBox(width: 6)
            ],
          )
        ]));
  }
}
