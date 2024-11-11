import 'package:darb/controller/signup_controller.dart';
import 'package:darb/customfunction/validat.dart';
import 'package:darb/view/customwedgits/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  GlobalKey<FormState> formstate = GlobalKey();
  SignupController Scontroller = Get.put(SignupController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Form(
            key: formstate,
            child: Column(
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
                  hinttext: "اسم المستخدم",
                  Mycontroller: Scontroller.name,
                  validator: (val) {
                    validinput(val, 5, 50);
                  },
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  hinttext: "الريد الالكتروني",
                  Mycontroller: Scontroller.email,
                  validator: (val) => validateEmail(val),
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                    hinttext: "رقم الهاتف",
                    Mycontroller: Scontroller.phone,
                    validator: (val) => validatePhone(val)),
                const SizedBox(height: 30),
                CustomTextFormField(
                  hinttext: "كلمة المرور",
                  Mycontroller: Scontroller.password,
                  validator: (val) => validatePassword(val),
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  hinttext: "تأكيد كلمة المرور",
                  Mycontroller: Scontroller.conirmpassword,
                  validator: (val) =>
                      validateConfirmPassword(Scontroller.password.text, val),
                ),
                const SizedBox(height: 10),
                Obx(
                  () {
                    return Center(
                      child: Wrap(
                        children: [
                          RadioListTile(
                            selected:
                                Scontroller.roleselected.value == "customer",
                            title: Text("Customer"),
                            value: "customer",
                            groupValue: Scontroller.roleselected.value,
                            onChanged: (val) {
                              Scontroller.roleselected.value = val.toString();
                            },
                          ),
                          RadioListTile(
                            selected:
                                Scontroller.roleselected.value == "driver",
                            title: Text("Driver"),
                            value: "driver",
                            groupValue: Scontroller.roleselected.value,
                            onChanged: (val) {
                              Scontroller.roleselected.value = val.toString();
                            },
                          ),
                          RadioListTile(
                            selected:
                                Scontroller.roleselected.value == "company",
                            title: Text("Company"),
                            value: "company",
                            groupValue: Scontroller.roleselected.value,
                            onChanged: (val) {
                              Scontroller.roleselected.value = val.toString();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                InkWell(
                  onTap: () {
                    Get.offNamed("login");
                  },
                  child: Text("Dont have account? Login"),
                )
              ],
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (formstate.currentState!.validate()) {
                Scontroller.signup();
              }
            },
            child: const Text("sign up"),
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}
