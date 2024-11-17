import 'package:flutter/material.dart';

class Globaltextformfield extends StatelessWidget {
  final String hinttext;
  final String titel;
  final VoidCallback? OnTap;
  final String? fieldtext; // Optional fieldtext parameter
  final keyboardtype;
  final TextEditingController Mycontroller;
  final String? Function(String?)? validator;
  final bool obscuretext;

  const Globaltextformfield({
    super.key,
    required this.hinttext,
    required this.Mycontroller,
    this.validator,
    this.obscuretext = false,
    this.fieldtext,
    required this.titel,
    this.OnTap,
    this.keyboardtype,
  });

  @override
  Widget build(BuildContext context) {
    // Set the controller's text only if fieldtext is provided
    if (fieldtext != null) {
      Mycontroller.text = fieldtext!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                titel,
                style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 29, 136, 91),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TextFormField(
              keyboardType: keyboardtype,
              onTap: OnTap,
              validator: validator,
              controller: Mycontroller,
              obscureText: obscuretext,
              decoration: InputDecoration(
                hintText: hinttext,
                hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                filled: true,
                fillColor: const Color.fromARGB(111, 238, 238, 238),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 5, 111, 87))),
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
