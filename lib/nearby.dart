import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_food/assitMethods.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:share_food/datahandler/appdata.dart';
import 'package:share_food/searchscreen.dart';
class Nearby extends StatefulWidget {
  const Nearby({ Key? key }) : super(key: key);

  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  late Position currentPosition;
  List<LatLng>pLineCoordinates=[];
  Set<Polyline>polylineSet={};
  var geoLocator= Geolocator();
  double bottomPaddingofMap=0;
  Set<Marker>markerset={};
  Set<Circle>circleset={};

  void locatePosition()async{
    Position position =await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    currentPosition = position;
    LatLng latLatPosition =LatLng(position.latitude,position.longitude);
    CameraPosition cameraPosition=new CameraPosition(target: latLatPosition,zoom: 14.0);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await assistMedhods.searchCoordinateAddress(position,context);
    print("This is your address::"+address);
  }


  double heightvalue=300;
   static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // appBar: AppBar(
      //   backgroundColor:Colors.white
      // ),
      body: Stack(
            children: <Widget>[
                  GoogleMap(
                          padding: EdgeInsets.only(bottom: bottomPaddingofMap, top: 0, right: 0, left: 0),

                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    compassEnabled: true,
                    rotateGesturesEnabled:true,
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    polylines: polylineSet,
                    markers:markerset,
                    circles: circleset,
                    mapToolbarEnabled: true,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller)
                    {
                      _controllerGoogleMap.complete(controller);
                      newGoogleMapController=controller;
                      
                      locatePosition();
                      setState(() {
                        bottomPaddingofMap= 260.0;
                      });
             
                    },
                    ),
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      bottom: 0.0,
                      child: AnimatedContainer(
                        
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:BorderRadius.only(topLeft: Radius.circular(18.0),topRight: Radius.circular(18.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 16.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7,0.7),

                            )
                          ]
                        ),
                        duration: Duration(milliseconds: 1),
                        height: heightvalue,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                style:ElevatedButton.styleFrom(
                                  primary: Colors.black,
                                ),
                                  
                                
                                icon: Icon(Icons. cancel),
                                label: Text("Close"),

                                onPressed: (){
                                  setState(() {
                                    if(heightvalue==300){
                                      heightvalue -=300;
                                    }else{
                                      heightvalue +=300;
                                    }
                                    print(heightvalue);
                                  });
                                  
                                },
                                
                              ),
                            ],
                          ),
                        ),
                      ),
                              SizedBox(height:6.0),
                              Text('Hey There',style: TextStyle(fontSize: 20.0,fontFamily: 'Monserrat Regular',fontWeight: FontWeight.bold),),
                              SizedBox(height:20.0),


                              GestureDetector(
                                onTap: ()async{
                                 var res= await  Navigator.push(context, MaterialPageRoute(builder: (context)=>searchScreen()));
                                if(res=="obtainDirection"){
                                  await  getPlaceDirection();
                                }
                                
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:BorderRadius.circular(5.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                color: Colors.black54,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7,0.7),
                              
                                                          )
                                                        ]
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(12.0),
                                                        child: Row(
                                                          children: <Widget>[
                                Icon(Icons.search,color:Colors.blueAccent),
                                SizedBox(width: 20.0,),
                                Text('Search nearby Orfanages or Ngos',style:TextStyle(color: Colors.grey,fontFamily: 'Monserrat Regular',))
                                                          ],
                                                        ),
                                                      
                                                      ),
                                ),
                              ),
                              SizedBox( height: 24.0,),
                              Row(
                                children:<Widget>[
                                  Icon(Icons.home,color: Colors.grey,),
                                  SizedBox(width: 12,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                          Provider.of<AppData>(context).location !=null? Provider.of<AppData>(context).location!.placeName :
                                          "Add Home"
                                        ),
                                  
                                  SizedBox(height: 4,),
                                  Text('Your Living address',style:TextStyle(color: Colors.black54,fontSize: 13,fontWeight: FontWeight.bold ))
                                  ],),
                                ]

                              )
                            ],
                          ),
                        ),
                      ) ,
                      )
            ],
        ),
      
    );
  }
  Future<void>getPlaceDirection() async{
    var initialPos =Provider.of<AppData>(context,listen: false).location;
    var finalPos =Provider.of<AppData>(context,listen: false).searchLocation;
    var locationLatLng= LatLng(initialPos!.latitude, initialPos.longitude);
  var searchLocationLatLng= LatLng(finalPos!.latitude, finalPos.longitude);

  var details= await assistMedhods.obtainDirections(locationLatLng, searchLocationLatLng );
  

  print("This is Encoded Points ::");
  print(details!.encodedPoints);

  PolylinePoints polylinePoints = PolylinePoints();
  List<PointLatLng> decodePolyLinePointsResult = polylinePoints.decodePolyline(details.encodedPoints);
  pLineCoordinates.clear();
  if(decodePolyLinePointsResult.isNotEmpty){
    decodePolyLinePointsResult.forEach((PointLatLng pointLatLng) {
      pLineCoordinates.add(LatLng(pointLatLng.latitude,pointLatLng.longitude));

    });
    polylineSet.clear();
  }setState(() {
    Polyline polyLine =Polyline(
    color: Colors.blue,
    polylineId: PolylineId("PolylineId"),
    jointType: JointType.round,
    points:pLineCoordinates,
    width: 5,
    startCap:  Cap.roundCap,
    endCap: Cap.roundCap,
    geodesic: true

  );
  polylineSet.add(polyLine);
  });
  LatLngBounds latLngBounds;
  if(locationLatLng.latitude > searchLocationLatLng.latitude && locationLatLng.longitude> searchLocationLatLng.longitude){
    latLngBounds =LatLngBounds(southwest:searchLocationLatLng,northeast: locationLatLng);
  }
  else if(locationLatLng.longitude > searchLocationLatLng.longitude )
  {
    latLngBounds =LatLngBounds(southwest:LatLng(locationLatLng.latitude,searchLocationLatLng.longitude),northeast: LatLng(searchLocationLatLng.latitude,locationLatLng.longitude));
  }
    else if(locationLatLng.latitude > searchLocationLatLng.latitude )
  {
    latLngBounds =LatLngBounds(southwest:LatLng(searchLocationLatLng.latitude,locationLatLng.longitude),northeast: LatLng(locationLatLng.latitude,searchLocationLatLng.longitude));
  }else{
    latLngBounds=LatLngBounds(southwest: locationLatLng,northeast: searchLocationLatLng);
  }
  newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

  Marker userLocMarker= Marker(
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    infoWindow: InfoWindow(title:initialPos.placeName,snippet: "My Location"),
    position: locationLatLng,
    markerId: MarkerId("locationId")
  ); 

  Marker searchLocMarker= Marker(
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    infoWindow: InfoWindow(title:initialPos.placeName,snippet: "Destination"),
    position: searchLocationLatLng,
    markerId: MarkerId("destinationId")
  ); 
  setState(() {
    markerset.add(userLocMarker);
    markerset.add(searchLocMarker);
  });
  Circle userlocCircle= Circle(
    fillColor: Colors. blue.shade900,
    center: locationLatLng,
    radius: 12,
    strokeColor: Colors.redAccent,
    strokeWidth:4,
    circleId: CircleId("locationId")
  );
  Circle searchlocCircle= Circle(
    fillColor: Colors. red.shade900,
    center: searchLocationLatLng,
    radius: 12,
    strokeColor: Colors.blue,
    strokeWidth:4,
    circleId: CircleId("destinationId")
  );
  setState(() {
    circleset.add(userlocCircle);
    circleset.add(searchlocCircle);
  });
  } 
}
