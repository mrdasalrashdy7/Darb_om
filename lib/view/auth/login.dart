import 'package:darb/controller/login_controller.dart';
import 'package:darb/customfunction/validat.dart';
import 'package:darb/view/customwedgits/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  LoginController Lcontroller = Get.put(LoginController());
  GlobalKey<FormState> formstate = GlobalKey();
  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Form(
              key: formstate,
              child: (ListView(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Image.asset(
                    "assets/logo.jpg",
                    width: 300,
                    height: 300,
                  ),
                  CustomTextFormField(
                    hinttext: "البريد الإلكتروني",
                    Mycontroller: Lcontroller.email,
                    validator: (val) => validateEmail(val),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextFormField(
                    hinttext: "كلمة المرور",
                    Mycontroller: Lcontroller.password,
                    validator: (val) => validatePassword(val),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () {
                      if (formstate.currentState!.validate()) {
                        Lcontroller.login();
                      }
                    },
                    child: const Text("Login"),
                    color: Colors.orange,
                  ),
                  InkWell(
                    onTap: () {
                      Get.offNamed("signup");
                    },
                    child: Center(child: Text("Dont have account? Sign up")),
                  )
                ],
              )))),
    );
  }
}
