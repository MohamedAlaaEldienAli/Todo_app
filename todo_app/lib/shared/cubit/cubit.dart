


import 'package:todo_app/modules/archived/archived_tasks_screen.dart';
import 'package:todo_app/modules/done/done_tasks_screen.dart';
import 'package:todo_app/modules/tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());


  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0 ;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List <String> title = [
    'New Tasks',
    'Done Tasks',
    'Arcgived Tasks',
  ];

  void changeIndex(int index)
  {
    currentIndex = index ;
    emit(AppChangeBottomNabBarState());
  }

  Database database;
  List<Map> newTasks =[] ;
  List<Map> doneTasks =[] ;
  List<Map> archivedTasks =[] ;

  void createDatabase() {

    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database , version)
      {
        print('database Created');
        database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT , status TEXT)').then((value)
        {
          print('table Created');
        }
        ).catchError((error){
          print('Error when creating table ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

 insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {

   await database.transaction((txn)
    {
      txn.rawInsert(
          'INSERT INTO tasks(title, time, date , status)  VALUES( "$title", "$time", "$date" ,  "new" )'
      ).then((value)
      {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);

      }).catchError((error){
        print('Error when inserting record ${error.toString()}');
      });

    });


  }

  void getDataFromDatabase(database)
  {
      newTasks = [];
      doneTasks = [];
      archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value)
    {


      value.forEach((element){
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else archivedTasks.add(element);
      });

        emit(AppGetDatabaseState());
    });
  }

  bool isBottomSheetShow = false ;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  })
  {
    isBottomSheetShow = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }

  void updateData({
    @required String status,
    @required int id,
  }) async
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['${status}', id ],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });


  }

  void deleteData({

    @required int id,
  }) async
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });


  }
}