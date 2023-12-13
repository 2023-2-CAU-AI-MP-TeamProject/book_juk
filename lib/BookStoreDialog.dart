import 'package:flutter/material.dart';

class BookStoreDialog extends StatefulWidget {
  const BookStoreDialog({super.key});

  @override
  State<BookStoreDialog> createState() => _BookStoreDialogState();
}

class _BookStoreDialogState extends State<BookStoreDialog> {
  final _isSelected = <bool>[true, false];
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
                      color: (_isSelected[0]) ? Colors.lightBlue : Colors.lightBlue.withOpacity(0.5),
                    ),
                    child: InkWell(
                      onTap: () {
                        _isSelected[0] = true;
                        _isSelected[1] = false;
                        setState(() {});
                      },
                      borderRadius: BorderRadius.circular(20),
                      splashColor: Colors.blue,
                      child: Center(
                        child: Text('읽은 책',
                          style: TextStyle(
                            color: (_isSelected[0]) ? Colors.black : Colors.black.withOpacity(0.5),
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
                      color: (_isSelected[1]) ? Colors.lightBlue : Colors.lightBlue.withOpacity(0.5),
                    ),
                    child: InkWell(
                      onTap: () {
                        _isSelected[0] = false;
                        _isSelected[1] = true;
                        setState(() {});
                      },
                      borderRadius: BorderRadius.circular(20),
                      splashColor: Colors.blue,
                      child: Center(
                        child: Text('읽고 싶은 책',
                          style: TextStyle(
                            color: (_isSelected[1]) ? Colors.black : Colors.black.withOpacity(0.5),
                            fontSize: buttonWidth / 6
                          ),
                        ),
                      )
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2077),
                  initialEntryMode: DatePickerEntryMode.calendarOnly
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
                width: MediaQuery.of(context).size.width - 50,
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
            )
          ],
        ),
      ),
    );
  }
}