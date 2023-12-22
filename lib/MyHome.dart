import 'package:flutter/material.dart';
import 'package:book_juk/firebase/firestore.dart';
import 'package:book_juk/models/BookModel.dart';
import 'package:book_juk/utilities/CustomNavigator.dart';
import 'globals.dart' as globals;
import 'dart:math';

class MyHome extends StatefulWidget {
  final TabController tabController;
  final FireStoreService firestore = FireStoreService();
  MyHome({super.key, required this.tabController});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> 
with SingleTickerProviderStateMixin{
  bool isRead = true;
  late TabController _tabController;

  @override
  void initState(){
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: TabBar(
            tabs: <Tab>[
              Tab(
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width /2 - 30,
                  margin: const EdgeInsets.fromLTRB(10, 10 ,10, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text(
                    "읽은 책",
                    style: TextStyle(
                    )
                  ))
                ),
              ),
              Tab(
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width /2 - 30,
                  margin: const EdgeInsets.fromLTRB(10, 10 ,10, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text(
                    "읽고 싶은 책"
                  ))
                ),
              )
            ],
            isScrollable: false,
            controller: _tabController,
            unselectedLabelColor: Colors.black,
            onTap: (value) => isRead = !isRead,
            indicatorColor: Theme.of(context).primaryColor,
          )
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CustomTab(page: BookShelf(key: globals.readBookShelfKey, status: BookStatus.read)),
          CustomTab(page: BookShelf(key: globals.unreadBookShelfKey, status: BookStatus.unread))
        ],
      )
    );
  }
}

class BookShelf extends StatefulWidget {
  final BookStatus status;
  const BookShelf({super.key, required this.status});

  @override
  State<BookShelf> createState() => BookShelfState();
}

class BookShelfState extends State<BookShelf> {
  List<BookShelfLine> bookLineList = [];
  List<StoredBook> copy = [];

  void updateBookShelf(){
    bookLineList = [];
    copy = [];
    List<StoredBook> buffer = [];

    for(StoredBook book in globals.books){
      if(book.status == widget.status){
        copy.add(book);
      }
    }
    
    for(StoredBook book in copy){
      buffer.add(book);
      if(buffer.length > 7){
        final temp = BookShelfLine(key: UniqueKey(), books: buffer);
        bookLineList.add(temp);
        buffer = [];
      }
    }
    final temp = BookShelfLine(key: UniqueKey(), books: buffer);
    bookLineList.add(temp);
    while(bookLineList.length < 5){
      final temp = BookShelfLine(key: UniqueKey(), books: const []);
      bookLineList.add(temp);
    }
  }

  @override
  void initState(){
    updateBookShelf();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InteractiveViewer(
            minScale: 1.0,
            maxScale: 2.0,
            //clipBehavior: Clip.none,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
                padding: EdgeInsets.only(bottom: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 157, 107, 47),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: bookLineList.length,
                  itemBuilder: (context, index) {
                    return bookLineList[index];
                  },
                )
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BookShelfLine extends StatefulWidget {
  final List<StoredBook> books;
  const BookShelfLine({super.key, required this.books});

  @override
  State<BookShelfLine> createState() => _BookShelfLineState();
}

class _BookShelfLineState extends State<BookShelfLine> {
  List<Widget> widgetBooks = [];

  @override
  void initState(){
    // for(StoredBook book in widget.books){
    //   widgetBooks.add(Book(book: book, key: UniqueKey()));
    // }
    widgetBooks = widget.books.map((e) => Book(book: e, key: UniqueKey())).toList();
    super.initState();
  }

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgetBooks
      ),
    );
  }
}

class Book extends StatefulWidget {
  final StoredBook book;
  Book({super.key, required this.book});

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
    final bookTitle = "${widget.book.title.substring(
        0, (widget.book.title.length > 10) ? 10 : widget.book.title.length
      )}${(widget.book.title.length > 10) ? "..." : ""}";

    return GestureDetector(
      onTap: () {
        showDialog (context: context,
            builder: (context) {
          return AlertDialog(
            title: Text(widget.book.title),
            content: Text(widget.book.description ?? '설명 없음'),
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
        height: 100,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: bookColor,
          border: Border.all(color: Colors.black,
          width: 0.5)
        ),
        child: Center(
          heightFactor: 100,
          widthFactor: 40,
          child: Wrap(
            spacing: 3,
            direction: Axis.vertical,
            alignment: WrapAlignment.center,
            children: bookTitle.split('').map((char) {
              return Text(
                char,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold
                )
              );
            }).toList()
          )
        ),
      ),

    );
  }
}
