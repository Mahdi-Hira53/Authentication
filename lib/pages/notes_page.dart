import 'package:authentication/auth/auth_services.dart';
import 'package:authentication/db/note_database.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _noteController = TextEditingController();
  final notesdb = NotesDatabase();
  final authService = AuthServices();
  void addNewNotes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add new note"),
        content: TextField(controller: _noteController),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _noteController.clear();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              try {
                await notesdb.insertNotes(_noteController.text);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Insertion Successful")),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void updateNotes(dynamic id, String oldContent){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Update note"),
        content: TextField(controller: _noteController),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _noteController.clear();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              try {
                //final updateNote = _noteController.text;
                await notesdb.updateNotes(id, _noteController.text);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Update Successfully")),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void deleteNotes(dynamic id)async{
    try{
      await notesdb.deleteNotes(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Deletion Successful")),
        );
      }
    }catch(e){
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = authService.getCurrentUserUid();
    return Scaffold(
      appBar: AppBar(title: Text("Notes Page"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNotes,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: notesdb.notesTable.stream(primaryKey: ['id']).eq('uid', uid!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              final id = note['id'];
              final content = note['content'];
              return Card(
                child: ListTile(
                  leading: Text("$id"),
                  title: Text(content),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: (){
                        deleteNotes(id);
                      }, icon: Icon(Icons.delete)),
                      IconButton(onPressed: () {
                        updateNotes(id, content);
                      }, icon: Icon(Icons.edit)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
