import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar profileAppBar(BuildContext context) {
  const icon = CupertinoIcons.moon_stars;

  return AppBar(
    leading: const BackButton(
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        icon: const Icon(icon),
        onPressed: () {},
      ),
    ],
    title: const Text(
      'Profile',
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,
  );
}