import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/repo/auth_repo.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';

class DeleteAccountBottomSheet extends StatelessWidget {
  const DeleteAccountBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();
    final password = TextEditingController();
    final AuthController auth = Get.find();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login again to delete",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Your account and your data will be permanently deleted.",
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: email,
                decoration:
                    const InputDecoration(hintText: "Email", filled: true),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: password,
                decoration:
                    const InputDecoration(hintText: "password", filled: true),
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () async {
                  final res = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email.value.text,
                          password: password.value.text);
                  if (res.user != null) {
                    auth.deleteAccount(res.user!, (p) {
                      if (p.isSuccess) {
                        Navigator.of(context)..pop()..pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("account could not be deleted")));
                      }
                    });
                  }
                },
                color: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  SizedBox(
                    width: 5,
                  ),
                  Text("OR"),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton(
                  onPressed: () async {
                    final res = await AuthRepo().signInWithGoogle();
                    if (res.isSuccess) {
                      res as Success<UserCredential>;
                      if (res.data.user != null) {
                        auth.deleteAccount(res.data.user!, (p) {
                          if (p.isSuccess) {
                            Get.offAllNamed(Routes.ask);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("account could not be deleted")));
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("account could not be deleted")));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("account could not be deleted")));
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: ProjectImages.googleIcon,
                        height: 24,
                        width: 24,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Google',
                        style: TextStyle(
                            color: ProjectColors.disabled,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
