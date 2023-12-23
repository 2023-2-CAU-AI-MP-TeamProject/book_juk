import 'package:book_juk/Login.dart';
import 'package:flutter/material.dart';
import 'package:book_juk/firebase/firestore.dart';
import 'package:book_juk/models/BookModel.dart';
import 'package:book_juk/detail/BookDetail.dart';
import 'package:book_juk/utilities/CustomNavigator.dart';
import 'globals.dart' as globals;
import 'dart:math';

//앱을 실행하고, 로그인을 완료하였을 때 진입하는 홈 화면이며, 저장한 책들을 시각화하는 책장을 구현하였다.
//책장은 책이 계속 저장됨에 따라 추가적으로 책장을 만들며, 무한 스크롤, 확대 기능이 있다.
// 위의 도서 검색을 누르면 검색 페이지로 이동할 수 있다.
//담당: 이정민, 수정: 이재인, 이정민

class MyHome extends StatefulWidget {
  final TabController tabController;
  final LoginPlatform loginPlatform;
  final FireStoreService firestore = FireStoreService();
  MyHome({super.key, required this.tabController, required this.loginPlatform});

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
  void dispose(){
    super.dispose();
    _tabController.dispose();
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
        backgroundColor: Colors.white,
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
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CustomTab(page: BookShelf(key: globals.readBookShelfKey, status: BookStatus.read, loginPlatform: widget.loginPlatform)),
          CustomTab(page: BookShelf(key: globals.unreadBookShelfKey, status: BookStatus.unread, loginPlatform: widget.loginPlatform))
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

class BookShelf extends StatefulWidget {
  final BookStatus status;
  final LoginPlatform loginPlatform;
  const BookShelf({super.key, required this.status, required this.loginPlatform});

  @override
  State<BookShelf> createState() => BookShelfState();
}

class BookShelfState extends State<BookShelf> {
  List<BookShelfLine> bookLineList = [];
  List<StoredBook> copy = [];
  final FireStoreService firestore = FireStoreService();

  void updateBookShelf(){
    bookLineList = [];
    copy = [];
    List<StoredBook> buffer = [];
    if(widget.loginPlatform != LoginPlatform.none) {
      firestore.loadBooks().then((books) => globals.books = books);
    }

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
    super.initState();
    updateBookShelf();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.loginPlatform != LoginPlatform.none){
      updateBookShelf(); //not recommended
    }
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
                width: MediaQuery.of(context).size.width,
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
      width: MediaQuery.of(context).size.width,
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
        0, (widget.book.title.length > 20) ? 20 : widget.book.title.length
      )}${(widget.book.title.length > 20) ? " ••" : ""}";

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.network(widget.book.cover, height: 100),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.book.title,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.book.description ?? '',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        globals.navigatorKeys[globals.Screen.home]!.currentState!.push(
                          MaterialPageRoute(builder: (context) => BookDetail(isbn13: widget.book.isbn13, storedBook: widget.book,),)
                        );
                      },
                      child: const Text('상세보기')
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width / 10.535,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: bookColor,
          border: Border.all(color: Colors.black,
          width: 0.5)
        ),
        child: Stack(
          children: [
            (widget.book.isFavorite)
            ? Positioned(
              right: 10,
              child: Container(
                width: 8,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.red
                ),
              ),
            )
            : Container(),
            Center(
              heightFactor: 100,
              widthFactor: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.0),
                child: Wrap(
                  spacing: 1,
                  direction: Axis.vertical,
                  alignment: WrapAlignment.start,
                  children: bookTitle.split('').map((char) {
                    return Text(
                      char,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        height: (char == ' ' || char == '•') ? 0.5 : 0.8
                      ),
                      textAlign: TextAlign.center,
                    );
                  }).toList()
                ),
              )
            )
          ]
        ),
      ),
    );
  }
}
