import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:note_mory/models/note.dart';

class SharedPreferencesService {
  // Menyimpan catatan ke SharedPreferences
  Future<void> saveNote(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notesList =
        notes.map((note) => json.encode(note.toMap())).toList();
    await prefs.setStringList('notes', notesList);
  }

  /// Mengambil catatan dari SharedPreferences
  Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notesList = prefs.getStringList('notes') ?? [];

    return notesList.map((noteData) {
      Map<String, dynamic> noteMap = json.decode(noteData);
      return Note.fromMap(noteMap);
    }).toList();
  }

  /// Mengedit catatan
  Future<void> editNote(Note originalNote, Note updatedNote) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notesList = prefs.getStringList('notes') ?? [];

    for (int i = 0; i < notesList.length; i++) {
      Map<String, dynamic> noteMap = json.decode(notesList[i]);
      if (noteMap['date'] == originalNote.date) {
        notesList[i] = json.encode(updatedNote.toMap());
        break;
      }
    }

    await prefs.setStringList('notes', notesList);
  }

  /// Menghapus catatan tertentu
  Future<void> deleteNote(Note noteToDelete) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notesList = prefs.getStringList('notes') ?? [];

    notesList.removeWhere((noteData) {
      Map<String, dynamic> noteMap = json.decode(noteData);
      return noteMap['date'] == noteToDelete.date;
    });

    await prefs.setStringList('notes', notesList);
  }

  /// Menghapus semua catatan
  Future<void> clearNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notes');
  }
}
