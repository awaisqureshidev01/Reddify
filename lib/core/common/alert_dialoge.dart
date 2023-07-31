import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/pallete.dart';


class CustomDialog extends ConsumerWidget {
  final String title;
  final String message;
  final String positiveButtonText;
  final String? negativeButtonText;
  final Function() onPositivePressed;
  final Function()? onNegativePressed;
  const CustomDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.positiveButtonText,
    this.negativeButtonText,
    required this.onPositivePressed,
    this.onNegativePressed,
  }) : super(key: key);

  Future<void> show(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return this;
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double rheight = MediaQuery.of(context).size.height / 812;
    double rwidth = MediaQuery.of(context).size.width / 375;
    double rtext = MediaQuery.textScaleFactorOf(context);
    final currentTheme = ref.watch(themeNotifierProvider);
    return AlertDialog(
      title: Row(
        children: [
          // Image(image: AssetImage('images/splash.png'),height: 30,width: 50,),
          Text(
            title,
            style: GoogleFonts.asap(color: Colors.black, fontSize: 18),
          ),
        ],
      ),
      content: Text(
        message,
        style: GoogleFonts.asap(color: Colors.black, fontSize: 14),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: Text(
                negativeButtonText ?? '',
                style: GoogleFonts.asap(
                    color: currentTheme.cardColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: onNegativePressed ?? () => Navigator.of(context).pop(),
            ),
            SizedBox(
              width: 60,
            ),
            TextButton(
              child: Text(
                positiveButtonText,
                style: GoogleFonts.asap(
                    color: Pallete.redColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: onPositivePressed,
            ),
          ],
        ),
      ],
    );
  }
}
