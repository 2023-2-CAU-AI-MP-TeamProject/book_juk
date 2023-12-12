import 'package:flutter/material.dart';

class BookStoreDialog extends StatefulWidget {
  const BookStoreDialog({super.key});

  @override
  State<BookStoreDialog> createState() => _BookStoreDialogState();
}

class _BookStoreDialogState extends State<BookStoreDialog> {
  final _isSelected = <bool>[true, false];
  late final double _buttonWidth;
  late final double _buttonHeight;

  @override
  Widget build(BuildContext context) {
    _buttonWidth = MediaQuery.of(context).size.width / 2.3;
    _buttonHeight = MediaQuery.of(context).size.width / 3.5;

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
                  child: InkWell(
                    onTap: () {
                      _isSelected[0] = true;
                      _isSelected[1] = false;
                    },
                    splashColor: Colors.black,
                    child: Container(
                      width: _buttonWidth, height: _buttonHeight,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.lightBlue
                      ),
                      child: Center(
                        child: Text('읽은 책',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: _buttonWidth / 6
                          ),
                        ),
                      )
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      _isSelected[0] = false;
                      _isSelected[1] = true;
                    },
                    child: Container(
                      width: _buttonWidth, height: _buttonHeight,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.lightBlue
                      ),
                      child: Center(
                        child: Text('읽고 싶은 책',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: _buttonWidth / 6
                          ),
                        ),
                      )
                    )
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              child: SizedBox(height: 30, width: MediaQuery.of(context).size.width - 50,)
            )
          ],
        ),
      ),
    );
  }
}