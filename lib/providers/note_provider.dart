import 'package:flutter/material.dart';
import 'package:note_mory/models/note.dart';
import 'package:note_mory/providers/user_provider.dart';
import 'package:note_mory/services/shared_preferences_service_notes.dart';

class NoteProvider with ChangeNotifier {
  final SharedPreferencesServiceNotes _sharedPreferencesService =
      SharedPreferencesServiceNotes();

  final UserProvider userProvider;

  NoteProvider({required this.userProvider});

  List<Note> _notes = [];
  List<Note> get notes => _notes;

  /// Mengambil catatan yang disimpan dari SharedPreferences
  Future<void> loadNotes() async {
    final userId = userProvider.user?.id;
    if (userId != null) {
      _notes = await _sharedPreferencesService.loadNotes(userId: userId);
      notifyListeners();
    }
  }

  /// Menambah catatan baru
  Future<void> addNote(Note note) async {
    _notes.add(note);
    await _sharedPreferencesService.saveNote(note.userId!, _notes);
    notifyListeners();
  }

  /// Mengedit catatan
  Future<void> editNote(Note originalNote, Note updatedNote) async {
    await _sharedPreferencesService.editNote(originalNote, updatedNote);
    int index = _notes.indexWhere((note) => note.id == originalNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      notifyListeners();
    }
  }

  /// Menghapus catatan
  Future<void> deleteNote(Note noteToDelete) async {
    await _sharedPreferencesService.deleteNote(noteToDelete);
    _notes.removeWhere((note) => note.id == noteToDelete.id);
    notifyListeners();
  }

  /// Menghapus semua catatan
  Future<void> deleteAllNotes() async {
    await _sharedPreferencesService.clearNotes();
    _notes.clear();
    notifyListeners();
  }
}
