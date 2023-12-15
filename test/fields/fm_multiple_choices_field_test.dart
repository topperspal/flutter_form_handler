import "package:flutter_test/flutter_test.dart";
import "package:form_handler/form_handler.dart";

void main() {
  group('FmMultipleChoicesField Unit Test :', () {
    test("Initial value should be null by default", () async {
      final choices = [1, 2, 3];
      final field = FmMultipleChoicesField<int>(choices: choices);

      expect(field.choices, choices);
      expect(field.value, null);
      expect(field.error, null);

      await field.dispose();
    });

    test("choices should be unmodifiable", () async {
      final field = FmMultipleChoicesField<int>(choices: []);

      expect(
        () => field.choices.add(4),
        throwsA(
          isA<UnsupportedError>()
              .having((p0) => p0.message, "Error message", "Cannot add to an unmodifiable list"),
        ),
      );

      await field.dispose();
    });

    test("value should be an unmodifiable list", () async {
      final field = FmMultipleChoicesField<int>(choices: []);

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
      final field = FmMultipleChoicesField<int>(choices: choices, value: [1]);

      expect(field.value, [1]);
      await field.dispose();
    });

    test("It should return updated value after change(...) function called on it", () async {
      final choices = [1, 2, 3];
      final field = FmMultipleChoicesField<int>(choices: choices);

      expect(field.value, null);

      field.change([2]);
      expect(field.value, [2]);

      await field.dispose();
    });

    test("It should add item to the value", () async {
      final choices = [1, 2, 3];
      final field = FmMultipleChoicesField<int>(choices: choices);

      expect(field.value, null);
      field.add(1);
      expect(field.value, [1]);

      await field.dispose();
    });

    test("It should remove item to the value", () async {
      final choices = [1, 2, 3];
      final field = FmMultipleChoicesField<int>(choices: choices, value: [1]);

      expect(field.value, [1]);
      field.remove(1);
      expect(field.value, []);

      await field.dispose();
    });

    test("It should toggle item to the value", () async {
      final choices = [1, 2, 3];
      final field = FmMultipleChoicesField<int>(choices: choices, value: [1]);

      expect(field.value, [1]);
      field.toggle(1);
      expect(field.value, []);
      field.toggle(1);
      expect(field.value, [1]);

      await field.dispose();
    });

    test("It should notify changes to listeners", () async {
      final choices = [1, 2, 3];
      final field = FmMultipleChoicesField<int>(choices: choices);

      List<int>? value;

      field.addListener(() {
        value = field.value;
      });

      expect(field.value, value);
      field.change([1]);
      expect(value, [1]);
      expect(field.value, value);

      field.change([2]);
      expect(value, [2]);
      expect(field.value, value);

      await field.dispose();
    });

    test('If value is required and it is null, error should be "Required"', () async {
      final choices = [1, 2, 3];
      final field = FmMultipleChoicesField<int>(choices: choices, required: true);

      expect(field.value, null);
      expect(field.error, "Required");

      await field.dispose();

      final field2 = FmMultipleChoicesField<int>(
        choices: choices,
        value: [1],
        required: true,
      );

      expect(field2.value, [1]);
      expect(field2.error, null);

      await field2.dispose();
    });

    test('It should call validate method properly but after checking if it is required', () async {
      final choices = [1, 2, 3];
      final field = FmMultipleChoicesField<int>(
        choices: choices,
        required: true,
        validator: (value) {
          if (value!.length < 2) return "Too short";
          return null;
        },
      );

      expect(field.value, null);
      expect(field.error, "Required");

      field.change([1]);
      expect(field.value, [1]);
      expect(field.error, "Too short");

      await field.dispose();
    });
  });
}
