import 'package:dailynotes/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main(){

  runApp(MaterialApp(

  home: HomePage(),
  debugShowCheckedModeBanner: false,

  theme: ThemeData(
    primarySwatch: Colors.deepPurple,
  )
  )
  );
}


