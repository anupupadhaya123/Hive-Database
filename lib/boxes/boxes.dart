import 'package:hive/hive.dart';
import 'package:hiveLearn/models/notes_model.dart';

class Boxes {
  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
}
