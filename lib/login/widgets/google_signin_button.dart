import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget GoogleSignInButton(BuildContext context) {
  return IntrinsicWidth(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: const BorderSide(
              color: Colors.grey, // Border color
              width: 2, // Border width
            ),
            backgroundColor: Colors.black12, // Set the background color
            foregroundColor: Colors.white, // Set the text color
          ),
          onPressed: () => {},
          child: Row(
            children: [
              SvgPicture.asset("assets/drawable/google_logo.svg",
                  semanticsLabel: "Google logo"),
              const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text("Sign in with Google"))
            ],
          )));
}
