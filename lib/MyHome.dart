// import 'package:book_juk/models/BookModel.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'dart:math';

class MyHome extends StatefulWidget {
  final TabController tabController;
  const MyHome({super.key, required this.tabController});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<Widget> bookcaseList = [];
  List<Widget> bookList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      addBookCase();
    }
  }

  void addBookCase() {
    setState(() {
      bookcaseList.add(BookShelf());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            setState(() {
              globals.isSearchedViaHome = true;
              widget.tabController.index = 1;
            });
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: IgnorePointer(
            ignoring: true,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                cursorColor: Colors.black54,
                decoration: const InputDecoration(
                  hintText: '도서 검색',
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                ),
              ),
            ),
          ),
        ),
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 2.0,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
                  padding: EdgeInsets.only(bottom: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 157, 107, 47),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: bookcaseList,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addBookCase,
        child: Icon(Icons.add),
      ),
      // body: Center(
      //   child: (globals.books.isEmpty) ? const Text('Home',
      //     style: TextStyle(
      //       fontSize: 100
      //     ),
      //     textAlign: TextAlign.center,
      //   )
      //   : ListView.builder(
      //     itemBuilder: (context, index) {
      //       return ListTile(
      //         leading: (globals.books[index].status == BookStatus.read)
      //         ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.close, color: Colors.red),
      //         title: Text(globals.books[index].book.title,
      //           maxLines: 2,
      //           style: const TextStyle(
      //             overflow: TextOverflow.ellipsis,
      //           )
      //         ),
      //         isThreeLine: true,
      //         subtitle: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(globals.books[index].book.author,
      //               maxLines: 1,
      //               style: const TextStyle(
      //                 overflow: TextOverflow.ellipsis
      //               )
      //             ),
      //             Text('${globals.books[index].date.year}-${globals.books[index].date.month}-${globals.books[index].date.day}',
      //               maxLines: 1,
      //               style: const TextStyle(
      //                 overflow: TextOverflow.ellipsis,
      //                 color: Colors.blue
      //               )
      //             ),
      //           ],
      //         ),
      //         trailing: IconButton(
      //           onPressed: () {
      //             setState(() => globals.books.removeAt(index));
      //           },
      //           icon: const Icon(Icons.cancel)
      //         ),
      //       );
      //     },
      //     itemCount: globals.books.length,
      //   )
      // )
    );
  }
}

class BookShelf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 150, 100, 40),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Book(),
          Book(),
          Book()
        ]
      ),
    );
  }
}

class Book extends StatefulWidget {
  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  @override
  Widget build(BuildContext context) {
    final colors = [
      Theme.of(context).primaryColor,
      Theme.of(context).primaryColorDark,
      Theme.of(context).primaryColorLight,
    ];
    final random = Random();
    final bookColor = colors[random.nextInt(colors.length)];
    final bookHeight = 80 + random.nextInt(20);
    final bookTitle = "AI학과 화이팅";
    print(colors[0]);

    return GestureDetector(
      onTap: () {
        showDialog (context: context,
            builder: (context) {
          return AlertDialog(
            title: Text('책 제목'),
            content: Text('책 줄거리'),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text('확인'))
            ],
          );
            },
        barrierDismissible: false);
      },
      child: Container(
        height: bookHeight.toDouble() - 0.5 * 2,
        width: 20 - 0.5 * 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: bookColor,
          border: Border.all(color: Colors.black,
          width: 0.5)
        ),
        child: Center(
          heightFactor: bookHeight.toDouble() - 0.5 * 2,
          widthFactor: 20 - 0.5 * 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: bookTitle.split('').map((char) =>
                Text(char, style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold))).toList(),
          )),
      ),

    );
  }
}
