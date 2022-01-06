import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";

class Load extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.blue[900],
          size: 50.0,
        ),
      ),
    );
  }
}
