import 'package:flutter/material.dart';

class CredInput extends StatefulWidget {
  CredInput({
    required this.label,
    required this.icon,
    this.suffixIcon,
    this.suffixIcon2,
    this.obscureText = false,
    Key? key,
    required TextEditingController inputController,
  })  : _inputController = inputController,
        super(key: key);

  final TextEditingController _inputController;
  final String label;
  final Icon icon;
  final Icon? suffixIcon;
  final Icon? suffixIcon2;
  bool obscureText;

  @override
  State<CredInput> createState() => _CredInputState();
}

class _CredInputState extends State<CredInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: FractionallySizedBox(
        alignment: Alignment.center,
        widthFactor: 0.85,
        child: Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              floatingLabelStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary),
              // iconColor: Theme.of(context).colorScheme.secondary,
              labelStyle:
                  TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          child: TextField(
            obscureText: widget.obscureText,
            controller: widget._inputController,
            decoration: InputDecoration(
                suffixIcon: widget.suffixIcon != null
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            widget.obscureText = !widget.obscureText;
                          });
                        },
                        icon: widget.obscureText
                            ? widget.suffixIcon!
                            : widget.suffixIcon2!)
                    : null,
                prefixIcon: widget.icon,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                label: Text(widget.label)),
          ),
        ),
      ),
    );
  }
}
