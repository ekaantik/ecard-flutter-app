

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:phone_call/phone_call.dart';
import 'package:url_launcher/url_launcher.dart';


class calling extends StatelessWidget {
  const calling({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home:  MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact>? contacts ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhoneData();
  }
  void getPhoneData() async{
    if(await FlutterContacts.requestPermission()){
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      setState(() {});
    }

  }
  String get _url => 'contacts';



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: const Text(
          "Calling",
          style: TextStyle(color: Colors.white) ,

        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,

      ),
      body:( contacts) == null ? Center(child: CircularProgressIndicator())
          : ListView.builder(
          itemCount: contacts!.length,
          itemBuilder: (BuildContext context, index){
            Uint8List? image = contacts![index].photo;
            String num = (contacts![index].phones.isNotEmpty) ? (contacts![index].phones.first.number) : "--";
            return ListTile(
                leading: (image==null)? CircleAvatar(child: Icon(Icons.person),) : CircleAvatar(
                  backgroundImage: MemoryImage(image),
                ),
                title: Text(
                    "${contacts![index].name.first} ${contacts![index].name.last}"),
                subtitle: Text(num),
                onTap: ()
                async{
                  await
                  launchUrl(FlutterPhoneDirectCaller.callNumber('tel ${num}') as Uri);
                }
            );
          }
      ),);
  }
}