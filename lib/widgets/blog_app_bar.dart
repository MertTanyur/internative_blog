import 'package:flutter/material.dart';

class BlogAppBar extends StatelessWidget {
  const BlogAppBar({
    Key? key,
    required this.title,
    required this.size,
  }) : super(key: key);
  final String title;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      height: size.height / 9,
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
              alignment: Alignment.bottomCenter,
              child: Text(
                title,
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
