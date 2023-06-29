import 'package:flutter/material.dart';
import 'package:parichay_card/widgets/profile_widget.dart';
import 'package:parichay_card/models/user.dart';
import 'package:parichay_card/widgets/profile_app_bar.dart';

import '../widgets/numbers_widget.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {


    User user =  const User(
      imagePath:
          null,
      name: 'Smith Anderson',
      email: 'smithanderson12@gmail.com',
      about:
          'Hi, I\'m Smith Anderson! I\'m a passionate and driven individual with a thirst for knowledge and a love for challenges. With a strong work ethic and a creative mindset, I strive to continuously grow both personally and professionally, aiming to make a positive impact in everything I do.' , 
          isDarkMode: false,
    );

    return Scaffold(
      appBar: profileAppBar(context),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 24),
          NumbersWidget(),
          const SizedBox(height: 48),
          buildAbout(user),
        ],
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );


  Widget buildAbout(User user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.about,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
