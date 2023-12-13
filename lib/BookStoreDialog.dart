import 'package:flutter/material.dart';
import 'models/BookModel.dart';

import 'globals.dart' as globals;

class BookStoreDialog extends StatefulWidget {
  const BookStoreDialog({super.key, required this.callBackBook});
  final Function(BookStatus status, DateTime date) callBackBook;

  @override
  State<BookStoreDialog> createState() => _BookStoreDialogState();
}

class _BookStoreDialogState extends State<BookStoreDialog> {
  
  bool _isRead = true;
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width / 2.3;
    final double buttonHeight = MediaQuery.of(context).size.width / 3.5;

    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: const EdgeInsets.all(0.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30)
        )
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2.5,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Ink(
                    height: buttonHeight,
                    width: buttonWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (_isRead) ? Colors.lightBlue : Colors.lightBlue.withOpacity(0.5),
                    ),
                    child: InkWell(
                      onTap: () {
                        _isRead = true;
                        setState(() {});
                      },
                      borderRadius: BorderRadius.circular(20),
                      splashColor: Colors.blue,
                      child: Center(
                        child: Text('읽은 책',
                          style: TextStyle(
                            color: (_isRead) ? Colors.black : Colors.black.withOpacity(0.5),
                            fontSize: buttonWidth / 6
                          ),
                        ),
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Ink(
                    height: buttonHeight,
                    width: buttonWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (!_isRead) ? Colors.lightBlue : Colors.lightBlue.withOpacity(0.5),
                    ),
                    child: InkWell(
                      onTap: () {
                        _isRead = false;
                        setState(() {});
                      },
                      borderRadius: BorderRadius.circular(20),
                      splashColor: Colors.blue,
                      child: Center(
                        child: Text('읽고 싶은 책',
                          style: TextStyle(
                            color: (!_isRead) ? Colors.black : Colors.black.withOpacity(0.5),
                            fontSize: buttonWidth / 6
                          ),
                        ),
                      )
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 50),
                    lastDate: DateTime(DateTime.now().year + 50),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    locale: const Locale('ko', 'KR')
                  );
                  setState(() {
                    date = selectedDate ?? date;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0),
                  overlayColor: MaterialStateProperty.all(Colors.grey)
                ),
                child: SizedBox(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) => Text(
                        '날짜 : ${date.year} - ${date.month} - ${date.day}',
                        style: TextStyle(
                          fontSize: constraints.maxWidth / 20,
                          color: Colors.black
                        )
                      ),
                    ),
                  )
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    BookStatus curStatus = (_isRead) ? BookStatus.read : BookStatus.unread;
                    DateTime curDate = date;
                    widget.callBackBook(curStatus, curDate);
                    globals.navigatorKeys[globals.Screen.search]!.currentState!.pop();
                    Navigator.of(context).popUntil(ModalRoute.withName(Navigator.defaultRouteName));
                    globals.tabController.index = 0;
                    globals.isAdded = true;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('성공적으로 저장되었습니다.'),
                        duration: Duration(seconds: 1),
                      )
                    );
                  });
                },
                child: SizedBox(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) => Text(
                        '확인',
                        style: TextStyle(
                          fontSize: constraints.maxWidth / 20
                        )
                      ),
                    ),
                  )
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}