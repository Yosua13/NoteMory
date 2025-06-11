import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_mory/models/note.dart';

class NoteWithFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Note>> fetchNotes(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .get();

    return snapshot.docs.map((doc) => Note.fromMap(doc.data())).toList();
  }

  Future<void> addNote(Note note) async {
    await _firestore
        .collection('users')
        .doc(note.userId)
        .collection('notes')
        .doc(note.id)
        .set(note.toMap());
  }

  Future<void> updateNote(Note note) async {
    await _firestore
        .collection('users')
        .doc(note.userId)
        .collection('notes')
        .doc(note.id)
        .update(note.toMap());
  }

  Future<void> deleteNote(Note note) async {
    await _firestore
        .collection('users')
        .doc(note.userId)
        .collection('notes')
        .doc(note.id)
        .delete();
  }
}
