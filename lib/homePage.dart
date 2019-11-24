import 'dart:convert';
import 'package:books/videos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
class Post {
  final String url;
  Post({this.url});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      url: json['eng'],
    );
  }
  Map<String, dynamic> toJson() => {
      "id":"3",
    };
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["url"] = url;
    
    return map;
  }
}
String postToJson(Post data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
Future<http.Response> createPost(Post post) async{
  var url="http://157.245.100.193:8001/media/videoplayback_TcZVf8s.mp4"; 
  final response = await http.get('$url',
      headers: {
       // HttpHeaders.contentTypeHeader: 'application/json',
       // HttpHeaders.authorizationHeader : 'Basic dGV4dGJvb2s6dGV4dGJvb2s='
      }
      ,
      //body: postToJson(post),
  );
    return response;

}
class HomePage extends StatefulWidget{
    final String _email;
  HomePage(this._email,{Key key}): super(key: key);//add also..example this.abc,this...
  @override
  _HomePageState createState() => new _HomePageState();
}
class _HomePageState extends State<HomePage> {
  String result = "Scanning \n Image";
  String output='';
  callAPI(String _text){
    Post post = Post(
      url: _text,//'Testing body body body',
      //title: 'Flutter jam6'
    );
    createPost(post).then((response){
        if(response.statusCode >= 200)
        {
          output = response.body;
          // output = response.body.toString();
          // arr=output.split(':');
          // print("arr[0]  =  " + arr[3]);
          // s1=arr[3].toString();
          // print(s1);
          // videoUrl=s1.split(",")[0];
          // print(response.body);
        }
        else
          print(response.statusCode);
    }).catchError((error){
      print('error : $error');
    });
    return output;
  }
  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
    print("hslkhihiu");
      if (result != null){
         print("result not null" + result);
         Navigator
        .of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) => Videos(result)));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top:50),
            ),
            Text(
              "Welcome "+ widget._email,textAlign: TextAlign.center,style: TextStyle(fontSize: 40,fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            Center(
            child : Container(
              height: 400,
              width: 300,
              padding: EdgeInsets.only(top: 150),
              child: Text(
                result,textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600),
              ),
              decoration: ShapeDecoration(
                color: Color.fromRGBO(230,230,230,50),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                )
              ),
            ),
            ),
            Padding(
              padding: EdgeInsets.only(top:40),
            ),
            ButtonTheme(
              minWidth: 320,
              height: 45,
              child : RaisedButton(
              color: Color.fromRGBO(0, 102, 204, 30),
              child: Text(
                " SCAN CODE IN TEXTBOOK",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20,color: Colors.white),
              ),
              onPressed: (){
                  _scanQR();
          
              },
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
              ),
            ),
            )
          ],
        ),
      )
    );
  }
  }
