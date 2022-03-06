import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/account_controller.dart';
import 'package:skeletons/skeletons.dart';
import '../screens/article_details.dart';

class BlogItem extends StatefulWidget {
  BlogItem({
    Key? key,
    required this.size,
    required this.imageUrl,
    required this.title,
    required this.id,
    required this.content,
  }) : super(key: key);
  bool isFavorite = false;
  final Size size;
  final String imageUrl;
  final String title;
  final String id;
  final String content;

  @override
  State<BlogItem> createState() => _BlogItemState();
}

class _BlogItemState extends State<BlogItem> with TickerProviderStateMixin {
  late Animation<Color?> favAnimation;
  late AnimationController controller;
  // late Animation<double?> transformAnimation;
  @override
  void initState() {
    super.initState();
    print('widget is initialized');
    controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this)
      ..addListener(() {
        setState(() {});
      });
    bool isFavorite;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      widget.isFavorite =
          context.read<AccountController>().favoriteBlogs.contains(widget.id);
      // print(
      //     'we are here inside addpostframecallback and widget value is -> ${widget.isFavorite}');
      if (widget.isFavorite) controller.forward();
    });
    favAnimation =
        ColorTween(begin: Colors.black, end: Colors.red).animate(controller);
    // transformAnimation = Tween<double>(begin: 0, end: 1).animate(controller)
    //   ..addListener(() {
    //     setState(() {});
    //   });
  }

  @override
  void dispose() {
    controller.dispose();
    if (mounted) {
      super.dispose();
    }
  }

  // List<BoxShadow> shadowAnimation = [];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('widget is tapped ${widget.id}');

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Details(
                  imageUrl: widget.imageUrl,
                  content: widget.content,
                  id: widget.id,
                  title: widget.title),
            )).then((_) {
          print('method trigerredddddddddddd');
          if (context
              .read<AccountController>()
              .favoriteBlogs
              .contains(widget.id)) {
            controller.forward();
          } else {
            controller.reverse();
          }
        });
      },
      child: Container(
        padding: EdgeInsets.all(5),
        height: widget.size.height * 24 / 84,
        width: widget.size.width * 18 / 39,
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
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
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
                  height: widget.size.height * 6 / 84,
                  width: widget.size.width * 18 / 39,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(child: Text(widget.title)),
                      ]),
                ),
              ),
              Positioned(
                top: 3,
                right: 3,
                child: Consumer<AccountController>(
                  builder: ((context, accountController, child) {
                    return IconButton(
                      onPressed: () async {
                        setState(() {
                          if (!accountController.favoriteBlogs
                              .contains(widget.id)) {
                            widget.isFavorite = true;
                            print('was not favorite, its favorite now ');
                            controller.forward();
                          } else {
                            widget.isFavorite = false;
                            print('was a favorite, not anymore');
                            controller.reverse();
                          }
                          print(
                              'all favorite blogs are -> ${accountController.favoriteBlogs}');
                          print('current id is -> ${widget.id}');

                          print(
                              'is widget favorite according to provider state ? -> ${accountController.favoriteBlogs.contains(widget.id)}');
                        });
                        if (!accountController.favoriteBlogs
                            .contains(widget.id)) {
                          await context
                              .read<AccountController>()
                              .favBlog(widget.id);
                        } else {
                          print('was a favorite, not anymore');
                          await context
                              .read<AccountController>()
                              .unFavBlog(widget.id);
                        }
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: favAnimation.value,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
