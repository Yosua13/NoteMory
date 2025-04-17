import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:note_mory/models/note.dart';

class SharedPreferencesServiceNotes {
  /// Menyimpan catatan ke SharedPreferences
  Future<void> saveNote(String userId, List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> allNotesList = prefs.getStringList('notes') ?? [];

    /// Decode semua catatan
    List<Note> allNotes = allNotesList
        .map((noteData) => Note.fromMap(json.decode(noteData)))
        .toList();

    /// Hapus catatan lama milik user ini
    allNotes.removeWhere((note) => note.userId == userId);

    /// Tambah catatan baru milik user ini
    allNotes.addAll(notes);

    /// Simpan semua catatan kembali
    List<String> updatedNotesList =
        allNotes.map((note) => json.encode(note.toMap())).toList();
    await prefs.setStringList('notes', updatedNotesList);
  }

  /// Mengambil catatan dari SharedPreferences
  Future<List<Note>> loadNotes({required String userId}) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notesList = prefs.getStringList('notes') ?? [];

    return notesList
        .map((noteData) => Note.fromMap(json.decode(noteData)))
        .where((note) => note.userId == userId)
        .toList();
  }

  /// Mengedit catatan
  Future<void> editNote(Note originalNote, Note updatedNote) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notesList = prefs.getStringList('notes') ?? [];

    for (int i = 0; i < notesList.length; i++) {
      Map<String, dynamic> noteMap = json.decode(notesList[i]);
      if (noteMap['id'] == originalNote.id) {
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
      return noteMap['id'] == noteToDelete.id;
    });

    await prefs.setStringList('notes', notesList);
  }

  /// Menghapus semua catatan
  Future<void> clearNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notes');
  }
}
