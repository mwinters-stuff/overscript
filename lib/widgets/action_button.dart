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
    return SizedBox.fromSize(
      size: const Size(300, 150),
      child: TextButton(
        onPressed: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 100,
            ),
            // child:
            Text(
              caption,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),
      ),
    );
  }
}
