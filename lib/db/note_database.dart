
import 'package:authentication/auth/auth_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesDatabase{
  final notesTable = Supabase.instance.client.from('notes');
  final authService = AuthServices();
  //insert
  Future<void>insertNotes(String content)async{
    final uid = authService.getCurrentUserUid();
    await notesTable.insert({'content':content, 'uid':uid});
  }
  //update
  Future<void>updateNotes(dynamic noteId, String content)async{
    await notesTable.update({'content':content}).eq('id', noteId);
  }
  //delete
  Future<void>deleteNotes(dynamic noteId)async{
    await notesTable.delete().eq('id', noteId);
  }
}