import 'package:flutter/material.dart';

class CommonService {
  // *** common date picker function which returns date
  Future<DateTime> pickDate(
      {@required BuildContext context,
      bool restrictFutureDate = false,
      String labelText = 'Select Date'}) {
    int currentYear = DateTime.now().year;
    int lastYear = currentYear + 2;

    DateTime firstDate = DateTime(currentYear - 100);
    DateTime lastDate =
        restrictFutureDate ? DateTime.now() : DateTime(lastYear);

    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: firstDate,
        lastDate: lastDate,
        helpText: labelText,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: const Color(0xffDD8933),
              accentColor: const Color(0xffDD8933),
              colorScheme: ColorScheme.light(primary: const Color(0xffDD8933)),
              buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
            ),
            child: child,
          );
        }).then((DateTime selectedDate) {
      return selectedDate;
    }).catchError((err) {
      print(err.toString());
      return null;
    });
  }

  // *** show toast messages ***
  showToastMessages({
    @required GlobalKey<ScaffoldState> scaffoldKey,
    @required BuildContext context,
    @required String message,
    bool isError = false,
  }) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).errorColor
            : Theme.of(context).accentColor,
      ),
    );
  }
}
