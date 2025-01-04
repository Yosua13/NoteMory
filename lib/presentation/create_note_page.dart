import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_mory/models/note.dart';
import 'package:provider/provider.dart';
import 'package:note_mory/providers/note_provider.dart';
import 'package:uuid/uuid.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  CreateNotePageState createState() => CreateNotePageState();
}

class CreateNotePageState extends State<CreateNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final formattedDate = DateFormat('dd-MM-yyyy, HH:mm').format(DateTime.now());
  final uuid = Uuid();

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          backgroundColor: const Color(0xFFFFB300),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB300),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
              size: 30,
              color: Color(0xFF000000),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                Note newNote = Note(
                    id: uuid.v4(),
                    title: _titleController.text,
                    content: _contentController.text,
                    date: formattedDate);

                await context.read<NoteProvider>().addNote(newNote);

                showSuccessDialog('Note has been saved successfully!');
                print('DEBUG: ID: ${newNote.id}');
                print('DEBUG: Title: ${newNote.title}');
                print('DEBUG: Content: ${newNote.content}');
                print('DEBUG: Date: ${newNote.date}');

                _titleController.clear();
                _contentController.clear();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
