import 'package:flutter/material.dart';

class ContactListView extends StatelessWidget {
  final Map<String, String> contactMap;
  final BoxConstraints constraints;
  final Function()? onTap;

  const ContactListView(
      this.contactMap,
      this.constraints,
      this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: contactMap.length,
      separatorBuilder: (context, index) => const Divider(
        color: Colors.grey,
        height: 1,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: onTap,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: constraints.maxWidth * 0.025),
                Text(
                  contactMap.values.elementAt(index).toString(),
                  style: TextStyle(
                    fontSize: constraints.maxHeight * 0.025, //5%
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                    height:
                        constraints.maxWidth * 0.025), // Add space using SizedBox
              ],
            ),
          ),
        );
      },
    );
  }
}
