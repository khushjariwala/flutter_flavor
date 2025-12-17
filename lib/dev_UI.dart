import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  CollectionReference get notes => _db.collection('notes_dev');

  late Future<QuerySnapshot> notesFuture;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() {
    notesFuture = notes.orderBy('createdAt', descending: true).get();
  }

  // CREATE
  Future<void> addNote() async {
    await notes.add({
      'title': titleCtrl.text,
      'description': descCtrl.text,
      'createdAt': FieldValue.serverTimestamp(),
    });
    Navigator.pop(context);
    titleCtrl.clear();
    descCtrl.clear();
    setState(_loadNotes);
  }

  // UPDATE
  Future<void> updateNote(String id) async {
    await notes.doc(id).update({
      'title': titleCtrl.text,
      'description': descCtrl.text,
    });
    Navigator.pop(context);
    titleCtrl.clear();
    descCtrl.clear();
    setState(_loadNotes);
  }

  // DELETE
  Future<void> deleteNote(String id) async {
    await notes.doc(id).delete();
    setState(_loadNotes);
  }

  // Bottom Sheet (Keyboard Safe)
  void openSheet({DocumentSnapshot? note}) {
    if (note != null) {
      final data = note.data() as Map<String, dynamic>;
      titleCtrl.text = data['title'];
      descCtrl.text = data['description'];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: note == null
                    ? addNote
                    : () => updateNote(note.id),
                child: Text(note == null ? 'Add Note' : 'Update Note'),
              ),
            ],
          ),
        );
      },
    );
  }

  // READ (FutureBuilder)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Notes (DEV)')),
      body: FutureBuilder<QuerySnapshot>(
        future: notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notes yet'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final note = docs[index];
              final data = note.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['title']),
                subtitle: Text(data['description'] ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => openSheet(note: note),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteNote(note.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openSheet(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
