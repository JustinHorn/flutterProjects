import 'package:flutter/material.dart';
import 'package:todo/database_helper.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/todo.dart';

import '../widgets.dart';

class Taskpage extends StatefulWidget {
  final Task task;
  Taskpage({@required this.task});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  String _taskTitle = "";
  int _taskId = 0;
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    if (widget.task != null) {
      _taskTitle = widget.task.title;
      _taskId = widget.task.id;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 0,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 6.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: Image(
                              image: AssetImage(
                                  'assets/images/back_arrow_icon.png'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            onSubmitted: addTaskMethod,
                            controller: TextEditingController()
                              ..text = _taskTitle,
                            decoration: InputDecoration(
                              hintText: "Enter Task Title",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF211551),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 8.0,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Description for the task...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    initialData: [],
                    future: _dbHelper.getTodos(_taskId),
                    builder: (context, snapshot) => Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // switch the todo completion state
                            },
                            child: TodoWidget(
                              isDone: snapshot.data[index].isDone == 0
                                  ? false
                                  : true,
                              text: snapshot.data[index].title,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onSubmitted: addToDoMethod,
                          decoration: InputDecoration(
                            hintText: "Enter Todo item...",
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () async {
                    if (widget.task != null) {
                      await _dbHelper.deleteTask(widget.task.id);
                      print("task deleted");
                    } else {
                      print("error");
                    }
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFFE3577),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image(
                      image: AssetImage("assets/images/delete_icon.png"),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addTaskMethod(value) async {
    if (value != "") {
      DatabaseHelper _dbHelper = DatabaseHelper();

      if (widget.task == null) {
        Task _newTask = Task(title: value);

        await _dbHelper.insertTask(_newTask);
        print("A new Task has been created!");
      } else {
        print("update the existing task");
      }
    }
  }

  void addToDoMethod(value) async {
    if (value != "") {
      if (widget.task != null) {
        Todo _newTodo = Todo(
          title: value,
          isDone: 0,
          taskId: widget.task.id,
        );

        await _dbHelper.insertTodo(_newTodo);
        setState(() {});
      } else {}
    }
  }
}

class CreateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
