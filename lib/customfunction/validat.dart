String? validinput(String? val, int min, int max) {
  if (val == null || val.isEmpty) {
    return "الحقل فارغ";
  }
  if (val.length < min) {
    return "أقل عدد من الحروف هو $min";
  }
  if (val.length > max) {
    return "لقد تجاوزت الحد وهو $max";
  }
  return null;
}

String? validateEmail(String? val) {
  if (val == null || val.isEmpty) {
    return "الحقل فارغ";
  }
  final emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  final regExp = RegExp(emailPattern);

  if (!regExp.hasMatch(val)) {
    return "البريد الإلكتروني غير صحيح";
  }
  return null;
}

String? validatePassword(
  String? val,
) {
  if (val == null || val.isEmpty) {
    return "الحقل فارغ";
  }
  if (val.length < 8) {
    return "كلمة المرور يجب أن تكون على الأقل 8 حروف";
  }
  if (val.length > 50) {
    return "كلمة المرور يجب أن لا تتجاوز 50 حروف";
  }
  final passwordPattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
  final regExp = RegExp(passwordPattern);

  if (!regExp.hasMatch(val)) {
    return "كلمة المرور يجب أن تحتوي على حروف وأرقام";
  }
  return null;
}

String? validateConfirmPassword(String? password, String? confirmPassword) {
  if (confirmPassword == null || confirmPassword.isEmpty) {
    return "تأكيد كلمة المرور فارغ";
  }
  if (password != confirmPassword) {
    return "كلمتا المرور غير متطابقتين";
  }
  return null;
}

String? validatePhone(String? val) {
  if (val == null || val.isEmpty) {
    return "رقم الهاتف فارغ";
  }
  final phonePattern = r'^\d{8,15}$'; // Adjust min and max length as needed
  final regExp = RegExp(phonePattern);

  if (!regExp.hasMatch(val)) {
    return "رقم الهاتف غير صحيح";
  }
  return null;
}

String? validateLocation(String? val, controller) {
  if (val == null || val.isEmpty) {
    return 'Location cannot be empty';
  }

  final latLongPattern = RegExp(r'^-?\d+(\.\d+)?,-?\d+(\.\d+)?$');
  final googleMapsPattern = RegExp(r'@(-?\d+(\.\d+)?),(-?\d+(\.\d+)?)');

  if (latLongPattern.hasMatch(val)) {
    // Valid latitude/longitude format
    return null;
  } else if (googleMapsPattern.hasMatch(val)) {
    // Extract latitude and longitude from the Google Maps link
    final match = googleMapsPattern.firstMatch(val);
    if (match != null) {
      final latitude = match.group(1);
      final longitude = match.group(3);
      if (latitude != null && longitude != null) {
        // Update the controller with the extracted lat/long
        controller.text = '$latitude,$longitude';
        return null;
      }
    }
    return 'Invalid Google Maps link';
  } else {
    // Neither lat/long nor Google Maps link
    return 'Enter a valid latitude/longitude or Google Maps link';
  }
}
