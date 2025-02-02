import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/utils/dialog_box.dart';
import 'package:todo_app/utils/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  //reference the hive box
  final _myBox = Hive.box('myBox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    // TODO: implement initState
    // if this is the 1st time ever opening the data then create a default data
    if(_myBox.get("TODOLIST") == null){
      db.createInitialData();
    }
    else{
      // there already exists data
      db.loadData();
    }
    super.initState();
  }
  // text controller
  final _controller = TextEditingController();

  //list of todo tasks


  // List toDoList = [
  //   ["Make Tutorial", false],
  //   ["Do Exercise", false],
  // ];

  //checkbox was tapped
  void checkBoxChanged(bool? value, int index){
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];

    });
    db.updateDataBase();

  }
  //save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text,false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  //create new task
  void createNewTask() {
    showDialog(context: context,
                builder: (context) {
                  return DialogBox(controller: _controller,onSave: saveNewTask, onCancel: () => Navigator.of(context).pop(),);
                });
  }

  //delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: Center(
          child: Text('NOTES APP'),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(onPressed: createNewTask, child: Icon(Icons.add),),
      body: ListView.builder(
          itemCount: db.toDoList.length,
          itemBuilder: (context, index) {
            return ToDoTile(taskName: db.toDoList[index][0], taskCompleted: db.toDoList[index][1], onChanged: (value)=> checkBoxChanged(value,index), deleteFunction: (context) => deleteTask(index),);
          }
      ),
    );
  }
}