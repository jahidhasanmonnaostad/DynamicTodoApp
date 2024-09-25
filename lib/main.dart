// Import necessary packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/model.dart';

void main() {
  // Run the app with MultiProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: MyApp(),
    ),
  );
}

// TodoProvider class with ChangeNotifier
class TodoProvider with ChangeNotifier {
  // Private variables for todos and search query
  List<TodoModel> _todos = [
    TodoModel(id: 1, title: "jahid"),
    TodoModel(id: 2, title: "Akash"),
    TodoModel(id: 3, title: "Rana"),
  ];

  List<TodoModel> _searchTodos = [];
  String _searchQuery = '';

  // Getter for todos
  List<TodoModel> get todos => _searchTodos;

  // Add todo method
  void addTodo(String title) {
    _todos.add(TodoModel(id: _todos.length, title: title));
    notifyListeners();
  }

  // Toggle todo method
  void todoToggle(int id) {
    final todo = _todos.firstWhere((todo) => todo.id == id);
    todo.isDone = !todo.isDone;
    notifyListeners();
  }

  // Delete todo method
  void todoDelete(int id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  // Search todo method
  void searchTodo(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _searchTodos = _todos;
    } else {
      _searchTodos = _todos
          .where((todo) => todo.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

// MyApp class
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todo App",
      theme: ThemeData(
        // Primary color for the app
        primaryColor: Colors.green,
      ),
      home: HomeActivity(),
    );
  }
}

// HomeActivity class
class HomeActivity extends StatelessWidget {
  const HomeActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List "),
        backgroundColor: Colors.green,
      ),
      body: TodoScreen(),
    );
  }
}

// TodoScreen class
class TodoScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _addController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text("Dynamic Todo List ",textAlign:TextAlign.center,style:TextStyle(fontSize:40),),
          // Search bar
          SizedBox(height:20,),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText:"Search",
              constraints:BoxConstraints(
                maxHeight:50,
                maxWidth:450,
              ),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              todoProvider.searchTodo(_searchController.text);
            },
          ),
          SizedBox(height: 16),

          // Add todo row
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children:[
              Container(
              width:150,
              child:Expanded(
                child: TextField(
                  controller: _addController,
                  decoration: InputDecoration(
                   hintText: "Enter todo title",
                    border:UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red, // change this to your desired underline color
                        width: 2.0, // change this to your desired underline width
                      ),
                    )
                  ),
                ),
              ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  if (_addController.text.isNotEmpty) {
                    todoProvider.addTodo(_addController.text);
                    _addController.clear(); // Clear input after adding
                  }
                },
              ),
            ],
          ),

          // Todo list
          Expanded(
            child: ListView.builder(
              itemCount: todoProvider.todos.length,
              itemBuilder: (context, index) {
                final todo = todoProvider.todos[index];
                return Container(
                      margin:EdgeInsets.only(top:10),
                      child: ListTile(

                    leading: Checkbox(
                      value: todo.isDone,
                      onChanged: (value) {
                        todoProvider.todoToggle(todo.id);
                      },
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        fontSize: 18,
                        decoration: todo.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: Container(
                      height:40,
                      width:40,
                      decoration:BoxDecoration(
                        shape:BoxShape.circle,
                        color:Colors.red,
                      ),
                      child: IconButton(
                        onPressed: () {
                          todoProvider.todoDelete(todo.id);
                        },
                        icon: Icon(Icons.delete,color:Colors.white,),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Table(
            border: TableBorder.all(color: Colors.black),
            columnWidths: {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey),
                children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Text('Header 1', style: TextStyle(fontSize: 18)),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Text('Header 2', style: TextStyle(fontSize: 18)),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Text('Header 3', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text('Cell 1'),
                  ),
                  TableCell(
                    child: Text('Cell 2'),
                  ),
                  TableCell(
                    child: Text('Cell 3'),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text('Cell 4'),
                  ),
                  TableCell(
                    child: Text('Cell 5'),
                  ),
                  TableCell(
                    child: Text('Cell 6'),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}