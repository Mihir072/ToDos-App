import 'package:flutter/material.dart';
import 'package:todo_app/color_page.dart';
import 'package:todo_app/screens/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _todos = [];
  String _searchText = '';

  void _addToDo() {
    final String task = _taskController.text.trim();
    if (task.isNotEmpty) {
      setState(() {
        _todos.add({'task': task, 'completed': false});
      });
      _taskController.clear();
    }
  }

  void _deleteToDoAt(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _taskCompleted(int index) {
    setState(() {
      _todos[index]['completed'] = !_todos[index]['completed'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      backgroundColor: appbarColor, // Replace with appbarColor if defined
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value.trim().toLowerCase();
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Add ToDos",
              style: TextStyle(color: Colors.white, fontSize: 50),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: '   Add ToDos',
                      hintStyle: const TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: _addToDo,
                  child: const Text('+', style: TextStyle(fontSize: 30)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos[index];
                  if (_searchText.isNotEmpty &&
                      !todo['task'].toLowerCase().contains(_searchText)) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () => _taskCompleted(index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: Icon(
                          todo['completed']
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: todo['completed'] ? Colors.blue : Colors.grey,
                        ),
                        title: Text(
                          todo['task'],
                          style: TextStyle(
                              decoration: todo['completed']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                        trailing: IconButton(
                          onPressed: () => _deleteToDoAt(index),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

AppBar _appbarWidget() {
  return AppBar(
    backgroundColor: Colors.blue, // Replace with your `appbarColor` variable
    leading: Builder(
      builder: (context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      },
    ),
    actions: [
      Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://cdn-icons-png.flaticon.com/128/236/236832.png',
                ),
              ),
            ),
          );
        },
      ),
    ],
  );
}
