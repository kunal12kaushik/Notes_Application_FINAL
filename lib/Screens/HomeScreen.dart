import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/Screens/SideBar/Notes.dart';
import 'package:notes/Screens/SideBar/NotesTablet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

late Database database;
List<Map> notesMap = [];
List<Color> colors = [
  Color(0xffFCF5E5),

];
int currentIndex = 0;
late int viewIndex;
bool loading = true;
late bool showDate;
late bool showShadow;
bool isTablet = getDeviceType() == 'tablet' ? true : false;
GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  List<Widget> page = [
    Builder(
      builder: (context) {
        return isTablet
            ? MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.5),
                child: HomePageT())
            : MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: HomePage());
      },
    ),

  ];


  startPage() async {
    await startDatabase();
    await Future.delayed(Duration(seconds: 1));
    loading = false;
    setState(() {});
  }

  onIndexChanged(int index) {
    currentIndex = index;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    startPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Row(
        children: [
          // SideBar(),
          Container(
            height: double.infinity,
            width: 1,
            color: Theme.of(context).highlightColor.withOpacity(0.15),
          ), // Divider
          Expanded(
              flex: 5,
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : FutureBuilder(
                      future: startDatabase(),
                      builder: (context, snapshot) => page[currentIndex],
                    ))
        ],
      ),
    );
  }
}

Widget divider() {
  return Divider(
    height: 20,
    color:
        Theme.of(scaffoldKey.currentContext!).highlightColor.withOpacity(0.3),
  );
}

Widget customAppBar(String title,double top,[Widget? leading]) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.only(left: isTablet? 40:20, bottom: 10, top: top),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Text(
              title,
              style: TextStyle( color: Colors.black,
                  fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: leading == null ? Container() : leading,
            )
          ],
        ),
      ),
      divider(),
    ],
  );
}

Future<void> startDatabase() async {
  final prefs = await SharedPreferences.getInstance();
  await openDatabase('notes.db', version: 1, onCreate: (db, version) async {
    print("db created");
    await db.execute(
        'CREATE TABLE Notes (id INTEGER PRIMARY KEY, title TEXT, content TEXT, time Text, cindex INTEGER, tindex INTEGER,edited Text)');
  }, onOpen: (db) async {
    print("db opened");
  }).then((value) => database = value);
  viewIndex = await prefs.getInt('viewIndex') ?? 0;
  showDate = await prefs.getBool('showDate') ?? true;
  showShadow = await prefs.getBool('showShadow') ?? true;
  await refreshDatabase();
}

Future<void> refreshDatabase() async {
  await getDatabaseItems(database);
}

Future<void> destroyDatabase() async {
  await deleteDatabase('notes.db');
  await refreshDatabase();
}

Future<void> insertToDatabase(
    {required String title,
    required String content,
    required int index,
    required String time}) async {
  await database.transaction((txn) async {
    int tIndex = 0;
    txn
        .rawInsert(
            'INSERT INTO Notes(title, content, cindex, tindex, time, edited) VALUES("$title", "$content", "$index", "$tIndex","$time","no")')
        .then((value) {
      print('inserted: $value');
    });
  });
  await refreshDatabase();
}

Future<void> getDatabaseItems(database) async {
  List<Map> list = await database.rawQuery('SELECT * FROM Notes');
  notesMap = await list;
}

Future<void> editDatabaseItem(
    {required String title,
    required String content,
    required String time,
    required int index,
    required String title2}) async {
  int tIndex = 0;
  int count = await database.rawUpdate(
      'UPDATE Notes SET title = ?, content = ?, time = ?, cindex = ?, tindex = ?, edited = ? WHERE title = ?',
      ['$title2', '$content', '$time', '$index', '$tIndex', 'yes', '$title']);
  print('updated: $count');
  await refreshDatabase();
}

Future<void> deleteFromDatabase({required int id}) async {
  int count =
      await database.rawDelete('DELETE FROM Notes WHERE id = ?', ['$id']);
  assert(count == 1);
  await refreshDatabase();
}

String getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide < 600 ? 'phone' : 'tablet';
}
