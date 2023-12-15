import "package:flutter_test/flutter_test.dart";
import "package:form_handler/form_handler.dart";

void main() {
  group('FmField Unit Test :', () {
    test("Initial value should be null by default", () async {
      final field = FmField<int>();
      expect(field.value, null);
      await field.dispose();
    });

    test("It should return initial value if provided in the constructor", () async {
      final field = FmField<int>(value: 1);
      expect(field.value, 1);
      await field.dispose();
    });

    test("It should return updated value after change(...) function called on it", () async {
      final field = FmField<int>();
      expect(field.value, null);
      field.change(1);
      expect(field.value, 1);
      await field.dispose();
    });

    test("It should notify changes to listeners", () async {
      final field = FmField<int>();
      int? value;

      field.addListener(() {
        value = field.value;
      });

      expect(field.value, value);
      field.change(1);
      expect(field.value, value);

      field.change(2);
      expect(field.value, 2);

      await field.dispose();
    });

    test('If value is required and it is null, error should be "Required"', () async {
      final field = FmField<int>(required: true);
      expect(field.value, null);
      expect(field.error, "Required");

      await field.dispose();

      final field2 = FmField<int>(value: 1, required: true);
      expect(field2.value, 1);
      expect(field2.error, null);

      await field2.dispose();
    });

    test('It should call validate method properly but after checking if it is required', () async {
      final field = FmField<int>(
          required: true,
          validator: (value) {
            if (value! < 10) return "Too short";
            return null;
          });
      expect(field.value, null);
      expect(field.error, "Required");

      field.change(1);
      expect(field.value, 1);
      expect(field.error, "Too short");

      await field.dispose();
    });
  });
}
