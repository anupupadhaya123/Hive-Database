import 'package:flutter/material.dart';
import 'package:hiveLearn/boxes/boxes.dart';
import 'package:hiveLearn/models/notes_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive Database"),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, child) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(data[index].title.toString()),
                            const Spacer(),
                            InkWell(
                                onTap: () {
                                  _editDialog(
                                      data[index],
                                      data[index].title.toString(),
                                      data[index].description.toString());
                                },
                                child: const Icon(Icons.edit)),
                            const SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap: () {
                                delete(data[index]);
                                descController.clear();
                                titleController.clear();
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Text(data[index].description.toString()),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: "Enter Title", border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(
                        hintText: "Enter description",
                        border: OutlineInputBorder()),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final data = NotesModel(
                      title: titleController.text,
                      description: descController.text);
                  final box = Boxes.getData();
                  box.add(data);

                  // data.save();

                  print(box);
                  titleController.clear();
                  descController.clear();

                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
  }

  Future<void> _editDialog(
      NotesModel notesModel, String title, String description) async {
    titleController.text = title;
    descController.text = description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit Notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: "Enter Title", border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(
                        hintText: "Enter description",
                        border: OutlineInputBorder()),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  notesModel.title = titleController.text.toString();
                  notesModel.description = descController.text.toString();
                  await notesModel.save();
                  descController.clear();
                  titleController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Edit'),
              ),
            ],
          );
        });
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }
}
