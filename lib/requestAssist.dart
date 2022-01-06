import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class RequestAssist{
  static Future<dynamic> getRequest(String url) async{
http.Response response = await http.get(Uri.parse(url));  
try{
if(response.statusCode ==200){
  String jsonData = response.body;
  var decodeData =jsonDecode(jsonData);
  return decodeData;
}else{
  return "Failed";
}
}catch(e){
  return  "Failed";

}
}
}