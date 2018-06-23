import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wiread/models/domain.dart';
import 'package:wiread/util/rest_data_source.dart';
import 'package:wiread/util/routes.dart';

class AddDomainForm extends StatefulWidget {
  final Domain domain;

  AddDomainForm(this.domain);

  @override
  AddDomainFormState createState() => new AddDomainFormState(domain);
}

class AddDomainFormState extends State<AddDomainForm> {
  final Domain domain;

  AddDomainFormState(this.domain);

  TextEditingController nameController = new TextEditingController();
  TextEditingController wildcardController = new TextEditingController();

  void submit(context) {
    if (nameController.text.isEmpty) {
      Scaffold.of(context).showSnackBar(
        new SnackBar(
          backgroundColor: Colors.redAccent,
          content: new Text('Domain name cannot be empty!'),
        ),
      );
    } else {
      if (domain != null) {
        var editedDomain = new Domain(id: domain.id,
            name: nameController.text,
            domain: wildcardController.text,
            block: domain.block);

        var domainJson = json.encode(editedDomain.toMap());
        print("Edited domain JSON: $domainJson");

        RestDataSource restDataSource = new RestDataSource();
        final Future<Response> response = restDataSource.post(
            "${Routes.editDomainRoute}/${editedDomain.id}", domainJson);
        response.then((Response response) {
          if (response.body != null && response.body.isNotEmpty) {
            print("Response: ${response.body}");
          }
        });

        Navigator.of(context).pop();
      } else {
        var newDomain = new Domain(id: 0,
            name: nameController.text,
            domain: wildcardController.text,
            block: 1);

        var domainJson = json.encode(newDomain.toMap());
        print("New domain JSON: $domainJson");

        RestDataSource restDataSource = new RestDataSource();
        final Future<Response> response = restDataSource.post(
            "${Routes.addDomainRoute}", domainJson);
        response.then((Response response) {
          if (response.body != null && response.body.isNotEmpty) {
            print("Response: ${response.body}");
          }
        });

        Navigator.of(context).pop(newDomain);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (domain != null) {
      nameController.text = domain.name;
      wildcardController.text = domain.domain;
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add a new domain'),
      ),
      body: new Container(
        color: Colors.black54,
        child: new Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
          child: new Column(
            children: [
              new Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: new TextFormField(
                    controller: nameController,
                    decoration: new InputDecoration(
                      labelText: "Domain name",
                    )),
              ),
              new Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: new TextFormField(
                  controller: wildcardController,
                  decoration: new InputDecoration(
                    labelText: "Domain wildcard",
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Builder(
                  builder: (context) {
                    return new RaisedButton(
                      color: Colors.indigoAccent,
                      child: new Text('Submit'),
                      onPressed: () => submit(context),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
