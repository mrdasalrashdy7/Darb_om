import 'package:darb/controller/login_controller.dart';
import 'package:darb/customfunction/validat.dart';
import 'package:darb/view/customwedgits/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  final LoginController Lcontroller = Get.put(LoginController());
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Form(
            key: formstate,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/logo.jpg",
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    hinttext: "البريد الإلكتروني",
                    Mycontroller: Lcontroller.email,
                    validator: (val) => validateEmail(val),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    hinttext: "كلمة المرور",
                    Mycontroller: Lcontroller.password,
                    validator: (val) => validatePassword(val),
                    obscuretext: true,
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    return Lcontroller.isLoading.value
                        ? CircularProgressIndicator()
                        : MaterialButton(
                            onPressed: () async {
                              if (formstate.currentState!.validate()) {
                                await Lcontroller.login();
                              }
                            },
                            child: const Text("Login"),
                            color: Colors.orange,
                          );
                  }),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      Get.offNamed("signup");
                    },
                    child: Text("Don't have an account? Sign up"),
                  ),
                  Obx(() {
                    return Lcontroller.errorMessage.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Lcontroller.errorMessage.value,
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
