
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parichay_card/views/profile_page.dart';

AppBar homeAppBar(BuildContext context) {
  return AppBar(
    leading: const BackButton(),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: IconButton(
          icon: const Icon(CupertinoIcons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          },
        ),
      ),
    ],
    title: const Text(
      'Your Contacts',
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,
  );
}

