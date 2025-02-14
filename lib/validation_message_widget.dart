import 'package:flutter/material.dart';

import 'find_dropdown_bloc.dart';

/// validation message widget
class ValidationMessageWidget extends StatelessWidget {
  /// the bloc for checking the validation state
  final FindDropdownBloc bloc;

  /// validation message widget
  const ValidationMessageWidget({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: bloc.validateMessageOut,
      builder: (context, snapshot) {
        return ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 15),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              snapshot.data ?? '',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: snapshot.hasData ? Theme.of(context).errorColor : Colors.transparent),
            ),
          ),
        );
      },
    );
  }
}
