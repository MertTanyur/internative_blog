import 'package:flutter/material.dart';

class Blogs extends StatefulWidget {
  const Blogs({Key? key}) : super(key: key);

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
        // Column(
        //   children: [BlogItem(size: size)],
        // );
        GridView.count(
      childAspectRatio: 0.8,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      crossAxisCount: 2,
      children: [
        BlogItem(size: size),
        BlogItem(size: size),
        BlogItem(size: size),
        BlogItem(size: size),
        BlogItem(size: size),
        BlogItem(size: size),
        BlogItem(size: size),
        BlogItem(size: size),
        BlogItem(size: size),
      ],
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

class BlogItem extends StatelessWidget {
  const BlogItem({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 24 / 84,
      width: size.width * 18 / 39,
      decoration: BoxDecoration(
        // color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              child: Image.network(
                'https://img.imageus.dev/https://internative.s3.eu-central-1.amazonaws.com/uploads/blogPictures/5af6fd64-c970-4884-83f0-71cbf2ad96e1.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffC4C9D2).withOpacity(0.7),
                  // borderRadius: BorderRadius.vertical(
                  //   bottom: Radius.circular(16),
                  // ),
                ),
                height: size.height * 6 / 84,
                width: size.width * 18 / 39,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Center(
                          child: Text(
                        'What is Lorem Ipsum?',
                      )),
                    ]),
              ),
            ),
            Positioned(
              top: 3,
              right: 3,
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
