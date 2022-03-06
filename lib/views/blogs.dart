import 'package:flutter/material.dart';
import '../widgets/blog_item.dart';
import '../widgets/category_item.dart';
import 'package:provider/provider.dart';
import '../state/account_controller.dart';

class Blogs extends StatefulWidget {
  const Blogs({Key? key}) : super(key: key);

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      AccountController accountController = context.read<AccountController>();
    });
  }

  // int _selectedCategory = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Consumer<AccountController>(
          builder: ((context, accountController, _) => Wrap(
                // crossAxisAlignment: WrapCrossAlignment.end,
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: size.height * 1.1 / 8,
                    width: size.width,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...context
                            .read<AccountController>()
                            .categories!
                            .asMap()
                            .map((idx, categoryMap) => MapEntry(
                                idx,
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        context
                                            .read<AccountController>()
                                            .setCategory(idx);
                                      });
                                      print('category is changed');
                                      print('selected category is -> $idx');
                                    },
                                    child: CategoryItem(
                                      imageUrl: categoryMap["Image"],
                                      size: size,
                                      title: categoryMap["Title"],
                                    ))))
                            .values
                            .toList()
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Blog',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      )
                    ],
                  ),
                  ...context
                      .read<AccountController>()
                      .processedBlogs![
                          'Kategori ${accountController.selectedCategory + 1}']!
                      .map(
                        (Map blogMap) => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 1200),
                          child: BlogItem(
                              content: blogMap['Content'],
                              key: ValueKey(blogMap['Id']),
                              size: size,
                              imageUrl: blogMap['Image'],
                              title:
                                  blogMap['Title'].replaceAll('Kategori', ''),
                              id: blogMap['Id']),
                        ),
                      )
                      .toList(),
                  // BlogItem(
                  //   id: '1',
                  //   size: size,
                  //   imageUrl:
                  //       'https://img.imageus.dev/https://internative.s3.eu-central-1.amazonaws.com/uploads/blogPictures/5af6fd64-c970-4884-83f0-71cbf2ad96e1.jpg',
                  //   title: 'What is lorem ipsum',
                  // ),
                  // BlogItem(
                  //   id: '2',
                  //   size: size,
                  //   imageUrl:
                  //       'https://img.imageus.dev/https://internative.s3.eu-central-1.amazonaws.com/uploads/blogPictures/5af6fd64-c970-4884-83f0-71cbf2ad96e1.jpg',
                  //   title: 'What is lorem ipsum',
                  // ),
                  // BlogItem(
                  //   id: '3',
                  //   size: size,
                  //   imageUrl:
                  //       'https://img.imageus.dev/https://internative.s3.eu-central-1.amazonaws.com/uploads/blogPictures/5af6fd64-c970-4884-83f0-71cbf2ad96e1.jpg',
                  //   title: 'What is lorem ipsum',
                  // ),
                ],
              )),
        ),
      )),
    );

    // SingleChildScrollView(
    //   child: Column(
    //     children: [
    //       // GridView.count(
    //       //   crossAxisCount: 2,
    //       //   children: [],
    //       // ),
    //       BlogItem(size: size),
    //     ],
    //   ),
    // );
  }
}
