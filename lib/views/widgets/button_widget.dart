import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final String buttonText;
  final Color buttonColor;
  final VoidCallback buttonPressed;

  const ButtonWidget({Key? key, required this.buttonText, required this.buttonColor, required this.buttonPressed}) : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();


}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(widget.buttonColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.black)
                )
            )
        ),
        onPressed: widget.buttonPressed,
        child: Text(widget.buttonText)
    );
  }
}
