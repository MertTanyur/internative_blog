import 'package:flutter/material.dart';

class BlogAppBar extends StatefulWidget {
  const BlogAppBar({
    Key? key,
    required this.title,
    required this.size,
  }) : super(key: key);
  final String title;
  final Size size;

  @override
  State<BlogAppBar> createState() => _BlogAppBarState();
}

class _BlogAppBarState extends State<BlogAppBar> {
  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      height: widget.size.height / 13,
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            spreadRadius: 1,
            color: const Color(0xff000000).withOpacity(0.2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.title,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: const Color(0xff292F3B)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
