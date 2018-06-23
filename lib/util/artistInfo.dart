import 'dart:async';
import 'dart:convert';
import 'package:xml/xml.dart' as xml;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final String baseUrl = "http://ws.audioscrobbler.com/2.0/";
final String apikey = "57ee3318536b23ee81d6b27e36997";


  
List fetch(String artist){
  
    final url = baseUrl +
      "?method=artist.getinfo&artist=" +
      artist.replaceAll(" ", "+") +
      "&api_key=" +
      apikey;

      Future<http.Response> fetchPost() {
  return http.get(url);
}
    Future<http.Response> str = fetchPost();
    final responsexml = xml.parse(url);
    print(responsexml);
    var images =  responsexml.findAllElements("image");
    return images.map((node) => node.text).toList();
  }
  

