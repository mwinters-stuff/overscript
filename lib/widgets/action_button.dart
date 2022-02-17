import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    required this.caption,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final String caption;
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 100,
          onPressed: onPressed,
          icon: Icon(
            icon,
          ),
        ),
        Text(
          caption,
          style: Theme.of(context).textTheme.titleLarge,
        )
      ],
    );
  }
}
