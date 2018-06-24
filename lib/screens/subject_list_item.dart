import 'package:flutter/material.dart';
import 'package:wiread/models/subject.dart';
import 'package:wiread/util/config.dart';
import 'package:wiread/util/routes.dart';

class SubjectListItem extends StatelessWidget {
  final Subject subject;

  SubjectListItem(this.subject);

  @override
  Widget build(BuildContext context) {
    print(subject.toString());
    return new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new Row(children: [
          new Expanded(
              child: new ListTile(
                  title: new Text(subject.name,
                      style: new TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: new Text(subject.description,
                      style: new TextStyle(fontWeight: FontWeight.w500)),
                  leading: new Icon(
                    Icons.assignment,
                    color: Colors.blue[500],
                  ),
                  trailing: new Text("${subject.numquizzes}",
                      style: new TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () {
                    Config.getInstance().router.navigateTo(context, "${Routes.quizzesRoute}?subjectName=${subject.name}");
                  }))
        ]));
  }
}