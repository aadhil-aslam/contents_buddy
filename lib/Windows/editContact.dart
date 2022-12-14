import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

import '../db_helper/db_communication.dart';
import '../model/Contact.dart';

class EditContact extends StatefulWidget {
  final Contact contact;
  const EditContact({Key? key, required this.contact}) : super(key: key);

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  File? _image;
  String? ImagePath;

  bool imageEdited = false;

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
      imageEdited = true;
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
      imageEdited = true;
    });
  }

  var _contactNameController = TextEditingController();
  var _contactNumberController = TextEditingController();
  var _contactEmailController = TextEditingController();
  var _extraNumberController = TextEditingController();

  bool _validateNumber = false;
  var _contactCommunication = dbCommunication();

  @override
  void initState() {
    setState(() {
      _contactNameController.text = widget.contact.name ?? '';
      _contactNumberController.text = widget.contact.number ?? '';
      _contactEmailController.text = widget.contact.email ?? '';
      _extraNumberController.text = widget.contact.extranumber ?? '';
      ImagePath = widget.contact.photo ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Contact Details"),
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
                        child: widget.contact.photo != ""
                            ? Image.file(
                                imageEdited
                                    ? _image!
                                    : File(widget.contact.photo ?? ''),
                                fit: BoxFit.cover)
                            : imageEdited
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: _image != null
                                        ? Image.file(_image!, fit: BoxFit.cover)
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
                                          ))
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
                                child: const Text('Remove photo'),
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                    widget.contact.photo = "";
                                    ImagePath = widget.contact.photo;
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            );

                            Widget optionTwo = Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SimpleDialogOption(
                                child: const Text('Take new photo'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _TakePhoto();
                                },
                              ),
                            );
                            Widget optionThree = Padding(
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
                                optionThree,
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
                height: 40.0,
              ),
              TextField(
                  controller: _contactNameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Name',
                    labelText: 'Name',
                  )),
              const SizedBox(
                height: 18.0,
              ),
              TextField(
                  controller: _contactNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Number',
                    labelText: 'Number',
                    errorText:
                        _validateNumber ? 'Number Can\'t Be Empty' : null,
                  )),
              const SizedBox(
                height: 18.0,
              ),
              widget.contact.extranumber != ""
                  ? TextField(
                      controller: _extraNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Enter Number',
                        labelText: 'Number',
                        errorText:
                            _validateNumber ? 'Number Can\'t Be Empty' : null,
                      ))
                  : SizedBox.shrink(),
              widget.contact.extranumber != ""
                  ? const SizedBox(
                      height: 18.0,
                    )
                  : SizedBox.shrink(),
              TextField(
                  controller: _contactEmailController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter Email',
                    labelText: 'Email',
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
                          if (_validateNumber == false
                              ) {
                            //InsertContacts
                            var _contact = Contact();
                            _contact.id = widget.contact.id;
                            _contact.name = _contactNameController.text;
                            _contact.number = _contactNumberController.text;
                            _contact.extranumber = _extraNumberController.text;
                            _contact.email = _contactEmailController.text;
                            _contact.photo = ImagePath ?? "";
                            var result =
                                await _contactCommunication.UpdateContact(
                                    _contact);
                            Navigator.pop(context, result);
                          }
                        },
                        child: const Text('Update Details')),
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
                          child: const Text('Clear Details')))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
