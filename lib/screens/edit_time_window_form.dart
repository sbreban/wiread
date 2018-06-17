import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wiread/models/device.dart';
import 'package:wiread/models/device_block.dart';
import 'package:wiread/util/rest_data_source.dart';
import 'package:wiread/util/routes.dart';

class EditTimeWindowForm extends StatefulWidget {
  final int userId;
  final Device device;
  final DeviceBlock deviceBlock;

  EditTimeWindowForm(this.userId, this.device, this.deviceBlock);

  @override
  EditTimeWindowFormState createState() =>
      new EditTimeWindowFormState(userId, device, deviceBlock);
}

class EditTimeWindowFormState extends State<EditTimeWindowForm> {
  final int userId;
  final Device device;
  final DeviceBlock deviceBlock;

  EditTimeWindowFormState._default(this.userId, this.device, this.deviceBlock);

  factory EditTimeWindowFormState(int userId, Device device, DeviceBlock deviceBlock) {
    EditTimeWindowFormState editTimeWindowFormState = EditTimeWindowFormState._default(userId, device, deviceBlock);

    if (deviceBlock != null) {
      if (deviceBlock.fromTime != null) {
        print("From time : ${deviceBlock.fromTime}");
        var fromSplit = deviceBlock.fromTime.split(":");
        editTimeWindowFormState._fromTime = TimeOfDay(
            hour: int.parse(fromSplit[0]), minute: int.parse(fromSplit[1]));
      }

      if (deviceBlock.toTime != null) {
        print("To time : ${deviceBlock.toTime}");
        var toSplit = deviceBlock.toTime.split(":");
        editTimeWindowFormState._toTime =
            TimeOfDay(
                hour: int.parse(toSplit[0]), minute: int.parse(toSplit[1]));
      }
    }

    return editTimeWindowFormState;
  }

  TimeOfDay _fromTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _toTime = const TimeOfDay(hour: 20, minute: 0);

  void submit(context) {
    var editedDeviceBlock = new DeviceBlock(deviceId: deviceBlock.deviceId,
        fromTime: "${_fromTime.hour}:${_fromTime.minute}",
        toTime: "${_toTime.hour}:${_toTime.minute}",
        block: deviceBlock.block);

    var deviceBlockJson = json.encode(editedDeviceBlock.toMap());
    print("Edited device block JSON: $deviceBlockJson");

    RestDataSource restDataSource = new RestDataSource();
    final Future<Response> response = restDataSource.post(
        "${Routes.setDeviceBlockRoute}", deviceBlockJson);
    response.then((Response response) {
      if (response.body != null && response.body.isNotEmpty) {
        print("Set device block response: ${response.body}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Edit daily time window'),
        backgroundColor: Colors.black87,
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
                child: new _DateTimePicker(
                  labelText: 'From',
                  selectedTime: _fromTime,
                  selectTime: (TimeOfDay time) {
                    setState(() {
                      _fromTime = time;
                    });
                  },
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: new _DateTimePicker(
                  labelText: 'To',
                  selectedTime: _toTime,
                  selectTime: (TimeOfDay time) {
                    setState(() {
                      _toTime = time;
                    });
                  },
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

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker(
      {Key key,
      this.labelText,
      this.selectedTime,
      this.selectTime})
      : super(key: key);

  final String labelText;
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> selectTime;

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        const SizedBox(width: 12.0),
        new Expanded(
          flex: 3,
          child: new _InputDropdown(
            labelText: labelText,
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}
