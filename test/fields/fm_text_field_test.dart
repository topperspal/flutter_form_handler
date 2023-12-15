import "package:flutter_test/flutter_test.dart";
import "package:form_handler/form_handler.dart";

void main() {
  group('FmTextField Unit Test :', () {
    test("Initial value should be null by default", () async {
      final field = FmSimpleTextField();
      expect(field.value, null);
      await field.dispose();
    });

    test("It should return initial value if provided in the constructor", () async {
      final field = FmSimpleTextField(value: "Hi");
      expect(field.value, "Hi");
      await field.dispose();
    });

    test("It should return updated value after change(...) function called on it", () async {
      final field = FmSimpleTextField();
      expect(field.value, null);
      field.change("Hi");
      expect(field.value, "Hi");
      await field.dispose();
    });

    test("It should notify changes to listeners", () async {
      final field = FmSimpleTextField();
      String? value;

      field.addListener(() {
        value = field.value;
      });

      expect(field.value, value);
      field.change("Hi");
      expect(field.value, value);

      field.change("Bye");
      expect(field.value, "Bye");

      await field.dispose();
    });

    test("It should change value and text bidirectionally", () async {
      final field = FmSimpleTextField();
      String? value;

      field.addListener(() {
        value = field.value;
      });

      expect(field.value, value);
      field.change("Hi");
      expect(field.value, value);
      expect(field.text, value);

      field.textController.text = "Bye";
      expect(value, "Bye");
      expect(field.value, value);
      expect(field.text, value);

      await field.dispose();
    });

    test('If value is required and it is null, error should be "Required"', () async {
      final field = FmSimpleTextField(required: true);
      expect(field.value, null);
      expect(field.error, "Required");

      await field.dispose();

      final field2 = FmSimpleTextField(value: "Hi", required: true);
      expect(field2.value, "Hi");
      expect(field2.text, "Hi");
      expect(field2.error, null);

      await field2.dispose();
    });

    test('It should call validate method properly but after checking if it is required', () async {
      final field = FmSimpleTextField(
          required: true,
          validator: (value) {
            if (value == "Hi") return "Bye";
            return null;
          });
      expect(field.value, null);
      expect(field.error, "Required");

      field.change("Hi");
      expect(field.value, "Hi");
      expect(field.error, "Bye");

      await field.dispose();
    });
  });
}
