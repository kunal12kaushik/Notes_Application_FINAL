import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/Screens/HomeScreen.dart';

final TextEditingController titleC = TextEditingController();
final TextEditingController contentC = TextEditingController();
late String title;
late String content;
late String time;
late int Index;
int chosenIndex = 0;

class createNote extends StatefulWidget {
  createNote({
    Key? key,
  }) : super(key: key);

  @override
  State<createNote> createState() => _CreatNoteState();
}

class _CreatNoteState extends State<createNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF8DC),
      body: SafeArea(
          child: ListView(
              children: [
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: TextFormField(
              maxLines: 2,
              cursorColor: Colors.black,
              autofocus: true,
              textInputAction: TextInputAction.next,
              controller: titleC,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: isTablet? 40 : 30,
                  fontWeight: FontWeight.w500),
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: "Your Title")),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: TextFormField(
              cursorColor: Colors.black,
              textInputAction: TextInputAction.done,
              controller: contentC,
              maxLines: isTablet? 20 : 15,
              showCursor: true,
              style: TextStyle(color: Colors.black, fontSize: isTablet? 40 :24),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  constraints: BoxConstraints.expand(height: isTablet? 800 : 460, width: 200),
                  hintText: "Description.....")),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: TextButton(

            onPressed: () async {
              DateTime now = DateTime.now();
              String formattedDate = DateFormat('d-MMM-yyyy HH:mm').format(now);

              time = DateTime.now().toString();
              title = titleC.text;
              content = contentC.text;
              titleC.text != "" || contentC.text != ""
                  ? {
                      await insertToDatabase(
                          title: title,
                          time: time,
                          content: content,
                          index: chosenIndex),
                      titleC.text = "",
                      contentC.text = "",
                      Navigator.pop(context)
                    }
                  : Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.greenAccent,  // You can set the color of the shadow
                        offset: Offset(2, 2),  // You can adjust the offset of the shadow
                        blurRadius: 4,  // You can adjust the blur radius of the shadow
                        spreadRadius: 0,  // You can adjust the spread radius of the shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Save Note",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ])),
    );
  }
}
