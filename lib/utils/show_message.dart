import 'package:flutter/material.dart';

import '../themes/styles.dart';

void showMessage(
  BuildContext context,
  String message,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: const Color(0xff242424),
      duration: const Duration(minutes: 1),
      dismissDirection: DismissDirection.down,
      content: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}

void showErrorMessage(
  BuildContext context,
  String message,
) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    backgroundColor: Colors.red,
  ));
}

void showSuccessMessage(
  BuildContext context,
  String message,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 1),
    ),
  );
}

Future<dynamic> showWarningAlertDialog(BuildContext context,
    {required String imgUrl,
    required String title,
    required String description,
    required String btnText}) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            content: Container(
              color: Theme.of(context).colorScheme.background,
              height: 500,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 25),
                      child: Image.asset(
                        imgUrl,
                        // width: 222,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(description,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(btnText,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.white))),
                    )
                  ]),
            ),
          ));
}

Future<dynamic> showSuccessBottomSheet(BuildContext context, String title,
    Function()? onPressed, bool status, String btnText) async {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
            height: 260,
            // padding: const EdgeInsets.symmetric(
            //     horizontal: 50, vertical: 30),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                status
                    ? const CircleAvatar(
                        radius: 40,
                        backgroundColor: kPrimaryColor,
                        child: Icon(
                          Icons.check,
                          size: 50,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.info,
                        size: 90,
                        color: Colors.red,
                      ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      onPressed: onPressed ?? () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: status ? kPrimaryColor : Colors.red,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          btnText,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.white),
                        ),
                      )),
                )
              ],
            ),
          ));
}
