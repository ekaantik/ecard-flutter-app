import 'package:flutter/material.dart';

import 'home.dart';
import 'calling.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/login.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: const Text(
                'Welcome, '
                '\n Parichay Card',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              // building phone on colum
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                    right: 35,
                    left: 35),
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                          fillColor: Colors.orange.shade300,
                          filled: true,
                          hintText: 'Phone No',
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.black,
                            width: 3,
                          ))),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // sign button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sign In',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w500),
                        ),
                        //icon button
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.lightBlue,
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pushNamed(context, 'register');
                            },
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.orange.shade300,
                          filled: true,
                          hintText: 'OTP',
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.black,
                            width: 3,
                          ))),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const calling()),
                                );
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
