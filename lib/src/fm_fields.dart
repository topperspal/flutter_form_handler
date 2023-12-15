import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

abstract class FmFields {
  Map<String, FmField> toMap();
}

class FmField<T> {
  FmField({
    this.required = false,
    String? Function(T? value)? validator,
    this.map,
    T? value,
    this.defaultValue,
  }) : assert(!required || defaultValue == null,
            "You can't set a default value for a required field") {
    _value = value;
    _validator = validator;

    _validate();
  }

  final bool required;

  T? _value;
  final T? defaultValue;
  String? _error;
  T? get value => _value;
  String? get error => _error;

  final List<VoidCallback> _listeners = [];
  String? Function(T? value)? _validator;

  @internal
  final Function(T value)? map;

  void addListener(VoidCallback cb) {
    _listeners.add(cb);
  }

  void _notifyListeners() {
    for (var f in _listeners) {
      f();
    }
  }

  void change(T? value) {
    _value = value;
    _validate();
    _notifyListeners();
  }

  void _validate() {
    if (required && value == null) {
      _error = "Required";
      return;
    }
    _error = _validator?.call(value);
  }

  FutureOr<void> dispose() {
    _listeners.clear();
  }
}

abstract class FmTextField<T> extends FmField<T> {
  TextEditingController get textController;

  String get text;

  @override
  FutureOr<void> dispose() {
    textController.dispose();
    super.dispose();
  }
}

class FmSimpleTextField extends FmField<String> implements FmTextField<String> {
  @override
  final TextEditingController textController = TextEditingController();

  FmSimpleTextField({
    super.required,
    super.value,
    super.defaultValue,
    super.validator,
    super.map,
  }) {
    if (value != null) {
      textController.text = value!;
    }

    textController.addListener(() {
      if (_value != textController.text) {
        change(textController.text);
      } else {
        _validate();
        _notifyListeners();
      }
    });

    _validate();
  }

  @override
  void change(String? value) {
    if (value != textController.text) {
      textController.text = value ?? "";
    } else {
      super.change(value);
    }
  }

  @override
  FutureOr<void> dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  void _validate() {
    if (this.required && text.isEmpty) {
      _error = "Required";
    } else {
      _error = super._validator?.call(value);
    }
  }

  @override
  String get text => textController.text;
}

class FmIntTextField extends FmField<int> implements FmTextField<int> {
  @override
  final TextEditingController textController = TextEditingController();

  FmIntTextField({
    super.required,
    super.value,
    super.defaultValue,
    super.validator,
    super.map,
  }) {
    if (value != null) {
      textController.text = value.toString();
    }

    textController.addListener(() {
      final parsed = int.tryParse(textController.text);

      if (_value != parsed) {
        change(parsed);
      } else {
        _validate();
        _notifyListeners();
      }
    });
  }

  @override
  void change(int? value) {
    if (value != int.tryParse(textController.text)) {
      textController.text = value?.toString() ?? "";
    } else {
      super.change(value);
    }
  }

  @override
  void _validate() {
    if (value == null && textController.text.isNotEmpty) {
      _error = "Invalid";
    } else if (this.required && value == null) {
      _error = "Required";
    } else {
      _error = _validator?.call(value);
    }
  }

  @override
  String get text => textController.text;
}

class FmNumTextField extends FmField<num> implements FmTextField<num> {
  @override
  final TextEditingController textController = TextEditingController();

  FmNumTextField({
    super.required,
    super.value,
    super.defaultValue,
    super.validator,
    super.map,
  }) {
    if (value != null) {
      textController.text = value.toString();
    }

    textController.addListener(() {
      final parsed = int.tryParse(textController.text);

      if (_value != parsed) {
        change(parsed);
      } else {
        _validate();
        _notifyListeners();
      }
    });
  }

  @override
  void change(num? value) {
    if (value != int.tryParse(textController.text)) {
      textController.text = value?.toString() ?? "";
    } else {
      super.change(value);
    }
  }

  @override
  void _validate() {
    if (value == null && textController.text.isNotEmpty) {
      _error = "Invalid";
    } else if (this.required && value == null) {
      _error = "Required";
    } else {
      _error = _validator?.call(value);
    }
  }

  @override
  String get text => textController.text;
}

class FmSingleChoiceField<T> extends FmField<T> {
  List<T> _choices = [];
  List<T> get choices => _choices;

  FmSingleChoiceField({
    required List<T> choices,
    super.required,
    super.value,
    super.defaultValue,
    super.validator,
    super.map,
  }) {
    this._choices = List.unmodifiable(choices);
  }

  @override
  void _validate() {
    if (this.required && value == null) {
      _error = "Required";
    } else {
      _error = super._validator?.call(value);
    }
  }
}

class FmMultipleChoicesField<T> extends FmField<List<T>> {
  List<T> _choices = [];
  List<T> get choices => _choices;

  FmMultipleChoicesField({
    required List<T> choices,
    super.required,
    super.value,
    super.defaultValue,
    super.validator,
    super.map,
  }) {
    this._choices = List<T>.unmodifiable(choices);
  }

  @override
  List<T>? get value => _value == null ? null : List.unmodifiable(_value!);

  void add(T choice) {
    if (_value == null) {
      _value = [choice];
    } else {
      _value!.add(choice);
    }
    _validate();
    _notifyListeners();
  }

  void remove(T choice) {
    if (_value != null) {
      _value!.remove(choice);
      _validate();
      _notifyListeners();
    }
  }

  void toggle(T choice) {
    if (_value == null) {
      _value = [choice];
    } else {
      if (_value!.contains(choice)) {
        _value!.remove(choice);
      } else {
        _value!.add(choice);
      }
    }
    _validate();
    _notifyListeners();
  }

  bool contains(T choice) {
    return _value?.contains(choice) ?? false;
  }
}
