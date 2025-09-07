
import 'package:authentication/auth/auth_services.dart';
import 'package:authentication/db/note_database.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage>
    with SingleTickerProviderStateMixin {
  final _noteController = TextEditingController();
  final _titleController = TextEditingController();
  final notesdb = NotesDatabase();
  final authService = AuthServices();

  final List<String> categories = ["Daily", "Weekly", "Monthly"];
  String choose = "Daily";
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  void addNewNotes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add new note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: "Content",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Category",
                border: OutlineInputBorder(),
              ),
              value: choose,
              items: categories.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                choose = newValue!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _noteController.clear();
              _titleController.clear();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              try {
                await notesdb.insertNotes(
                  _titleController.text,
                  _noteController.text,
                  choose,
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Insertion Successful")),
                  );
                }
                Navigator.pop(context);
                _noteController.clear();
                _titleController.clear();
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

  void deleteNotes(dynamic id) async {
    try {
      await notesdb.deleteNotes(id);
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Deletion Successful")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  void updateNotes(
    dynamic id,
    String oldTitle,
    String oldContent,
    String oldChoiceList,
  ) {
    _titleController.text = oldTitle;
    _noteController.text = oldContent;
    choose = oldChoiceList;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Update note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: "Content",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Option",
                border: OutlineInputBorder(),
              ),
              value: choose,
              items: categories.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  choose = newValue!;
                });
              },
            ),
          ],
        ),
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
                await notesdb.updateNotes(
                  id,
                  _titleController.text,
                  _noteController.text,
                  choose,
                );
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
              Navigator.pop(context);
              _noteController.clear();
              _titleController.clear();
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = authService.getCurrentUserUid();

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
            "My Notes",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(
                icon: Icon(Icons.today, color: Colors.white),
                text: "Daily",
              ),
              Tab(
                icon: Icon(Icons.calendar_view_week, color: Colors.white),
                text: "Weekly",
              ),
              Tab(
                icon: Icon(Icons.calendar_month, color: Colors.white),
                text: "Monthly",
              ),
            ],
            controller: _tabController,
            //tabs: categories.map((c) => Tab(text: c)).toList(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addNewNotes,
          child: Icon(Icons.add),
        ),
        body: TabBarView(
          controller: _tabController,
          children: categories.map((category) {
            return StreamBuilder(
              stream: notesdb.notesTable
                  .stream(primaryKey: ['id'])
                  .eq('uid', uid!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final allNotes = snapshot.data!;
                final notes = allNotes
                    .where((n) => n['choose'] == category)
                    .toList();

                if (notes.isEmpty) {
                  return Center(child: Text("No notes in $category"));
                }

                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    final id = note['id'];
                    final title = note['title'];
                    final content = note['content'];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        leading: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: category == 'Daily' ? Colors.blue : category == 'Weekly' ? Colors.orange : Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            category.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        title: Text(
                          title ?? "",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(content ?? ""),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  updateNotes(id, title, content, choose),
                              icon: Icon(Icons.edit, color: Colors.deepPurple),
                            ),
                            IconButton(
                              onPressed: () => deleteNotes(id),
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
