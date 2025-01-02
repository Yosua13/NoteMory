import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_mory/models/note.dart';
import 'package:provider/provider.dart';
import 'package:note_mory/providers/note_provider.dart';

class DetailNotePage extends StatefulWidget {
  final Note note;

  const DetailNotePage({super.key, required this.note});

  @override
  DetailNotePageState createState() => DetailNotePageState();
}

class DetailNotePageState extends State<DetailNotePage> {
  TextEditingController? _titleController;
  TextEditingController? _contentController;
  final formattedDate = DateFormat('dd-MM-yyyy, HH:mm').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  Future<void> _saveEditedNote() async {
    final updatedNote = Note(
      title: _titleController!.text,
      content: _contentController!.text,
      date: formattedDate,
    );

    await Provider.of<NoteProvider>(context, listen: false)
        .editNote(widget.note, updatedNote);

    Navigator.pop(context);
  }

  Future<void> _deleteNote() async {
    await Provider.of<NoteProvider>(context, listen: false)
        .deleteNote(widget.note);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB300),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xFFFFB300),
                    title: const Text('Confirm Delete'),
                    content: const Text(
                        'Are you sure you want to delete this note?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
              if (confirm == true) {
                await _deleteNote();
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.check,
              size: 30,
            ),
            onPressed: _saveEditedNote,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
              TextFormField(
                controller: _contentController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Start typing...',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
