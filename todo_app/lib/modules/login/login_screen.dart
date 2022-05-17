import 'package:todo_app/shared/componetns/components.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>() ;
  bool isPasswordShow = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation:20.2,
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey ,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                      validate: (String val){
                        if(val.isEmpty)
                          {
                            return ' Email must be not Empty';
                          }
                        return null;
                      },
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      label: 'Email',
                      prefix: Icons.alternate_email),
                  SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                      validate: (String val){
                        if(val.isEmpty){
                          return ' Password must be not Empty';
                        }
                        return null;
                      },
                      controller: passwordController,
                      type: TextInputType.visiblePassword,
                      label: 'Password',
                      isPassword: isPasswordShow,
                      suffixPressed: (){
                        setState(() {
                          isPasswordShow = !isPasswordShow;
                        });
                      },
                      prefix: Icons.lock_open,
                      suffic: isPasswordShow ? Icons.visibility : Icons.visibility_off,


                  ),

                  SizedBox(
                    height: 25,
                  ),
                  defaultButton(

                      function: () {
                        if(formKey.currentState.validate()){
                          print(emailController.text);
                          print(passwordController.text);
                        }

                      },
                      text: 'login'),


                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t Have an accont..?', ),
                      TextButton(onPressed: (){}, child: Text('Register Now'))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
