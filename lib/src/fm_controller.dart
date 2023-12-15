import 'package:flutter/foundation.dart';
import 'package:form_handler/src/fm_fields.dart';
import 'package:meta/meta.dart';

class FmController {
  @mustBeOverridden
  FmFields get fields => throw UnimplementedError();

  FmController() {
    for (var field in fields.toMap().values) {
      field.addListener(notifyListeners);
    }
  }

  Map<String, dynamic> toMap() {
    return fields.toMap().map((key, field) {
      final raw = field.value ?? field.defaultValue;
      final value = raw == null ? null : (field as dynamic).map?.call(raw) ?? raw;
      return MapEntry(key, value);
    });
  }

  bool validate() {
    for (var field in fields.toMap().values) {
      if (field.error != null) {
        return false;
      }
    }
    return true;
  }

  final List<VoidCallback> _listeners = [];

  void addListener(VoidCallback cb) {
    _listeners.add(cb);
  }

  @protected
  void notifyListeners() {
    for (var f in _listeners) {
      f();
    }
  }

  dispose() {
    for (var field in fields.toMap().values) {
      field.dispose();
    }
  }
}
