import 'dart:convert';
import 'dart:io';
import 'package:books/homePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
class Post {
  final String email;
  final String password;
  var rng = new Random();
  Post({this.email,this.password});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      email: json['email'],
      password: json['password']
    );
  }
    Map<String, dynamic> toJson() => {
        "email" : email,
        "password" : password,
        "username" : rng.nextInt(10000)
      };
    Map toMap() {
      var map = new Map<String, dynamic>();
      map["email"] = email;
      map["password"] = password;
      
      return map;
    }
}
String postToJson(Post data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
Future<http.Response> createPost(Post post) async{
  var url="http://157.245.100.193:8001/auth/users/";
  final response = await http.post('$url',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader : 'Basic dGV4dGJvb2s6dGV4dGJvb2s='
      },
      body: postToJson(post)
  );
  return response;
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  TextEditingController _emailController ;
  TextEditingController _passwordController ;
  String _email;
  String _password;
Future pause(Duration d) => new Future.delayed(d);
  String output='';
  callAPI(String _email,_password){
    Post post = Post(
              email: _email,
        password: _password,//'Testing body body body',
      //title: 'Flutter jam6'
    );
    createPost(post).then((response){
        if(response.statusCode >= 200)
        {
          output = response.body;
          //output = response.body.toString();
          // arr=output.split(':');
          // print("arr[0]  =  " + arr[3]);
          // s1=arr[3].toString();
          // print(s1);
          // videoUrl=s1.split(",")[0];
          //print(output);
        }
        else
          print(response.statusCode);
    }).catchError((error){
      print('error : $error');
    });
    return output;
  }
  @override
  void initState() {
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _emailController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }
  void _submit(output) {
    final form = formKey.currentState;
    List arr=[];
    bool complete =false;
    //if (form.validate()) {
      var parsedJson = json.decode(output);
      var email = parsedJson['email'];
      print("api output " + output);
       arr = output.split(':');
      // print("arr1" + arr[1]);
      // print("arr3" + arr[1]);
      if (email != _email){
        print("arr" + arr[0]);
        String msg = arr[0].toString().replaceAll('"', "");
        msg=msg.replaceAll('{', "");
        var messageEntity = parsedJson[msg];
        print(" ME "+ messageEntity[0]);
        showDialog(
        context: context,
        builder: (BuildContext context) {
        return AlertDialog(
              content: new Text(msg.toUpperCase() +" : "+messageEntity.toString().replaceAll("[", " ").replaceAll("]", " ").toUpperCase()),
              actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      new FlatButton(
                        child: new Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
        }
        );
      }
      else{
      form.save();
      complete =true;
      }
      if(complete==true){
        performLogin();
      }
  }
    //}
  void performLogin() {
    final snackbar = new SnackBar(
      content: new Text("Email : $_email, password : $_password"),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
    Navigator
    .of(context)
    .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => HomePage(_email)));
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Color.fromRGBO(0, 102, 204, 30),
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor:Colors.transparent,
          brightness: Brightness.dark,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Text(
                "Skip",
                style: TextStyle(fontSize: 15),
              ),
              onPressed: (){
              Navigator
                  .of(context)
                  .push(new MaterialPageRoute(builder: (BuildContext context) => HomePage("Arun")));
                  },
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        
          child : Text(
          "Don't have an account? Join now",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.w500)),
        ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left:25,right:25),
          child: new Form(
            key: formKey,
            child: new Column(
              children: <Widget>[
                new Text(
                  "PASSWORD",style: TextStyle(fontSize: 50,color: Colors.white),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 25),
                ),
                new Text(
                  "Log in with your account",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.w500),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 100),
                ),
                new TextFormField(
                   style: TextStyle(
                        color: Colors.white,
                    ),
                  decoration: new InputDecoration(border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "Email",labelStyle: TextStyle(fontSize: 22,
                    color: Colors.white),
                  prefixIcon: Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.mail, 
                          color: Colors.white,
                        ), // icon is 48px widget.
                      ),),
                  validator: (val) =>
                      !val.contains('@') ? 'Invalid Email' : null,
                  onSaved: (val) => _email = val,
                  onChanged: (v)=>setState((){_email=v;}),
                  controller: _emailController,
                  cursorColor: Colors.white,
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                new TextFormField(   
                   style: TextStyle(
                      color: Colors.white,
                  ),
                  decoration: new InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                        
                        borderRadius: BorderRadius.circular(10.0),
                    ),labelText: "Password",fillColor: Colors.white,labelStyle: TextStyle(fontSize: 22
                  ,color: Colors.white),
                     prefixIcon: Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ), // icon is 48px widget.
                      ),),
                  validator: (val) =>
                      val.length < 6 ? 'Password too short' : null,
                  onSaved: (val) => _password = val,
                  obscureText: true,
                  cursorColor: Colors.white,
                  
                  onChanged: (v)=>setState((){_password=v;}),
                  controller: _passwordController,              
                    ),
                new Padding(
                  padding: const EdgeInsets.only(top: 20.0,bottom: 10),
                ),
                new ButtonTheme(
                  minWidth: 320,
                  height: 45,
                child : RaisedButton(
                  child: new Text(
                    "Log In",
                    style: new TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 20),
                  ),
                  color: Colors.white,
                  onPressed:(){ 
                    output=callAPI(_email,_password);
                    _submit(output);
                  },
                      shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                ),
                GestureDetector(
                  child: new Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.w500),
                  ),
                  onTap: (){
                    //add onTap page 
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  }