import "package:flutter_test/flutter_test.dart";
import "package:form_handler/form_handler.dart";

void main() {
  group('FmSingleChoiceField Unit Test :', () {
    test("Initial value should be null by default", () async {
      final choices = [1, 2, 3];
      final field = FmSingleChoiceField<int>(choices: choices);

      expect(field.choices, choices);
      expect(field.value, null);
      expect(field.error, null);

      await field.dispose();
    });

    test("choices should be unmodifiable", () async {
      final field = FmSingleChoiceField<int>(choices: []);

      expect(
        () => field.choices.add(4),
        throwsA(
          isA<UnsupportedError>()
              .having((p0) => p0.message, "Error message", "Cannot add to an unmodifiable list"),
        ),
      );

      await field.dispose();
    });

    test("It should return initial value if provided in the constructor", () async {
      final choices = [1, 2, 3];
      final field = FmSingleChoiceField<int>(choices: choices, value: choices[1]);

      expect(field.value, choices[1]);
      await field.dispose();
    });

    test("It should return updated value after change(...) function called on it", () async {
      final choices = [1, 2, 3];
      final field = FmSingleChoiceField<int>(choices: choices);

      expect(field.value, null);

      field.change(choices[1]);
      expect(field.value, choices[1]);

      await field.dispose();
    });

    test("It should notify changes to listeners", () async {
      final choices = [1, 2, 3];
      final field = FmSingleChoiceField<int>(choices: choices);

      int? value;

      field.addListener(() {
        value = field.value;
      });

      expect(field.value, value);
      field.change(choices[1]);
      expect(value, choices[1]);
      expect(field.value, value);

      field.change(choices[2]);
      expect(value, choices[2]);
      expect(field.value, value);

      await field.dispose();
    });

    test('If value is required and it is null, error should be "Required"', () async {
      final choices = [1, 2, 3];
      final field = FmSingleChoiceField<int>(choices: choices, required: true);

      expect(field.value, null);
      expect(field.error, "Required");

      await field.dispose();

      final field2 = FmSingleChoiceField<int>(
        choices: choices,
        value: choices[1],
        required: true,
      );

      expect(field2.value, choices[1]);
      expect(field2.error, null);

      await field2.dispose();
    });

    test('It should call validate method properly but after checking if it is required', () async {
      final choices = [1, 2, 3];
      final field = FmSingleChoiceField<int>(
        choices: choices,
        required: true,
        validator: (value) {
          if (value! < 10) return "Too short";
          return null;
        },
      );

      expect(field.value, null);
      expect(field.error, "Required");

      field.change(1);
      expect(field.value, 1);
      expect(field.error, "Too short");

      await field.dispose();
    });
  });
}
