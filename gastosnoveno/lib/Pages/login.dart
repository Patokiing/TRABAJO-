import 'package:flutter/material.dart';
import 'package:gastosnoveno/Utils/Ambiente.dart';
import 'package:quickalert/quickalert.dart';
import 'dart:convert';
import 'package:gastosnoveno/Models/LoginResponse.dart';
import 'package:gastosnoveno/Pages/Home.dart';
import 'package:http/http.dart' as http;

class login extends StatefulWidget {
  //const login({super.key});
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController txtUser = TextEditingController();
  TextEditingController txtPass = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    'https://pic.pngsucai.com/00/07/21/714bfdc17ab4016f.webp',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: txtUser,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: txtPass,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _login,
                        child: const Text(
                          'Acceder',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}login'),
        body: jsonEncode(<String, dynamic>{
          'email': txtUser.text,
          'password': txtPass.text,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final responseJson = jsonDecode(response.body);
      final loginResponse = LoginResponse.fromJson(responseJson);

      if (loginResponse.acceso == "Ok") {
        Ambiente.id_usuario = loginResponse.idUsuario;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        _showErrorAlert();
      }
    } catch (e) {
      _showErrorAlert();
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Oops...',
      text: 'Usuario o contraseña incorrecta.',
    );
  }
}
