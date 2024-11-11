import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hinttext;
  final TextEditingController Mycontroller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscuretext;
  Function(String)? onchange;

  CustomTextFormField(
      {super.key,
      required this.hinttext,
      required this.Mycontroller,
      this.validator,
      this.keyboardType,
      this.onchange,
      this.obscuretext = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              hinttext,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
              keyboardType: keyboardType,
              onChanged: onchange,
              obscureText: obscuretext,
              validator: validator,
              controller: Mycontroller,
              decoration: InputDecoration(
                hintText: "$hinttext",
                hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                filled: true,
                fillColor: const Color.fromARGB(111, 238, 238, 238),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.orange,
                    )),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                      width: 2, color: Color.fromARGB(255, 5, 111, 87)),
                ),
              )),
        ],
      ),
    );
  }
}
