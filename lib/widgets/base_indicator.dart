import 'package:flutter/material.dart';

class BaseIndicator extends StatelessWidget {
  final String? text;
  final VoidCallback? onTapBack;
  const BaseIndicator({super.key, this.text , this.onTapBack});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          color: Colors.transparent,
          alignment: AlignmentDirectional.center,
          child: Material(
            color: Colors.transparent,
            child: bodyLayout(context),
          ),
        ),
        onTapUp: (details) {
          if (details.localPosition.dy < kToolbarHeight) {
            onTapBack?.call();
          }
        });
  }

  Widget bodyLayout(BuildContext context) {
    return Container(
      padding:const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.black87),
        constraints:
          const  BoxConstraints(maxHeight: 100, maxWidth: 300, minWidth: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white)),
            if (text?.isNotEmpty==true)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                child:  Text(
                  text??"",
                  style: const TextStyle(color: Colors.white),
                ),
              )
          ],
        ));
  }
}

class DialogIndicator {
  static BuildContext? _dialogContext;

  static showIndicator(BuildContext context,
      {String text = "",
      bool barrierDismissible = false,
      bool useRootNavigator = true,
      VoidCallback? pop}) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: useRootNavigator,
        barrierColor: Colors.transparent,
        builder: (ctx) {
          _dialogContext = ctx;
          return BaseIndicator(
              text: text,
              onTapBack: !barrierDismissible
                  ? null
                  : () {
                      hide(context);
                      pop?.call();
                    });
        });
    _dialogContext = null;
  }

  static void hide(BuildContext context) {
    if (_dialogContext != null) {
      try {
        Navigator.canPop(_dialogContext!);
        Navigator.pop(_dialogContext!);
        _dialogContext = null;
      } catch (e) {}
    }
  }
}
