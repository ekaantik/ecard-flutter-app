import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';


class ContactList extends StatelessWidget {
  final Map<String, String> contactMap;
  final BoxConstraints constraints;
  final Function(int index)? onTapName;

  const ContactList(this.contactMap, this.constraints, this.onTapName,
      {super.key});

  void makePhoneCall(phoneNumber) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (!res!) {
      throw 'Could not make phone call';
    }
  }

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
        final String contactName = contactMap.values.elementAt(index).toString();
        final String contactNumber = contactMap.keys.elementAt(index).toString();
        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: constraints.maxWidth * 0.025),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: constraints.maxHeight * 0.015,
                    height: constraints.maxHeight * 0.015,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  )
                  ,
                SizedBox(
                    width: constraints.maxWidth * 0.025
                ),
                  GestureDetector(
                    onTap: ()=>onTapName!(index),
                    child: Text(
                      contactName,
                      style: TextStyle(
                        fontSize: constraints.maxHeight * 0.025, //5%
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => makePhoneCall(contactNumber),
                    child: const Icon(
                      CupertinoIcons.phone,
                      size: 30,
                    ),
                  )
                ],
              ),
              SizedBox(
                  height: constraints.maxWidth * 0.025
              ),
            ],
          ),
        );
      },
    );
  }
}
