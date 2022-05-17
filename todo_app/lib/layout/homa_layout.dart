import 'package:todo_app/modules/archived/archived_tasks_screen.dart';
import 'package:todo_app/modules/done/done_tasks_screen.dart';
import 'package:todo_app/modules/tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/componetns/components.dart';
import 'package:todo_app/shared/componetns/constans.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:conditional_builder/conditional_builder.dart';



class HomeLayout extends StatelessWidget
{




  var scaffoldKey = GlobalKey <ScaffoldState> ();
  var formKey = GlobalKey <FormState> ();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();






  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit , AppStates>(
        listener: (BuildContext context , AppStates state){
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context , AppStates state)
        {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
              key:scaffoldKey,
              appBar: AppBar(
                title: Text(
                    cubit.title[cubit.currentIndex]
                ),
              ),
              body:ConditionalBuilder(
                condition: state is! AppGetDatabaseLoadingState,
                builder: (context) => cubit.screens[cubit.currentIndex],
                fallback: (context) => Center(child: CircularProgressIndicator()),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: (){
                  if(cubit.isBottomSheetShow)
                  {
                    if(formKey.currentState.validate())
                    {
                      cubit.insertToDatabase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text);
                    }



                  }
                  else
                  {
                    scaffoldKey.currentState.showBottomSheet(
                          (context) => Container(
                        color: Colors.grey[50],

                        padding: EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                  validate: (String val){
                                    if(val.isEmpty)
                                    {
                                      return ' Title must not be Empty';
                                    }
                                    return null;
                                  },
                                  controller: titleController,
                                  type: TextInputType.text,
                                  label: 'Task Title',
                                  prefix: Icons.title
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              defaultFormField(
                                validate: (String val){
                                  if(val.isEmpty)
                                  {
                                    return ' time must not be Empty';
                                  }
                                  return null;
                                },
                                onTap: (){
                                  showTimePicker(
                                    context: context
                                    , initialTime: TimeOfDay.now(),
                                  ).then((value) => {
                                    timeController.text = value.format(context).toString(),
                                  });
                                },
                                controller: timeController,
                                type: TextInputType.datetime,
                                label: 'Task Time',
                                prefix: Icons.watch_later_outlined,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              defaultFormField(
                                validate: (String val){
                                  if(val.isEmpty)
                                  {
                                    return ' Date must not be Empty';
                                  }
                                  return null;
                                },
                                onTap: (){
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2021-11-15'),
                                  ).then((value) => {
                                    dateController.text = DateFormat.yMMMd().format(value),
                                  });

                                },
                                controller: dateController,
                                type: TextInputType.datetime,
                                label: 'Task Date',
                                prefix: Icons.calendar_today_outlined,
                              ),

                            ],
                          ),
                        ),
                      ) ,
                      elevation: 25.0,
                    ).closed.then((value) {
                      cubit.changeBottomSheetState(
                          isShow: false,
                          icon: Icons.edit,);
                    });
                    cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add,);

                  }

                },
                child: Icon(cubit.fabIcon),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: AppCubit.get(context).currentIndex,
                onTap: (index){

                  AppCubit.get(context).changeIndex(index);
                  // بتساوي
                  //cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archived',
                  ),
                ],
              )
          );
        },

      ),
    );
  }






}




