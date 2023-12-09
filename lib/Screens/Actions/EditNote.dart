import 'package:flutter/material.dart';
import 'package:notes/Screens/HomeScreen.dart';

final TextEditingController titleC = TextEditingController();
final TextEditingController contentC = TextEditingController();
late int Index;
int chosenIndex = 0;

class EditNote extends StatefulWidget {
  String Title = "";
  String Content = "";
  int index = 0;

  EditNote(
      {Key? key,
      required this.Title,
      required this.Content,
      required this.index})
      : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  @override
  void initState() {
    super.initState();
    titleC.text = widget.Title;
    contentC.text = widget.Content;
    Index = widget.index;
    // chosenIndex = Index;
  }

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
              cursorColor: Colors.white,
              textInputAction: TextInputAction.done,
              controller: titleC,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: isTablet? 60 :36,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "No Title")),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: TextFormField(
              cursorColor: Colors.white,
              textInputAction: TextInputAction.done,
              controller: contentC,
              maxLines: isTablet? 20 :15,
              showCursor: true,
              style: TextStyle(color: Colors.black, fontSize: isTablet? 40 : 24),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  constraints: BoxConstraints.expand(height: isTablet? 800 : 460, width: 200),
                  hintText: "Write Your Note Here")),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: TextButton(
            onPressed: () async {
              var time = DateTime.now().toString();
              titleC.text != widget.Title ||
                      contentC.text != widget.Content ||
                      chosenIndex != widget.index
                  ? {
                      await editDatabaseItem(
                          time: "$time",
                          content: contentC.text,
                          title: widget.Title,
                          title2: titleC.text,
                          index: chosenIndex),
                      Navigator.of(context).pop(),
                    }
                  : Navigator.of(context).pop();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red,  // You can set the color of the shadow
                          offset: Offset(2, 2),  // You can adjust the offset of the shadow
                          blurRadius: 4,  // You can adjust the blur radius of the shadow
                          spreadRadius: 0,  // You can adjust the spread radius of the shadow
                        ),
                      ],
                      color: Colors.black,borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Save Changes",
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
