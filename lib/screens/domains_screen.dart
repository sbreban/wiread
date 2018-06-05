import 'dart:async';
import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wiread/models/domain.dart';
import 'package:wiread/screens/add_domain_form.dart';
import 'package:wiread/util/config.dart';
import 'package:wiread/util/rest_data_source.dart';
import 'package:wiread/util/routes.dart';

class DomainsWidget extends StatefulWidget {
  @override
  State createState() {
    return new DomainsWidgetState();
  }
}

class DomainsWidgetState extends State<DomainsWidget> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final Router router = Config.getInstance().router;

  Widget _buildDomainsList() {
    RestDataSource restDataSource = new RestDataSource();
    final Future<Response> response = restDataSource.get("${Routes.domainsRoute}");

    return new FutureBuilder(
      future: response,
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.data != null) {
          try {
            print("Domains response data: ${snapshot.data.body}");
            final responseJson = json.decode(snapshot.data.body);
            return new ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  if (index < responseJson.length) {
                    print("Domain $index: ${responseJson[index]}");
                    if (responseJson[index] != null) {
                      Domain netDomain =
                          Domain.fromJson(responseJson[index]);
                      return _buildRow(netDomain);
                    }
                  }
                });
          } catch (e) {
            return new Text("Error loading: " + e.toString());
          }
        } else {
          return new CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildRow(Domain value) {
    return new DomainWidget(value);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Domains'), actions: [
        new IconButton(
          icon: new Icon(Icons.add),
          onPressed: () => _showAddDomainForm(),
        ),
      ]),
      body: _buildDomainsList(),
    );
  }

  _showAddDomainForm() {
    router.navigateTo(context, "${Routes.addDomainRoute}");
  }
}

class DomainWidget extends StatefulWidget {
  final Domain domain;

  DomainWidget(this.domain);

  @override
  State createState() {
    return new DomainState(domain);
  }
}

class DomainState extends State<DomainWidget> {
  final Domain domain;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  int _block;

  DomainState._default(this.domain);

  factory DomainState(Domain netDomain) {
    DomainState domain = DomainState._default(netDomain);
    domain._block = netDomain.block;
    return domain;
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(
        domain.name,
        style: _biggerFont,
      ),
      trailing: new Icon(
        Icons.block,
        color: _block == 1 ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (_block == 1) {
            _block = 0;
          } else {
            _block = 1;
          }
          print("Set domain state: $_block");
          RestDataSource restDataSource = new RestDataSource();
          restDataSource.post("${Routes.domainsRoute}/${domain.id}/$_block", "");
        });
      },
      onLongPress: () {
        showDialog(context: context, builder: (BuildContext context) {
          return new SimpleDialog(title: new Text(domain.name),
            children: <Widget>[
              new ListTile(title: new Text("Delete"),
                  onTap: deleteDomain),
              new ListTile(title: new Text("Edit"),
                  onTap: editDomain)
            ],);
        });
      },
    );
  }

  deleteDomain() {
    RestDataSource restDataSource = new RestDataSource();
    final Future<Response> response = restDataSource.post(
        "${Routes.deleteDomainRoute}/${domain.id}", null);
    response.then((Response response) {
      Router router = Config.getInstance().router;
      router.navigateTo(context, "${Routes.domainsRoute}");
      if (response.body != null && response.body.isNotEmpty) {
        print("Response: ${response.body}");
      }
    });
  }

  editDomain() {
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) {
        return new AddDomainForm(domain);
      },
    ));
  }

}
