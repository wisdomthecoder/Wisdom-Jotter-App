import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wisdom_jotter/note_view.dart';

import 'functions.dart';
import 'model.dart';
// import 'splash_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final storage = GetStorage();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _noteFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _noteFocusNode.dispose();
    _titleFocusNode.dispose();

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
            Switch(
                value: Get.isDarkMode,
                onChanged: (val) {
                  setState(() {});
                  print(Get.isDarkMode);
                  Get.changeThemeMode(
                      Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                }),
          ],
          leading: const Icon(CupertinoIcons.book_circle),
          title: const SelectableText('Jotter App'),
        ),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              textDirection: TextDirection.rtl,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            showAddNote = !showAddNote;
                          });
                          if (!showAddNote) {
                            FocusScope.of(context)
                                .requestFocus(_titleFocusNode);
                          }
                        },
                        label: SelectableText(!showAddNote ? 'Add' : 'Close'),
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
                              focusNode: _titleFocusNode,
                              textCapitalization: TextCapitalization.sentences,
                              onSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(_noteFocusNode);
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                hintText: 'Title',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                              controller: _titleController,
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 2,
                            margin: const EdgeInsets.only(
                                left: 8.0, bottom: 8.0, right: 8.0),
                            child: TextField(
                              focusNode: _noteFocusNode,
                              textCapitalization: TextCapitalization.sentences,
                              onEditingComplete: () => noteFocus.nextFocus(),
                              onChanged: (value) => setState(() {}),
                              decoration: const InputDecoration(
                                hintText: 'Note',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                              controller: _noteController,

                              // maxLines: 10,
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
                                child: const SelectableText(
                                  'Save Note',
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _noteController.clear();
                                  _titleController.clear();
                                },
                                child: const SelectableText(
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
                  const SelectableText('No Notes Added'),
                if (showAddNote == false)
                  ..._getNotes().map((note) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 8.0, right: 8.0),
                        child: Container(
                          width: double.infinity,
                          height: 70,
                          child: ListTile(
                              leading: CircleAvatar(
                                child: SelectableText(note.title.isNotEmpty
                                    ? note.title[0]
                                    : "N"),
                              ),
                              minLeadingWidth: 0,
                              tileColor: Color.fromARGB(97, 129, 129, 129),
                              title: SelectableText(
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
                                      fontSize: 12)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _titleController.text = note.title;
                                      _noteController.text = note.text;
                                      _delete(note);
                                      setState(() {
                                        showAddNote = true;
                                      });
                                    },
                                    icon: Icon(Icons.edit),
                                    iconSize: 20,
                                  ),
                                  IconButton(
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) =>
                                          CupertinoAlertDialog(
                                        title: Text(
                                          'Are you Sure',
                                        ),
                                        actions: [
                                          CupertinoButton(
                                            child: Text('No'),
                                            onPressed: () {},
                                          ),
                                          CupertinoButton(
                                            child: Text('Yes'),
                                            onPressed: () {
                                              back(context);
                                              _delete(note);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.delete,
                                    ),
                                    iconSize: 20,
                                  ),
                                  IconButton(
                                    onPressed: () => Share.share(
                                        note.title + '\n' + note.text),
                                    icon: Icon(
                                      Icons.share,
                                    ),
                                    iconSize: 20,
                                  ),
                                ],
                              ),
                              onTap: () {
                                moveToPage(NoteView(note: note), context);
                              }),
                        ),
                      ),
                    );
                  }).toList(),
              ]),
        ));
  }
}
