import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'functions.dart';
import 'model.dart';
import 'splash_screen.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

GetStorage box = GetStorage();

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  void initState() {
    initTheme().then((value) => print(box.read('useSystem')));

    super.initState();
    print('hhh');
  }

  Future initTheme() async {
    if (box.read('isDark') != null) {
      isDark = box.read('isDark');
    } else {
      box.writeIfNull('isDark', false);
      box.save();
    }
  }

  int seconds = 4;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wisdom Jotter',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
      ),
      home: FutureBuilder(
        future: Future.delayed(
          Duration(
            seconds: seconds,
          ),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            seconds = 0;
            return Splash();
          } else {
            return Notepad(
              value: isDark,
              onChange: (val) {
                setState(() {});
                box.write('isDark', val);
                isDark = val;
              },
            );
          }
        },
      ),
    );
  }
}

class Notepad extends StatefulWidget {
  var value;
  var onChange;
  Notepad({required this.value, required this.onChange});
  @override
  _NotepadState createState() => _NotepadState();
}

class _NotepadState extends State<Notepad> {
  final storage = GetStorage();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void saveNote() {
    String title = _titleController.text;
    String noteText = _noteController.text;
    DateTime date = DateTime.now();

    Note note = Note(
      title: title,
      text: noteText,
      date: date,
    );

    List<String> notes = (storage.read('notes') ?? []).cast<String>();
    notes = [jsonEncode(note.toJson())] + notes;
    storage.write('notes', notes);

    _titleController.clear();
    _noteController.clear();
    setState(() {});
  }

  void _delete(Note note) {
    List<String> notes = (storage.read('notes') ?? []).cast<String>();
    notes.remove(jsonEncode(note.toJson()));
    storage.write('notes', notes);
    setState(() {});
  }

  void _edit(Note note) {
    List<String> notes = (storage.read('notes') ?? []).cast<String>();
    notes.remove(jsonEncode(note.toJson()));
    storage.write('notes', notes);
    setState(() {});
  }

  List<Note> _getNotes() {
    List<String> noteStrings = (storage.read('notes') ?? []).cast<String>();
    List<Note> notes = noteStrings.map((noteString) {
      Map<String, dynamic> json = jsonDecode(noteString);
      return Note.fromJson(json);
    }).toList();
    return notes;
  }

  bool showAddNote = false;

  var noteFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            Switch(value: widget.value, onChanged: widget.onChange),
          ],
          leading: const Icon(CupertinoIcons.book_circle),
          title: const Text('Wisdom Jotter App'),
        ),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              textDirection: TextDirection.rtl,
              children: [
                if (showAddNote == false && _getNotes().isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Swipe right to left to Delete Note',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                        onPressed: () => setState(() {
                              showAddNote = !showAddNote;
                            }),
                        label: Text(!showAddNote ? 'Add' : 'Close'),
                        icon: Icon(!showAddNote ? Icons.add : Icons.clear)),
                  ),
                ),
                if (showAddNote)
                  Column(children: [
                    SizedBox(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                hintText: 'Title',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                              controller: _titleController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, bottom: 8.0, right: 8.0),
                            child: TextField(
                              focusNode: noteFocus,
                              textCapitalization: TextCapitalization.sentences,
                              onEditingComplete: () => noteFocus.nextFocus(),
                              onChanged: (value) => setState(() {}),
                              decoration: const InputDecoration(
                                hintText: 'Note',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                              controller: _noteController,
                              maxLines: 10,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  saveNote();
                                  showAddNote = false;
                                  setState(() {});
                                },
                                child: const Text(
                                  'Save Note',
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _noteController.clear();
                                  _titleController.clear();
                                },
                                child: const Text(
                                  'Clear Notes',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                const SizedBox(
                  height: 20,
                ),
                if (showAddNote == false && _getNotes().isEmpty)
                  const Text('No Notes Added'),
                if (showAddNote == false)
                  ..._getNotes().map((note) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 8.0, right: 8.0),
                        child: Dismissible(
                          key: Key(note.date.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.teal,
                            alignment: Alignment.centerRight,
                            child: const Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onDismissed: (direction) {
                            _delete(note);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 70,
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(note.title.isNotEmpty
                                    ? note.title[0]
                                    : "N"),
                              ),
                              tileColor: Color.fromARGB(97, 129, 129, 129),
                              title: Text(
                                note.title.isNotEmpty ? note.title : 'No title',
                                maxLines: 1,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(note.text,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15)),
                              trailing: Text(
                                dateFormatter(note.date),
                                style: const TextStyle(fontSize: 10),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => Hero(
                                    tag: note.date,
                                    child: Scaffold(
                                      appBar: AppBar(
                                        title: Text(
                                          note.title.isNotEmpty
                                              ? note.title
                                              : 'No title',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      body: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SelectableText(
                                              note.text,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
              ]),
        ));
  }
}
