import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultButton({
  double width = double.infinity ,
  Color background = Colors.blue ,
  bool isUpperCase = true,
  @required Function function ,
  @required String text ,
}) => Container(
  padding: EdgeInsets.all(8),
  width: width,
  height: 40,
  color: background,
  child: MaterialButton(
    onPressed: function,
    child: Text(
      isUpperCase ?  text.toUpperCase() : text ,
      style: TextStyle(
          fontSize: 20 ,
          color: Colors.white ),),
  ),
);


Widget defaultFormField({
  @required Function validate,
  @required TextEditingController controller,
  @required TextInputType type,
  @required String label,
  @required IconData prefix,
  IconData suffic,
  bool isPassword = false,
  Function suffixPressed,
  Function onTap,
  bool isClickable = true,

}) =>TextFormField(
validator:validate,
controller: controller,
keyboardType: type,
obscureText: isPassword,
onTap: onTap,
enabled: isClickable,
decoration: InputDecoration(
labelText: label,
prefixIcon: Icon(prefix),
suffixIcon: suffic != null ? IconButton(
  onPressed: suffixPressed,
    icon: Icon(suffic)) : null,
border: OutlineInputBorder(),
),
);


Widget buildTaskItme(Map model, context) => Dismissible(
  key: Key(model['id'].toString()) ,
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteData(id: model['id']);
  },
  child: Padding(
    padding: const EdgeInsets.all(20.0),
  
    child: Row(
  
      children: [
  
        CircleAvatar(
  
          radius: 40.0,
  
          child: Text('${model['time']}'),
  
        ),
  
        SizedBox(width: 20,),
  
        Expanded(
  
          child: Column(
  
            mainAxisSize: MainAxisSize.min,
  
            crossAxisAlignment: CrossAxisAlignment.start,
  
            children: [
  
              Text(
  
                '${model['title']}',
  
                style: TextStyle(
  
                  fontSize: 17,
  
                  fontWeight: FontWeight.bold,
  
                ) ,
  
  
  
              ),
  
              Text(
  
                '${model['date']}',
  
                style: TextStyle(
  
                  color:Colors.grey,
  
                ) ,
  
  
  
              ),
  
            ],
  
          ),
  
        ),
  
        SizedBox(width: 20,),
  
        IconButton(
  
            onPressed: (){
  
              AppCubit.get(context).updateData(
  
                  status: 'done',
  
                  id: model['id']);
  
            },
  
            icon: Icon(Icons.check_box_outlined),color: Colors.green,),
  
        IconButton(
  
            onPressed: (){
  
              AppCubit.get(context).updateData(
  
                  status: 'archive',
  
                  id: model['id']);
  
            },
  
            icon: Icon(Icons.archive_outlined),color: Colors.black26,),
  
      ],
  
    ),
  
  ),
);


Widget tasksBuilder({
  @required List<Map> tasks ,
}) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
    itemBuilder: (context , index) => buildTaskItme(tasks[index] , context),
    separatorBuilder: (context, index) => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20,
      ),
      child: Container(
        width:double.infinity ,
        height: 1,
        color: Colors.grey[200],
      ),
    ),
    itemCount: tasks.length,),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu ,
          size:  80,
          color: Colors.grey,),
        SizedBox(height: 20,),
        Text('No Tasks Yet , Please add some Tasks',
          style: TextStyle(
              fontSize: 20 ,
              color: Colors.grey,
              fontWeight: FontWeight.bold),),
      ],
    ),
  ),
);