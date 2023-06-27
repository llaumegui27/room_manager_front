import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
        title: Text("Connexion")
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'E-mail',
                        hintText: "Entrez votre e-mail",
                        border: OutlineInputBorder()
                    ),
                    validator: (value) {
                      if(value == null ||value.isEmpty) {
                        return "renseignez votre e-mail";
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
                      if(value == null ||value.isEmpty) {
                        return "renseignez votre mot de passe";
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
                      onPressed: (){
                        if(_formKey.currentState!.validate()) {
                          final mail = mailController.text;
                          final password = passwordController.text;
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Connexion..."))
                          );
                          FocusScope.of(context).requestFocus(FocusNode());
                          print("Connexion de $mail avec le mdp $password");
                        }
                      },
                      child: Text("Se connecter")
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
