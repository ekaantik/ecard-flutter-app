import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parichay_card/widgets/contact_list.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'contact_page.dart';
import '../widgets/home_app_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // Define the contactMap variable
  Map<String, String> contactMap = {};

  
  final String baseAddress = "http://<ip_address>:8002/";

  //APIs Endpoint
  final String addUserEndpoint = "users/add";
  final String commonContactEndpoint = "users/find_common_contacts";

  final headers = {
      'Content-Type': 'application/json', // Set the content type of the request
      'User-Agent': 'PostmanRuntime/7.32.3',
      'Accept':'*/*',
      'Accept-Encoding':'gzip,deflate,br',
      'Connection' : 'keep-alive'
    };

  //temp
  final String userNum = "+919999999999";

  final MethodChannel callStateChannel = const MethodChannel('call_state_channel');

  @override
  void initState() {
    super.initState();
    checkPermissionAndFetchContacts();
  }


  Future<bool> getContactPermission()   async {
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!(prefs.getBool('contactsUploaded') ?? false)){
      prefs.setBool('contactsUploaded',true);
      //uploadContacts();
    }else{
      //print("Already Uploaded Contacts!");
    }
    //uploadContacts();
  }

  void uploadContacts() async {
    final data = {
      "userNum": userNum,
      "phoneBookNum": contactMap.keys.toList()
    };
    
    await http.post(Uri.parse(baseAddress + addUserEndpoint),headers:headers, body: jsonEncode(data));
  }


  Future<Map<String,String>> getCommonContacts(String contactNumber) async {

    //payload
    final body = {
      "userNum": userNum,
      "userNumToSearch": contactNumber,
    };

    final response = await http.post(Uri.parse(baseAddress+commonContactEndpoint),headers:headers,body : jsonEncode(body));

    // Successful request
    if(response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final commonContactsList = responseBody['commonContacts'];
      Map<String,String> commonContactsMap = {};
      for(String contact in commonContactsList){
          contact = contact.startsWith("+91") ? contact : "+91$contact";
          commonContactsMap[contact] = contactMap[contact] ?? 'Unknown'; 
      }
      return commonContactsMap;
    } 
    
    // Request failed
    else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
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
          appBar: homeAppBar(context),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: constraints.maxWidth * 0.05, //5%
                ),
                Expanded(
                    child: ContactList(
                      contactMap,  
                      constraints,
                      (index) async {
                        print("Opening Common Contact!");
                        await   getCommonContacts(contactMap.keys.elementAt(index)).then((commonContacts) => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContactPage(commonContacts),
                            ),
                          )
                        });
                      }
                    )
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
