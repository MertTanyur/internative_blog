import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/account_controller.dart';
import '../widgets/blog_item.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Consumer<AccountController>(
            builder: ((context, accountController, _) => Wrap(
                    // crossAxisAlignment: WrapCrossAlignment.end,
                    runAlignment: WrapAlignment.center,
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ...accountController.rawBlogList!
                          .where((element) => accountController.favoriteBlogs
                              .contains(element["Id"]))
                          .toList()
                          .map(
                            (blogMap) => AnimatedSwitcher(
                              duration: const Duration(milliseconds: 1200),
                              child: BlogItem(
                                  key: ValueKey(blogMap['Id']),
                                  size: size,
                                  imageUrl: blogMap['Image'],
                                  title: blogMap['Title']
                                      .replaceAll('Kategori', ''),
                                  id: blogMap['Id']),
                            ),
                          ),
                    ])),
          ),
        )));
  }
}
