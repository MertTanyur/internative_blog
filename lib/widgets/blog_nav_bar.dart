import 'package:flutter/material.dart';
import 'package:internative_blog/state/nav_bar_controller.dart';
import 'package:provider/provider.dart';

GlobalKey<_CustomNavBarItemState> childKey1 = GlobalKey();
GlobalKey<_CustomNavBarItemState> childKey2 = GlobalKey();
GlobalKey<_CustomNavBarItemState> childKey3 = GlobalKey();
List<GlobalKey<_CustomNavBarItemState>> keyList = [
  childKey1,
  childKey2,
  childKey3
];

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int _activeItemIndex = 1;

  void changeActiveIndex(int val) {
    // print('changing actvie index');
    setState(() {
      _activeItemIndex = val;
      keyList.asMap().forEach((key, value) => key == val
          ? value.currentState!.selectItem()
          : value.currentState!.deSelectItem());
    });
    context.read<NavBarController>().changeIndex(val);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xff707070), width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  changeActiveIndex(0);
                });
              },
              child: CustomNavBarItem(
                key: childKey1,
                size: widget.size,
                iconData: Icons.favorite,
              ),
            ),
            GestureDetector(
              onTap: () => changeActiveIndex(1),
              child: CustomNavBarItem(
                key: childKey2,
                size: widget.size,
                iconData: Icons.home,
                startWith: true,
              ),
            ),
            GestureDetector(
              onTap: () => changeActiveIndex(2),
              child: CustomNavBarItem(
                key: childKey3,
                size: widget.size,
                iconData: Icons.person,
              ),
            ),

            // Spacer(),
            // Icon(
            //   Icons.favorite,
            //   size: size.height / 20,
            // ),
            // Spacer(),
            // Icon(
            //   Icons.home,
            //   size: size.height / 20,
            // ),
            // Spacer(),
            // Icon(
            //   Icons.person,
            //   size: size.height / 20,
            // ),
            // Spacer(),
          ],
        ),
      ),
    );
  }
}

class CustomNavBarItem extends StatefulWidget {
  CustomNavBarItem({
    Key? key,
    required this.size,
    this.isActive = false,
    required this.iconData,
    this.startWith,
  }) : super(key: key);
  bool? startWith;
  final Size size;
  bool isActive;
  IconData iconData;
  @override
  State<CustomNavBarItem> createState() => _CustomNavBarItemState();
}

class _CustomNavBarItemState extends State<CustomNavBarItem>
    with TickerProviderStateMixin {
  void printKey() {
    print('in the child widget');
    print(widget.key);
  }

  late Animation<Color?> colorAnimation;
  late AnimationController controller;
  late Animation<double?> positionAnimation;

  void selectItem() {
    controller.forward();
  }

  void deSelectItem() {
    controller.reverse();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this)
      ..addListener(() {
        setState(() {});
      });
    if (widget.startWith != null) {
      setState(() {
        selectItem();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    positionAnimation = Tween<double>(begin: 0, end: 10).animate(
        CurvedAnimation(
            parent: controller,
            curve: Curves.bounceOut,
            reverseCurve: Curves.bounceIn));
    colorAnimation = ColorTween(
      begin: Theme.of(context).colorScheme.secondary,
      end: Theme.of(context).colorScheme.primary,
    ).animate(controller);

    return Transform.translate(
      offset: Offset(0.0, -positionAnimation.value!),
      child: Icon(
        widget.iconData,
        color: colorAnimation.value,
        size: widget.size.height / 20,
      ),
    );
  }
}
