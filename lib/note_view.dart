import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wisdom_jotter/functions.dart';
import 'package:wisdom_jotter/model.dart';

class NoteView extends StatelessWidget {
  Note note;
  NoteView({required this.note, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Share.share(note.title + '\n' + note.text),
            icon: Icon(
              Icons.share,
            ),
            iconSize: 20,
          ),
        ],
        title: SelectableText(
          note.title.isNotEmpty ? note.title : 'No title',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SelectableText(
              dateFormatter(note.date),
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 12),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(
                note.text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
