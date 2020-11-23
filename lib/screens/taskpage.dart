import 'package:flutter/material.dart';
import 'package:todo/database_helper.dart';
import 'package:todo/models/task.dart';

import '../widgets.dart';

class Taskpage extends StatefulWidget {
  final Task task;
  Taskpage({@required this.task});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  String _taskTitle = "";

  @override
  void initState() {
    if (widget.task != null) {
      _taskTitle = widget.task.title;
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
                            image:
                                AssetImage('assets/images/back_arrow_icon.png'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          onSubmitted: (value) async {
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
                          },
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
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Enter Todo item...",
                              border: InputBorder.none,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            Positioned(
              bottom: 24.0,
              right: 0.0,
              child: GestureDetector(
                onTap: () {},
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
    ));
  }
}

class CreateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
