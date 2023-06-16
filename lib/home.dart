import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:parichay_card/contact_list_view.dart';
import 'package:permission_handler/permission_handler.dart';

import 'contact_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Define the contactMap variable
  Map<String, String> contactMap = {};
  @override
  void initState() {
    super.initState();
    checkPermissionAndFetchContacts();
  }

  Future<bool> getContactPermission() async {
    final PermissionStatus permissionStatus =
        await Permission.contacts.request();
    return permissionStatus.isGranted;
  }

  void checkPermissionAndFetchContacts() async {
    bool hasPermission = await getContactPermission();
    if (hasPermission) {
      fetchContacts();
    } else {
      // Handle case when permission is not granted
      // Display an error message or request permission again
    }
  }

  void fetchContacts() async {
    List<Contact> contacts = await getContactList();
    Map<String, String> map = {};
    for (Contact contact in contacts) {
      Iterable<Item>? phones = contact.phones;
      if (phones != null && phones.isNotEmpty) {
        String phoneNumber = phones.first.value ?? '';
        String displayName = contact.displayName ?? '';
        //print('Key: $phoneNumber, Value: $displayName');
        map[phoneNumber] = displayName;
      }
    }
    setState(() {
      contactMap = map;
    });
  }

  Future<List<Contact>> getContactList() async {
    List<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);
    return contacts;
  }

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
                "Contacts On Parichay Card",
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
                      contactMap,
                      constraints,
                      () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ContactPage({
                                        "1": "Shivam",
                                        "2": "Archit",
                                        "3": "Atul",
                                        "4": "Harsh"
                                      })),
                            )
                          }))
            ],
          ),
        ));
      },
    );
  }
}
