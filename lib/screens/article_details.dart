import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'package:provider/provider.dart';
import 'dart:math';
import '../state/account_controller.dart';

class Details extends StatefulWidget {
  Details(
      {Key? key,
      required this.imageUrl,
      required this.content,
      required this.id,
      required this.title})
      : super(key: key);
  String imageUrl;
  String content;
  String id;
  String title;

  bool isFavorite = false;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  late Animation<Color?> favAnimation;
  late AnimationController controller;
  @override
  void initState() {
    super.initState();

    // print('widget is initialized');
    controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this)
      ..addListener(() {
        setState(() {});
      });
    bool isFavorite;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      widget.isFavorite =
          context.read<AccountController>().favoriteBlogs.contains(widget.id);

      if (widget.isFavorite) controller.forward();
    });
    favAnimation =
        ColorTween(begin: Colors.black, end: Colors.red).animate(controller);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverLayoutBuilder(
            builder: ((BuildContext context, SliverConstraints constraints) {
              double offset = constraints.scrollOffset;
              double ratio = min(1, 1 - ((offset + 1) / 300));
              return SliverAppBar(
                  stretch: true,
                  iconTheme: IconThemeData(
                      color: Theme.of(context).colorScheme.primary),
                  pinned: true,
                  centerTitle: false,
                  expandedHeight: 200,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha((255 * (1 - ratio)).ceil())),
                    ),
                    background: Stack(fit: StackFit.expand, children: [
                      Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 20,
                        right: 15,
                        child: Consumer<AccountController>(
                          builder: ((context, accountController, child) {
                            return IconButton(
                              onPressed: () async {
                                setState(() {
                                  if (!accountController.favoriteBlogs
                                      .contains(widget.id)) {
                                    widget.isFavorite = true;
                                    print(
                                        'was not favorite, its favorite now ');
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
                                size: 50,
                                color: favAnimation.value,
                              ),
                            );
                          }),
                        ),
                      ),
                    ]),
                  ));
            }),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Align(
              alignment: Alignment.topCenter,
              child: Html(
                style: {
                  "h1": Style(fontFamily: 'roboto', fontSize: FontSize.large),
                  "p": Style(fontFamily: 'roboto', fontSize: FontSize.large),
                },
                data: widget.content,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.7),
                    ),
                    child: Text(
                      'Header1',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Html(
                style: {
                  "h1": Style(fontFamily: 'roboto', fontSize: FontSize.large),
                  "p": Style(fontFamily: 'roboto', fontSize: FontSize.large),
                },
                data: widget.content,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Html(
                style: {
                  "h1": Style(fontFamily: 'roboto', fontSize: FontSize.large),
                  "p": Style(fontFamily: 'roboto', fontSize: FontSize.large),
                },
                data: widget.content,
              ),
            ),
          ])),
        ],
      ),
    );
  }
}
