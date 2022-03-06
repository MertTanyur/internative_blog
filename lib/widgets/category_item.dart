import 'package:flutter/material.dart';

class CategoryItem extends StatefulWidget {
  CategoryItem({
    Key? key,
    required this.size,
    required this.imageUrl,
    required this.title,
  }) : super(key: key);

  final Size size;
  String imageUrl;
  String title;

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: widget.size.width * 11 / 39,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Text(widget.title, style: TextStyle(fontSize: 10))
        ],
      ),
    );
  }
}
