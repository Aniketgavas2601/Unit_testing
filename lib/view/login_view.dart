import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context,snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: 'Enter Your Email here'),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(hintText: 'Enter Your Password here'),
                  ),
                  TextButton(
                      onPressed: () async {
                        try{
                          final email = _email.text;
                          final password = _password.text;
                         await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value){
                           log("inside then");
                         });
                          //log(userCredential.toString());
                          log("not waiting");
                        }on FirebaseAuthException catch(e){
                          if(e.code == 'user-not-found'){
                            log('user not found');
                          }else if(e.code == 'wrong-password'){
                            log('Wrong password');
                          }
                        }
                      },
                      child: Text('Login')),
                ],
              );
            default: return Text('loading....');
          }
        },
      ),
    );
  }
  
}
