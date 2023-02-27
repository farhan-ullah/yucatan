import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputFieldBox extends StatefulWidget {
  final List<StatefulWidget>? fields;
  final Function(bool)? onValidated;

  const InputFieldBox({Key? key, this.fields, this.onValidated})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputFieldBoxState();
}

class _InputFieldBoxState extends State<InputFieldBox> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            onChanged: () {
              _formKey.currentState!.save();
              widget.onValidated!(_formKey.currentState!.validate());
            },
            child: Column(
              children: widget.fields!,
            ),
          ),
        ],
      ),
    );
  }
}
