import 'package:flutter/material.dart';
import 'package:flutter_task/Util/palette.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CommonUi {
  showLoadingDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 40,
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: LoadingAnimationWidget.inkDrop(
                      color: whiteColor, size: 50))),
        );
      },
    );
  }
}
