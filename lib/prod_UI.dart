import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/app_config.dart';

class NotesScreenn extends StatefulWidget {
  const NotesScreenn({super.key});

  @override
  State<NotesScreenn> createState() => _NotesScreennState();
}

class _NotesScreennState extends State<NotesScreenn> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final titleCtrl = TextEditingController();
  final subtitleCtrl = TextEditingController();

  CollectionReference get notes => _db.collection('otherNotes');

  late Future<QuerySnapshot> notesFuture;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    notesFuture = notes.orderBy('subtitle', descending: true).get();
  }

  Future<void> addNotes() async {
    await notes.add({'title': titleCtrl.text, 'subtitle': subtitleCtrl.text});
    Navigator.pop(context);
    titleCtrl.clear();
    subtitleCtrl.clear();
    setState(_loadNotes);
  }

  Future<void> updateNotes(String id) async {
    await notes.doc(id).update({
      'title': titleCtrl.text,
      'subtitle': subtitleCtrl.text,
    });
    Navigator.pop(context);
    titleCtrl.clear();
    subtitleCtrl.clear();
    setState(_loadNotes);
  }

  Future<void> deleteNote(String id) async {
    await notes.doc(id).delete();
    setState(_loadNotes);
  }

  void openSheet({DocumentSnapshot? note}) {
    if (note != null) {
      final data = note.data() as Map<String, dynamic>;
      titleCtrl.text = data['title'];
      subtitleCtrl.text = data['subtitle'];
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: subtitleCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: note == null ? addNotes : () => updateNotes(note.id),
              child: Text(note == null ? 'Add Note' : 'Update Note'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppConfig.of(context).appName)),
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
                title: Text(data['title'] ?? ''),
  subtitle: Text(data['subtitle'] ?? ''),
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
