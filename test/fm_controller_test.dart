import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:form_handler/form_handler.dart';

class LoginFormFields extends FmFields {
  final email = FmSimpleTextField(
    required: true,
    defaultValue: "email",
    validator: (v) {
      if (!v!.contains("@")) return "Invalid email";
      return null;
    },
    map: (value) {
      return 1;
    },
  );

  final password = FmSimpleTextField(
    required: true,
    validator: (v) {
      if (v!.length < 6) return "Password must be at least 6 characters";
      return null;
    },
  );

  @override
  Map<String, FmField> toMap() {
    return {
      "email": email,
      "password": password,
    };
  }
}

class LoginForm extends FmController {
  @override
  LoginFormFields fields = LoginFormFields();
}

void main() {
  group('FmController Unit Test :', () {
    test('Initial', () async {
      String? email;
      String? password;

      final form = LoginForm();
      form.addListener(() {
        email = form.fields.email.value;
        password = form.fields.password.value;
      });

      expect(form.fields.email.value, null);
      expect(form.fields.email.error, "Required");
      expect(form.fields.password.value, null);
      expect(form.fields.password.error, "Required");

      // form.fields.email.textController.text = "test";
      form.fields.email.change("test");
      expect(email, "test");
      expect(form.fields.email.value, email);
      expect(form.fields.email.error, "Invalid email");
      expect(password, null);
      expect(form.fields.password.value, null);
      expect(form.fields.password.error, "Required");

      form.fields.email.change("test@gmail.com");
      expect(email, "test@gmail.com");
      expect(form.fields.email.value, email);
      expect(form.fields.email.error, null);
      expect(password, null);
      expect(form.fields.password.value, null);
      expect(form.fields.password.error, "Required");

      form.fields.password.change("12345");
      expect(email, "test@gmail.com");
      expect(form.fields.email.value, "test@gmail.com");
      expect(form.fields.email.error, null);
      expect(password, "12345");
      expect(form.fields.password.value, password);
      expect(form.fields.password.error, "Password must be at least 6 characters");

      form.fields.password.change("123456");
      expect(email, "test@gmail.com");
      expect(form.fields.email.value, email);
      expect(form.fields.email.error, null);
      expect(password, "123456");
      expect(form.fields.password.value, password);
      expect(form.fields.password.error, null);

      print(JsonEncoder.withIndent("  ").convert(form.toMap()));
      // print(form.values());

      await form.dispose();
    });
  });
}
