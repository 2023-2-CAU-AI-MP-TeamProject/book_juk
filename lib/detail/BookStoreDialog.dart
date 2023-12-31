import 'package:flutter/material.dart';
import 'package:book_juk/models/BookModel.dart';

import 'package:book_juk/globals.dart' as globals;

//책의 저장 버튼을 눌렀을 때 책을 읽은 책으로 저장할 지, 읽고 싶은 책으로 저장할 지
//책을 읽었다면 읽은 날짜, 좋아요 여부(저장 시 책갈피 표시)를 저장하는 기능이다.
//담당: 이재인

class BookStoreDialog extends StatefulWidget {
  const BookStoreDialog({super.key, required this.callBackBook, this.book});
  final Function(BookStatus status, DateTime date, bool isFavorite) callBackBook;
  final StoredBook? book;

  @override
  State<BookStoreDialog> createState() => _BookStoreDialogState();
}

class _BookStoreDialogState extends State<BookStoreDialog> {
  
  bool _isRead = true;
  late DateTime date;
  bool isFavorite = false;

  bool enumToBool(BookStatus status){
    switch(status){
      case BookStatus.read:
        return true;
      case BookStatus.unread:
        return false;
    }
  }

  @override
  void initState(){
    _isRead = (widget.book != null) ? enumToBool(widget.book!.status) : true;
    date = (widget.book != null) ? widget.book!.date : DateTime.now();
    isFavorite = (widget.book != null) ? widget.book!.isFavorite : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width / 2.3;
    final double buttonHeight = MediaQuery.of(context).size.width / 3.5;
    final defaultColorScheme = Theme.of(context).colorScheme;

    
    
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
        height: MediaQuery.of(context).size.height / 3,
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
                      color: (_isRead) ? defaultColorScheme.primary.withAlpha(200) : defaultColorScheme.background,
                    ),
                    child: InkWell(
                      onTap: () {
                        _isRead = true;
                        setState(() {});
                      },
                      borderRadius: BorderRadius.circular(20),
                      splashColor: defaultColorScheme.primary,
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
                      color: (!_isRead) ? defaultColorScheme.primary.withAlpha(200) : defaultColorScheme.background
                    ),
                    child: InkWell(
                      onTap: () {
                        _isRead = false;
                        setState(() {});
                      },
                      borderRadius: BorderRadius.circular(20),
                      splashColor: defaultColorScheme.primary,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: (_isRead) ?
                  ElevatedButton(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(DateTime.now().year - 50),
                        lastDate: DateTime.now(),
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
                      width: MediaQuery.of(context).size.width - 200,
                      child: LayoutBuilder(
                        builder: (context, constraints) => Text(
                          '읽은 날짜 : ${date.year} - ${date.month} - ${date.day}',
                          style: TextStyle(
                            fontSize: constraints.maxWidth / 12,
                            color: Colors.black
                          )
                        ),
                      )
                    )
                  )
                  : Container()
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: (isFavorite) ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                    color: (isFavorite) ? Colors.red : null,
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),
                ),
              ]
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  BookStatus curStatus = (_isRead) ? BookStatus.read : BookStatus.unread;
                  DateTime curDate = date;
                  bool curFavo = isFavorite;
                  widget.callBackBook(curStatus, curDate, curFavo);
                  if(globals.navigatorKeys[globals.Screen.search]!.currentState != null){
                    globals.navigatorKeys[globals.Screen.search]!.currentState!.maybePop();
                  }
                  if(globals.navigatorKeys[globals.Screen.home]!.currentState != null){
                    globals.navigatorKeys[globals.Screen.home]!.currentState!.maybePop();
                  }
                  switch(curStatus){
                    case BookStatus.read:
                      globals.readBookShelfKey.currentState!.updateBookShelf();
                      globals.readBookShelfKey.currentState!.setState(() {});
                      break;
                    case BookStatus.unread:
                      globals.unreadBookShelfKey.currentState?.updateBookShelf();
                      globals.unreadBookShelfKey.currentState?.setState(() {});
                      break;
                  }
                  globals.navigatorKeys['root']!.currentState!.setState(() {});
                  Navigator.of(context).popUntil(ModalRoute.withName(Navigator.defaultRouteName));
                  globals.tabController.index = 0;
                  globals.homeTabController.index = (curStatus == BookStatus.read) ? 0 : 1;
                  globals.isAdded = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('성공적으로 저장되었습니다.'),
                      duration: Duration(seconds: 1),
                    )
                  );
                  setState(() {});
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