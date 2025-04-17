import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_mory/models/note.dart';
import 'package:note_mory/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:note_mory/providers/note_provider.dart';
import 'package:uuid/uuid.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  CreateNotePageState createState() => CreateNotePageState();
}

class CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final uuid = Uuid();

  int _currentLength = 0;
  void _updateCurrentLength() {
    setState(() {
      _currentLength =
          _titleController.text.length + _contentController.text.length;
    });
  }

  late Timer _timer;
  String _currentDate = '';
  String _formatCurrentDate() {
    return DateFormat('dd-MM-yyyy, HH:mm:ss').format(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_updateCurrentLength);
    _contentController.addListener(_updateCurrentLength);

    _currentDate = _formatCurrentDate();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentDate = _formatCurrentDate();
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _timer.cancel();
    super.dispose();
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
                final user = context.read<UserProvider>().user;
                debugPrint("DEBUG USER: ${user?.id}");

                final userId = context.read<UserProvider>().user?.id;
                debugPrint("coba $userId");

                if (user == null || user.id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User belum login')),
                  );
                  return;
                }

                Note newNote = Note(
                  id: uuid.v4(),
                  userId: userId,
                  title: _titleController.text,
                  content: _contentController.text,
                  date: _currentDate,
                  textLenght: "$_currentLength",
                );

                await context.read<NoteProvider>().addNote(newNote);

                debugPrint('DEBUG: ID: ${newNote.id}');
                debugPrint('DEBUG UserId: ${newNote.userId}');
                debugPrint('DEBUG: Title: ${newNote.title}');
                debugPrint('DEBUG: Content: ${newNote.content}');
                debugPrint('DEBUG: Date: ${newNote.date}');
                debugPrint('DEBUG: UserID: ${newNote.userId}');

                Navigator.of(context).pop();

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
              mainAxisAlignment: MainAxisAlignment.center,
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
                Row(
                  children: [
                    Text(
                      _currentDate,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      '$_currentLength',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
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
