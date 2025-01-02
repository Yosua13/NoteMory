import 'package:flutter/material.dart';
import 'package:note_mory/models/note.dart';
import 'package:note_mory/services/shared_preferences_service.dart';

class NoteProvider with ChangeNotifier {
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  /// Mengambil catatan yang disimpan dari SharedPreferences
  Future<void> loadNotes() async {
    _notes = await _sharedPreferencesService.loadNotes();
    notifyListeners();
  }

  /// Menambah catatan baru
  Future<void> addNote(Note note) async {
    _notes.add(note);
    await _sharedPreferencesService.saveNote(_notes);
    notifyListeners();
  }

  /// Mengedit catatan
  Future<void> editNote(Note originalNote, Note updatedNote) async {
    await _sharedPreferencesService.editNote(originalNote, updatedNote);
    int index = _notes.indexWhere((note) => note.date == originalNote.date);
    if (index != -1) {
      _notes[index] = updatedNote;
      notifyListeners();
    }
  }

  /// Menghapus catatan
  Future<void> deleteNote(Note noteToDelete) async {
    await _sharedPreferencesService.deleteNote(noteToDelete);
    _notes.removeWhere((note) => note.date == noteToDelete.date);
    notifyListeners();
  }

  /// Menghapus semua catatan
  Future<void> deleteAllNotes() async {
    await _sharedPreferencesService.clearNotes();
    _notes.clear();
    notifyListeners();
  }
}
