import 'package:books/playVideo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'homePage.dart';
class Videos extends StatefulWidget {
      final String _id;
  Videos(this._id,{Key key}): super(key: key);//add also..example this.abc,this...
  @override
  _VideosState createState() => _VideosState();
}
class _VideosState extends State<Videos> {
  ScrollController _scrollController;
  String description;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Color.fromRGBO(0, 102, 204, 30),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('Animal Videos',style: TextStyle(fontSize: 40)),
        ),
        bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child:  ButtonTheme(
              height: 45,
              child : RaisedButton(
              color: Colors.white,
              child: Text(
                "SCAN ANOTHER CODE",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20,color: Colors.black),
              ),
              onPressed: (){
             Navigator
            .of(context)
            .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => HomePage("email")));
              },
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
              ),
            ),
            )
      ),
        body: Container(
        margin: EdgeInsets.only(top: 10),
        child: Stack(
          children: <Widget>[
            Center(
           child : _buildCardsList(),
            ),
            
            
          ],
        ),
      ),
    );
  }
  List<ItemModel> items = [
    ItemModel("Giraffe"),
  ];
  Widget _buildItemCardChild(ItemModel item){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(item.title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
             Icons.play_arrow, color: Colors.white54,size: 35,
            ),
          ],
        )
      ],
    );
  }
    Widget _buildItemCard(ItemModel item){
    return InkWell(                        
        child: Container(
      width: 80,
      height: 60,
      padding: EdgeInsets.fromLTRB(12, 16, 10, 0),
      margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(92, 153, 214, 100),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10
          )
        ]
      ),
      child: _buildItemCardChild(item),
      ),
      onTap:(){
        Navigator
        .of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) => VideoPlayerApp()));
        print(item.title +" Card pressed");
      } ,
    );
    }
    Widget _buildCardsList(){
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      itemCount: items.length,
      itemBuilder: (context, index){
        var item = items.elementAt(index);
        return _buildItemCard(item);
      },
    );
    }
    }
class ItemModel{
  final String title; 
  ItemModel(this.title);
}