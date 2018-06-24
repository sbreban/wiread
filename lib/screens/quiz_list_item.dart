import 'package:flutter/material.dart';
import 'package:wiread/models/quiz.dart';

class QuizListItem extends StatelessWidget {
  final Quiz quiz;

  QuizListItem(this.quiz);

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new Row(children: [
          new Expanded(
              child: new ListTile(
                  title: new Text(quiz.name,
                      style: new TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: new Text(quiz.description,
                      style: new TextStyle(fontWeight: FontWeight.w500)),
                  leading: new Icon(
                    Icons.poll,
                    color: Colors.blue[500],
                  ),
                  trailing: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Text(
                          "${quiz.unattempted.length}/${quiz.numquestions}",
                          style: new TextStyle(fontWeight: FontWeight.w500)),
                      new CircleAvatar(
                        backgroundColor: Colors.orange.shade800,
                        child: new Text("${quiz.points}"),
                      )
                    ],
                  ),
                  onTap: () {
                    if (quiz.unattempted.length > 0) {
//                      Navigator.push(
//                          context,
//                          new MaterialPageRoute(
//                            builder: (BuildContext context) =>
//                            new QuizPage(quiz, home),
//                          ));
                    } else {
                      showDialog<Null>(
                          context: context,
                          child: new AlertDialog(
                              title: const Text('No more tries today'),
                              content: const Text(
                                  'You can\'t take this quiz again until tomorrow'),
                              actions: <Widget>[
                                new FlatButton(
                                    child: const Text('GOT IT!'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    })
                              ]));
                    }
                  }))
        ]));
  }
}
