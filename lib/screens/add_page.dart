import 'package:flutter/material.dart';
import 'package:todo_app_curd_flutter/services/todo_service.dart';
import 'package:todo_app_curd_flutter/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;

  const AddTodoPage({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      titleController.text = todo["title"];
      descriptionController.text = todo["description"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              autofocus: true,
              onPressed: isEdit ? updateData : submitData,
              child: Text(isEdit ? "Update" : 'Submit'),
              // style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.th,
              // ),
          ),
        ],
      ),
    );
  }

  void updateData() async {
    final todo = widget.todo;
    final isUpdated = await TodoService.updateTodo(todo!["_id"], body);
    if (isUpdated) {
      showSuccessMessage(context, message: "Update Task Successfully.");
    } else {
      showErrorMessage(context, message: "Update Failed.");
    }
  }

  void submitData() async {
    final isCreated = await TodoService.createTodo(body);
    if (isCreated) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: "Create Task Successfully.");
    } else {
      showErrorMessage(context, message: "Error");
    }
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {"title": title, "description": description, "is_completed": false};
  }
}
