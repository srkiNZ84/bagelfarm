import 'package:flutter/material.dart';
import 'package:location/location.dart' as locLib;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:map_view/figure_joint_type.dart';
import 'package:map_view/map_view.dart' as mapViewLib;
import 'package:map_view/polygon.dart';
import 'package:map_view/polyline.dart';

void main() {
  mapViewLib.MapView.setApiKey('API_KEY_HERE');
  runApp(new Bagelfarm());
}

class Bagelfarm extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Bagelfarm',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new BagelfarmHomePage(title: 'Bagelfarm Home Page'),
    );
  }
}

class BagelfarmHomePage extends StatefulWidget {
  BagelfarmHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BagelfarmHomePageState createState() => new _BagelfarmHomePageState();
}

class _BagelfarmHomePageState extends State<BagelfarmHomePage> {
  mapViewLib.MapView mapView = new mapViewLib.MapView();
  mapViewLib.CameraPosition cameraPosition;
  //var compositeSubscription = new CompositeSubscription();
  var staticMapProvider = new mapViewLib.StaticMapProvider('API_KEY_HERE');
  Uri staticMapUri;
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  // Variables for capturing the current location
  Map<String,double> currentLocation = new Map();
  Stream<Map<String,double>> locationSubscription;

  locLib.Location location = new locLib.Location();
  String error;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            height: 250.0,
            child: new Stack(
              children: <Widget>[
                new Center(
                    child: new Container(
                      child: new Text(
                        "You are supposed to see a map here.\n\nAPI Key is not valid.\n\n"
                            "To view maps in the example application set the "
                            "API_KEY variable in example/lib/main.dart. "
                            "\n\nIf you have set an API Key but you still see this text "
                            "make sure you have enabled all of the correct APIs "
                            "in the Google API Console. See README for more detail.",
                        textAlign: TextAlign.center,
                      ),
                      padding: const EdgeInsets.all(20.0),
                    )),
                new InkWell(
                  child: new Center(
                    child: new Image.network(staticMapUri.toString()),
                  ),
                  onTap: showMap,
                )
              ],
            ),
          ),
          new Container(
            padding: new EdgeInsets.only(top: 10.0),
            child: new ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              children: <Widget>[
                new Divider(),
                new Text('Italian Rose', style: _biggerFont),
                new Divider(),
                new Text('Cafe Europa', style: _biggerFont),
                new Divider(),
                new Text('Geeeorgies', style: _biggerFont),
                new Divider()
              ]
            )
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    initPlatformState();
    locationSubscription = location.onLocationChanged();
    locationSubscription.listen((Map<String,double> result) {
      setState((){
        currentLocation = result;
      });
    });

    var auckland = new mapViewLib.Location(-36.8621448,174.5852861);
    cameraPosition = new mapViewLib.CameraPosition(auckland, 2.0);
    staticMapUri = staticMapProvider.getStaticUri(auckland, 12,
        width: 900, height: 400, mapType: mapViewLib.StaticMapViewType.roadmap);
  }

  void initPlatformState() async {
    Map<String,double> whereAmI;
    try {
      whereAmI = await location.getLocation();
      error = "";
    } on PlatformException catch(e){
      if(e.code == 'PERMISSION_DENIED')
        error = 'GeoLocation permission denied';
      else if(e.code == 'PERMISSION_DENIED_NEVER_ASK')
        error = 'Geolocation permission denied - please ask the user to enable it in the app settings';
      whereAmI = null;
    }
    setState(() {
      currentLocation = whereAmI;
    });
  }

  void showMap(){
    print('In the showMap function');
  }
}
