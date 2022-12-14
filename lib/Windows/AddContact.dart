import 'package:contents_buddy/model/Contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

import 'package:image_picker/image_picker.dart';

import '../db_helper/db_communication.dart';

class AddContact extends StatefulWidget {
  late final Function imagesaveat;

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  File? _image;

  String? ImagePath;

  int numberOfTextFields = 0;

  bool extraNumber = false;

  _TakePhoto() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });

    final apDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(image!.path);
    final saveImagePath = await _image!.copy('${apDir.path}/$fileName');

    setState(() {
      ImagePath = saveImagePath.path;
    });
  }

  _ChoosePhoto() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });

    final apDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(image!.path);
    final saveImagePath = await _image!.copy('${apDir.path}/$fileName');

    setState(() {
      ImagePath = saveImagePath.path;

      print(ImagePath);
    });
  }

  bool _displayNewTextField = false;

  var _contactNameController = TextEditingController();
  var _contactNumberController = TextEditingController();
  var _extraNumberController = TextEditingController();
  var _contactEmailController = TextEditingController();
  //
  // bool _validateName = false;
  bool _validateNumber = false;
  var _contactCommunication = dbCommunication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Contact"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30.0,
              ),
              Stack(
                children: [
                  Center(
                    child: Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //border: Border.all(width: 2, color: Colors.blueGrey)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: _image != null
                            ? Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: CircleAvatar(
                                  backgroundColor: Colors.blueGrey,
                                  radius: 80,
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.black12,
                      radius: 80,
                      child: IconButton(
                          icon: const Icon(
                            Icons.add_a_photo,
                            size: 30,
                          ),
                          color: Colors.white,
                          onPressed: () {
                            Widget optionOne = Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SimpleDialogOption(
                                child: const Text('Take new photo'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _TakePhoto();
                                },
                              ),
                            );
                            Widget optionTwo = Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: SimpleDialogOption(
                                child: const Text('Choose new photo'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _ChoosePhoto();
                                },
                              ),
                            );
                            SimpleDialog dialog = SimpleDialog(
                              title: const Text('Change photo'),
                              children: <Widget>[
                                optionOne,
                                optionTwo,
                              ],
                            );
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return dialog;
                              },
                            );
                          }),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50.0,
              ),
              TextField(
                  controller: _contactNameController,
                  decoration: InputDecoration(
                    //filled: true,
                    fillColor: const Color(0xFFFFFFFF),
                    isDense: true,
                    border: OutlineInputBorder(),
                    hintText: 'Enter Name',
                    labelText: 'Name',
                    prefixIcon: const Icon(Icons.person),
                  )),
              const SizedBox(
                height: 18.0,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                        controller: _contactNumberController,
                        keyboardType: TextInputType.phone,
                        //textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          //filled: true,
                          fillColor: const Color(0xFFFFFFFF),
                          isDense: true,
                          border: const OutlineInputBorder(),
                          hintText: 'Enter Number',
                          labelText: 'Number',
                          prefixIcon: const Icon(Icons.phone),
                          errorText:
                              _validateNumber ? 'Number Can\'t Be Empty' : null,
                        )),
                  ),
                  extraNumber
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: IconButton(
                              icon: const Icon(
                                Icons.add_circle_outlined,
                                size: 30,
                              ),
                              color: Colors.blueGrey,
                              onPressed: () {
                                setState(() {
                                  _displayNewTextField = true;
                                  //numberOfTextFields++;
                                  extraNumber = true;
                                });
                              }),
                        )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Visibility(
                  visible: _displayNewTextField,
                  child: TextFormField(
                    controller: _extraNumberController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      //filled: true,
                      fillColor: Color(0xFFFFFFFF),
                      isDense: true,
                      border: OutlineInputBorder(),
                      labelText: "Number",
                      hintText: 'Enter Number',
                      prefixIcon: const Icon(Icons.phone_android),
                    ),
                  ),
                ),
              ),
              TextField(
                  controller: _contactEmailController,
                  decoration: InputDecoration(
                    //filled: true,
                    fillColor: const Color(0xFFFFFFFF),
                    isDense: true,
                    border: OutlineInputBorder(),
                    hintText: 'Enter Email',
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                  )),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueGrey,
                            textStyle: const TextStyle(fontSize: 15)),
                        onPressed: () async {
                          setState(() {
                            _contactNumberController.text.isEmpty
                                ? _validateNumber = true
                                : _validateNumber = false;
                          });
                          if (_validateNumber == false) {
                            //InsertContacts
                            var _contact = Contact();
                            _contact.name = _contactNameController.text;
                            _contact.number = _contactNumberController.text;
                            _contact.extranumber = _extraNumberController.text;
                            _contact.email = _contactEmailController.text;
                            _contact.photo = ImagePath ?? "";
                            var result = await _contactCommunication
                                .saveContact(_contact);
                            Navigator.pop(context, result);
                          }
                        },
                        child: const Text('Save Details')),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(fontSize: 15)),
                        onPressed: () {
                          _contactNameController.text = '';
                          _contactNumberController.text = '';
                          _contactEmailController.text = '';
                          _extraNumberController.text = '';
                        },
                        child: const Text('Clear Details')),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
