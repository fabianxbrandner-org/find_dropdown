import 'rxdart/behavior_subject.dart';
import 'package:flutter/material.dart';

/// The Bloc class handling the state of the dropdown
class FindDropdownBloc<T> {
  /// controller for the text field
  final textController = TextEditingController();

  /// the selected element
  final selected$ = BehaviorSubject<T?>();
  // final _validateMessage$ = BehaviorSubject<String>();

  /// stream of validation messages
  late Stream<String?> validateMessageOut;

  /// The Bloc class handling the state of the dropdown
  FindDropdownBloc({T? seedValue, String? Function(T? selected)? validate}) {
    if (seedValue != null) selected$.add(seedValue);
    if (validate != null) validateMessageOut = selected$.distinct().map(validate).distinct();
  }

  /// dispose of the bloc
  void dispose() async {
    textController.dispose();
    selected$.close();
  }
}
