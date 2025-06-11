import 'package:flutter/material.dart';
import 'package:note_mory/models/note.dart';
import 'package:note_mory/services/note_with_firebase_service.dart';
import 'package:note_mory/providers/user_provider.dart';
import 'package:note_mory/services/shared_preferences_service_notes.dart';

class NoteProvider with ChangeNotifier {
  final UserProvider userProvider;

  NoteProvider({required this.userProvider});
  final SharedPreferencesServiceNotes _sharedPreferencesService =
      SharedPreferencesServiceNotes();

  final NoteWithFirebaseService _firebaseService = NoteWithFirebaseService();

  List<Note> _notes = [];
  List<Note> get notes => _notes;

  Future<void> loadNotes() async {
    final userId = userProvider.user?.id;
    if (userId == null) return;
    try {
      _notes = await _firebaseService.fetchNotes(userId);
      await _sharedPreferencesService.saveNote(userId, _notes);
    } catch (e) {
      _notes = await _sharedPreferencesService.loadNotes(userId: userId);
    }
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    _notes.add(note);
    await _firebaseService.addNote(note);
    await _sharedPreferencesService.saveNote(note.userId!, _notes);
    notifyListeners();
  }

  Future<void> editNote(Note originalNote, Note updatedNote) async {
    int index = _notes.indexWhere((note) => note.id == originalNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      await _firebaseService.updateNote(updatedNote);
      await _sharedPreferencesService.editNote(originalNote, updatedNote);
      notifyListeners();
    }
  }

  Future<void> deleteNote(Note noteToDelete) async {
    _notes.removeWhere((note) => note.id == noteToDelete.id);
    await _firebaseService.deleteNote(noteToDelete);
    await _sharedPreferencesService.deleteNote(noteToDelete);
    notifyListeners();
  }

  Future<void> deleteAllNotes() async {
    final userId = userProvider.user?.id;
    if (userId == null) return;
    for (var note in _notes) {
      await _firebaseService.deleteNote(note);
    }
    _notes.clear();
    await _sharedPreferencesService.clearNotes();
    notifyListeners();
  }
}
