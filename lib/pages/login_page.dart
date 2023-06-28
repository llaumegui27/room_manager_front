import 'package:flutter/material.dart';
import 'package:room_manager/pages/sign_in_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  static const headers = {
    'Content-Type': 'application/json'
  };
  
  final _formKey = GlobalKey<FormState>();

  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    mailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Connexion"),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Connectez-vous",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        hintText: "Entrez votre e-mail",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Renseignez votre e-mail";
                        }
                        return null;
                      },
                      controller: mailController,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: "Entrez votre mot de passe",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Renseignez votre mot de passe";
                        }
                        return null;
                      },
                      controller: passwordController,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final mail = mailController.text;
                          final password = passwordController.text;

                          final url = Uri.parse("http://10.0.2.2:8000/login");
                          var body = jsonEncode({"mail": mail, "password": password});
                          final response = await http.post(
                            url,
                            headers: headers,
                            body: body,
                          );
                          print('Response status code: ${response.statusCode}');
                          print('Response body: ${response.body}');

                          if (response.statusCode == 200) {
                            final jsonResponse = jsonDecode(response.body);
                            final bool success = jsonResponse['etat'];
                            final String message = jsonResponse['message'];

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Connexion réussie.")),
                              );
                              print("Connexion réussi de $mail avec le mdp $password");
                              // Effectuez d'autres actions, par exemple, naviguez vers une autre page
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message)),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Utilisateur introuvable.")),
                            );
                            print("Connexion échoué $mail avec le mdp $password");
                          }
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                      },
                      child: Text("Se connecter"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignInPage()),
                        );
                      },
                      child: const Text(
                        "Vous n'avez pas de compte ? S'inscrire ici",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
