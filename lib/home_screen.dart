import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive Database"),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: Hive.openBox('asif'),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(snapshot.data?.get('name').toString() ?? ''),
                      subtitle:
                          Text(snapshot.data?.get('age').toString() ?? ''),
                      trailing: IconButton(
                        onPressed: () {
                          snapshot.data!.put('name', 'Anup Upadhaya');
                          snapshot.data!.put('age', '40');
                          setState(() {});
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                  ],
                );
              }),
          // FutureBuilder(
          //     future: Hive.openBox('name'),
          //     builder: (context, snapshot) {
          //       return Column(
          //         children: [
          //           ListTile(
          //             title:
          //                 Text(snapshot.data?.get('youtube').toString() ?? ''),
          //           ),
          //         ],
          //       );
          //     }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var box = await Hive.openBox("asif");
          var box2 = await Hive.openBox("name");
          box2.put('youtube', 'Anup Tech');
          box.put('name', 'asif taj');
          box.put('age', '25');
          box.put('details', {'pro': 'developer', 'kash': 'assd'});
          print(box.get('name'));
          print(box.get('age'));
          print(box2.get('youtube'));
          print(box.get('details')['pro']);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
