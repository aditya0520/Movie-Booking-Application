import 'package:flutter/material.dart';

class LoadingFlag {
  static bool isLoading = false;
}

class CustomFormButton extends StatefulWidget {
  final String innerText;
  final void Function()? onPressed;
  const CustomFormButton(
      {Key? key, required this.innerText, required this.onPressed})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomInputButton();
}

class _CustomInputButton extends State<CustomFormButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: const Color(0xff233743),
        borderRadius: BorderRadius.circular(26),
      ),
      child: TextButton(
        onPressed: widget.onPressed,
        child: LoadingFlag.isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Please Wait...",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              )
            : Text(
                widget.innerText,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
      ),
    );
  }
}
