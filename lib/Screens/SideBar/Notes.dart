import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/Screens/Actions/EditNote.dart';
import 'package:notes/Screens/Actions/CreateNote.dart';
import 'package:notes/Screens/HomeScreen.dart';

bool noTitle = false;
bool noContent = false;
bool SearchOn = false;
Map<String, int> viewModes = {"Large View": 0, "Long View": 1, "Grid View": 2};
List<Map> searchedNotes = [];
final TextEditingController searchC = TextEditingController();

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  Widget leading() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(builder: (context) => createNote()),
                  )
                  .then((_) => setState(() {}));
            },
            icon: Icon(
              Icons.add,
              size: 30,
            ),
          ),

        ],
      ),
    );
  }

  Widget nListView(
      List<Map> Notes, int reverseIndex, int dateValue, String date) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: showShadow ? 2 : 0),
        child: Stack(alignment: Alignment.topRight, children: [
          GestureDetector(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => EditNote(
                          Title: Notes[reverseIndex]["title"],
                          Content: Notes[reverseIndex]["content"],
                          index: Notes[reverseIndex]['cindex'],
                        )))
                .then((value) => setState(() {
                      searchNotes(searchC.text);
                    })),
            child: Container(
              height: 300,
              width: 300,
              child: Card(
                color: colors[Notes[reverseIndex]['cindex']],
                elevation: showShadow ? 4 : 0,
                shadowColor: colors[Notes[reverseIndex]['cindex']],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 40.0,
                      right: 40.0,
                      top: 40,
                      bottom: showDate ? 15 : 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        noTitle
                            ? Container()
                            : Expanded(
                                flex: 2,
                                child: Text(Notes[reverseIndex]["title"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 24,
                                        color: Colors.black)),
                              ),
                        Expanded(
                          flex: 7,
                          child: Text(
                              noContent
                                  ? "Empty"
                                  : Notes[reverseIndex]["content"],
                              maxLines: showDate ? 8 : 9,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color:
                                      noContent ? Colors.white38 : Colors.black,
                                  fontSize: noTitle ? 21 : 16)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        showDate
                            ? Expanded(
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Text(
                                      date,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          Notes[reverseIndex]["edited"] == "yes"
                                              ? "Edited"
                                              : "",
                                          style:
                                              TextStyle(color: Colors.red),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                      ]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: IconButton(
                focusColor: Colors.blue,
                onPressed: () async {
                  showDeleteDialog(index: reverseIndex, Notes: Notes);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 26,
                )),
          ),
        ]),
      ),
    );
  }

  Widget nSmallListView(
      List<Map> Notes, int reverseIndex, int dateValue, String date) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: showShadow ? 2 : 0),
        child: Stack(alignment: Alignment.topRight, children: [
          GestureDetector(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => EditNote(
                          Title: notesMap[reverseIndex]["title"],
                          Content: notesMap[reverseIndex]["content"],
                          index: notesMap[reverseIndex]['cindex'],
                        )))
                .then((value) => setState(() {
                      searchNotes(searchC.text);
                    })),
            child: Container(
              height: 110,
              width: 300,
              child: Card(
                color: colors[Notes[reverseIndex]['cindex']],
                elevation: showShadow ? 4 : 0,
                shadowColor: colors[Notes[reverseIndex]['cindex']],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15.0,
                      right: noTitle ? 30.0 : 20.0,
                      top: noTitle ? 14.0 : 12.0,
                      bottom: showDate ? 10 : 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        noTitle
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 6, right: 40),
                                child: Text(Notes[reverseIndex]["title"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 24,
                                        color: Colors.black)),
                              ),
                        Expanded(
                          flex: noTitle ? 2 : 1,
                          child: Text(
                              noContent
                                  ? "Empty"
                                  : Notes[reverseIndex]["content"],
                              maxLines: noTitle
                                  ? showDate
                                      ? 2
                                      : 3
                                  : showDate
                                      ? 1
                                      : 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color:
                                      noContent ? Colors.red.shade900 : Colors.red,
                                  fontSize: noTitle ? 21 : 16)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        showDate
                            ? Expanded(
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Text(
                                      dateValue == 0
                                          ? "Today"
                                          : dateValue == -1
                                              ? "Yesterday"
                                              : date,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          Notes[reverseIndex]["edited"] == "yes"
                                              ? "Edited"
                                              : "",
                                          style:
                                              TextStyle(color: Colors.red),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                      ]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: IconButton(
                focusColor: Colors.black,
                onPressed: () async {
                  showDeleteDialog(index: reverseIndex, Notes: Notes);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 26,
                )),
          ),
        ]),
      ),
    );
  }

  Widget nGridView(
      List<Map> Notes, int reverseIndex, int dateValue, String date) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: showShadow ? 2 : 0),
        child: Stack(alignment: Alignment.topRight, children: [
          GestureDetector(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => EditNote(
                          Title: notesMap[reverseIndex]["title"],
                          Content: notesMap[reverseIndex]["content"],
                          index: notesMap[reverseIndex]['cindex'],
                        )))
                .then((value) => setState(() {
                      searchNotes(searchC.text);
                    })),
            child: Container(
              height: 180,
              width: 180,
              child: Card(
                color: colors[Notes[reverseIndex]['cindex']],
                elevation: showShadow ? 4 : 0,
                shadowColor: colors[Notes[reverseIndex]['cindex']],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15.0,
                      right: 20.0,
                      top: noTitle ? 14.0 : 14.0,
                      bottom: showDate ? 10 : 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        noTitle
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 6, right: 40),
                                child: Text(Notes[reverseIndex]["title"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        color: Colors.white)),
                              ),
                        Expanded(
                          flex: noTitle ? 3 : 2,
                          child: Padding(
                            padding: EdgeInsets.only(right: noTitle ? 20.0 : 0),
                            child: Text(
                                noContent
                                    ? "Empty"
                                    : Notes[reverseIndex]["content"],
                                maxLines: noTitle
                                    ? showDate
                                        ? 3
                                        : 4
                                    : showDate
                                        ? 2
                                        : 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color:
                                        noContent ? Colors.white38 : Colors.white,
                                    fontSize: noTitle ? 20 : 13)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        showDate
                            ? Expanded(
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Text(
                                      dateValue == 0
                                          ? "Today"
                                          : dateValue == -1
                                              ? "Yesterday"
                                              : date,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          Notes[reverseIndex]["edited"] == "yes"
                                              ? "Edited"
                                              : "",
                                          style:
                                              TextStyle(color: Colors.white38),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                      ]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: IconButton(
                focusColor: Colors.blue,
                onPressed: () async {
                  showDeleteDialog(index: reverseIndex, Notes: Notes);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 26,
                )),
          ),
        ]),
      ),
    );
  }

  void searchNotes(String query) {
    final searched = notesMap.where((note) {
      final title = note['title'].toString().toLowerCase();
      final content = note['content'].toString().toLowerCase();
      return title.contains(query) || content.contains(query);
    }).toList();
    setState(() {
      searchedNotes = searched;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map> Notes = SearchOn ? searchedNotes : notesMap;
    return Scaffold(
      body: ListView(
        children: [
          customAppBar("Notes", 42, leading()),
          SearchOn
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextFormField(
                        autofocus: true,
                        controller: searchC,
                        onChanged: searchNotes,
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(0)),
                          hintText: "Search",
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                        )),
                  ),
                )
              : Container(),
          notesMap.length != 0
              ? viewIndex != 2
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: Notes.length,
                          itemBuilder: (context, index) {
                            int reverseIndex = Notes.length - index - 1;
                            notesMap[reverseIndex]["title"] == ""
                                ? noTitle = true
                                : noTitle = false;
                            notesMap[reverseIndex]["content"] == ""
                                ? noContent = true
                                : noContent = false;
                            int dateValue = calculateDifference(
                                notesMap[reverseIndex]["time"]);
                            String date =
                                parseDate(notesMap[reverseIndex]["time"]);
                            Widget chosenView = viewIndex == 0
                                ? nListView(
                                    Notes, reverseIndex, dateValue, date)
                                : nSmallListView(
                                    Notes, reverseIndex, dateValue, date);
                            return chosenView;
                          }),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: Notes.length,
                          itemBuilder: (context, index) {
                            int reverseIndex = Notes.length - index - 1;
                            notesMap[reverseIndex]["title"] == ""
                                ? noTitle = true
                                : noTitle = false;
                            notesMap[reverseIndex]["content"] == ""
                                ? noContent = true
                                : noContent = false;
                            int dateValue = calculateDifference(
                                notesMap[reverseIndex]["time"]);
                            String date =
                                parseDate(notesMap[reverseIndex]["time"]);
                            return nGridView(
                                Notes, reverseIndex, dateValue, date);
                          }),
                    )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 200),
                  child: Center(
                      child: Text(
                    "You don't have any notes",
                    style: TextStyle(
                        color: Colors.pink, fontWeight: FontWeight.w400),
                  )),
                ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  int calculateDifference(String stringDate) {
    var date = DateTime.parse(stringDate);
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  String parseDate(String stringDate) {
    var date = DateTime.parse(stringDate);
    String parsedDate = DateFormat('d-MMM-yyyy HH:mm').format(date);
    return parsedDate;
  }

  Future<void> showDeleteDialog(
      {required List<Map> Notes, required int index}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Remove Note",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Text("Are you sure you want to remove this note?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel")),
            TextButton(
                onPressed: () async {
                  await deleteFromDatabase(id: Notes[index]["id"]);
                  setState(() {
                    searchNotes(searchC.text);
                  });
                  Navigator.of(context).pop();
                },
                child: Text("Yes"))
          ],
        );
      },
    );
  }
}
