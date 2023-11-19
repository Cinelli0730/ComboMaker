import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'common/constants.dart';

class FormPicker extends StatefulWidget {
  const FormPicker({super.key});

  @override
  State<FormPicker> createState() => _FormPicker();
}

class _FormPicker extends State<FormPicker> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
              leading: const Icon(Icons.arrow_back),
              title: const Text('Create Your Combo'),
              actions: <Widget>[
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
              ]),
          body: const SafeArea(
              child: FittedBox(
                  child: Row(
            children: [
              Picker(pickList: listCharacter),
              Picker(pickList: listTypeCM),
              Picker(pickList: listMove),
            ],
          )))),
    );
  }
}
/*
class DroopdownButtonItems {
  late int dropdownValue;
  Widget build(BuildContext context) {
    return DropdownButton<int>(
        value: dropdownValue,
        items: const [
          DropdownMenuItem(
            value: 1,
            child: Text('test1'),
          ),
        ],
        on: (int? value) {
          DropdownButton.setState(() {
            dropdownValue = value!;
          });
        });
  }
}
*/

class Picker extends StatefulWidget {
  const Picker({Key? key, required this.pickList}) : super(key: key);
  final List<String> pickList;
  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  late String dropdownValue; // = Widget.pickList;
  //final List<String> pickList;
  //_PickMoveState({required this.pickList});
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: widget.pickList.first,
      onSelected: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries:
          widget.pickList.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}

void main(List<String> args) {
  runApp(const FormPicker());
}
