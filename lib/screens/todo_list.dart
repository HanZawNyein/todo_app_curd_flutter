import 'package:flutter/material.dart';
import 'package:todo_app_curd_flutter/screens/add_page.dart';
import 'package:todo_app_curd_flutter/services/todo_service.dart';
import 'package:todo_app_curd_flutter/widget/todo_cart.dart';

import '../utils/snackbar_helper.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
        centerTitle: true,
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                "No Todo Item",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            child: ListView.builder(
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                // final id = item["_id"] as String;
                return TodoCard(
                    index: index,
                    item: item,
                    navigateToEditPage: navigateToEditPage,
                    deleteById: deleteById);
              },
              itemCount: items.length,
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: const Text("Add Todo")),
    );
  }

  Future<void> deleteById(String id) async {
    final success = await TodoService.deleteById(id);
    if (success) {
      final filtered = items.where((element) => element["_id"] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMessage(context, message: "Deletion Failed.");
    }
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
        builder: (context) => AddTodoPage(
              todo: item,
            ));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddTodoPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> fetchTodo() async {
    final results = await TodoService.fetchTodos();
    if (results != null) {
      setState(() {
        items = results;
      });
    } else {
      showErrorMessage(context, message: "Something went wrong.");
    }
    setState(() {
      isLoading = false;
    });
  }
}
