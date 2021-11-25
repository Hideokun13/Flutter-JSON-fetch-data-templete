import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<Course>>? courseFuture;
  
  @override
  void initState() {
    courseFuture = getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "test fetch course",
      home: Scaffold(
      appBar: AppBar(
        title: Text('Test fetch course data'),
      ),
      body: Container(
        child: Card(
          child: FutureBuilder(
            future: courseFuture,
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              else {
                var content = snapshot.data as List;
                return ListView.builder(
                  itemCount: content.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      title: Text(content[index].courseName),
                      subtitle: Text(content[index].courseInstructor),
                    );
                  },
                );
              }
            },
          ),
        ),
      )
    ),
    );
    
  }
}

Future <List<Course>> getData() async {
  final uri = "http://localhost:3000/course"; //Change json url here
  final response = await http.get(Uri.parse(uri));
  List<Course> courseList = [];
  if(response.statusCode == 200){
    var data = json.decode(response.body);
    data.forEach((d) => courseList.add(Course(courseId: d["courseID"], courseName: d["courseName"], courseInstructor: d["courseInstructor"])));
    print(courseList);
    return courseList;
  }
  else {
    throw Exception("err");
  }
}

class Course {
  final String courseId, courseName, courseInstructor;

  Course({
    required this.courseId,
    required this.courseName,
    required this.courseInstructor,
  });

  Map toJson() => {
    "courseID": courseId,
    "courseName": courseName,
    "courseInstrucctor": courseInstructor,
  };
}
