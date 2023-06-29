import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

Widget buildImage() {
  const imageSize = 140.0;

  return ClipOval(
    child: Material(
      child: SizedBox(
        width: imageSize,
        height: imageSize,
        child: imagePath != null
            ? Image(image: NetworkImage(imagePath!), fit: BoxFit.cover)
            : Image.asset('assets/default_user.png', fit: BoxFit.cover),
      ),
    ),
  );
}


  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}