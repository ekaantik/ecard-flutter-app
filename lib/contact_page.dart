import 'package:flutter/material.dart';
import 'package:parichay_card/contact_list_view.dart';

class ContactPage extends StatefulWidget {
  final Map<String, String> commonContactMap;
  const ContactPage(this.commonContactMap, {super.key});
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints constraints) {
        return Scaffold(
            body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: constraints.maxWidth * 0.05, //5%
              ),
              Text(
                "Common Contacts",
                style: TextStyle(
                  fontSize: constraints.maxHeight * 0.035, //5%
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: constraints.maxWidth * 0.05, //5%
              ),
              Expanded(
                  child: ContactListView(
                      widget.commonContactMap, constraints, null))
            ],
          ),
        ));
      },
    );
  }
}
