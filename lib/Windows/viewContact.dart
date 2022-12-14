import 'dart:io';

import 'package:contents_buddy/main.dart';
import 'package:flutter/material.dart';
import '../db_helper/db_communication.dart';
import '../model/Contact.dart';
import 'editContact.dart';

class ViewContact extends StatefulWidget {
  final Contact contact;
  const ViewContact({Key? key, required this.contact}) : super(key: key);

  @override
  State<ViewContact> createState() => _ViewContactState();
}

class _ViewContactState extends State<ViewContact> {
  late List<Contact>? _contactList;
  final _dbCommunication = dbCommunication();

  getAllContactDetails() async {
    _contactList = <Contact>[];
    var contacts = await _dbCommunication.readContacts();
    contacts.forEach((contact) {
      setState(() {
        var contactModel = Contact();
        contactModel.id = contact['id'];
        contactModel.name = contact['name'];
        contactModel.number = contact['number'];
        contactModel.email = contact['email'];
        contactModel.photo = contact['photo'];
        contactModel.extranumber = contact['extranumber'];
        _contactList!.add(contactModel);
      });
    });
  }

  _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _deleteFromDialog(BuildContext context, contactId) {
    return showDialog(
        context: context,
        builder: (parm) {
          return AlertDialog(
            title: const Text(
              'Delete this contact?',
              style: TextStyle(color: Colors.blueGrey, fontSize: 18),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueGrey,
                    //backgroundColor: Colors.blueGrey,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel', style: TextStyle(fontSize: 17))),
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    //backgroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    var result =
                        await _dbCommunication.deleteContact(contactId);
                    if (result != null) {
                      //Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage())).then((_) {
                        getAllContactDetails();
                      });
                      _showSuccessSnackbar('Contact deleted successfully');
                    }
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(fontSize: 17),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: const Text("Contact Details"),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              // PopupMenuItem 1
              PopupMenuItem(
                value: 1,
                // row with 2 children
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Edit")
                  ],
                ),
              ),
              // PopupMenuItem 2
              PopupMenuItem(
                value: 2,
                // row with two children
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.grey),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Delete")
                  ],
                ),
              ),
            ],
            offset: Offset(0, 50),
            color: Colors.white,
            elevation: 2,
            // on selected we show the dialog box
            onSelected: (value) {
              // if value 1 show dialog
              if (value == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditContact(
                              contact: widget.contact,
                            ))).then((data) => {
                      if (data != null)
                        {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage()))
                              .then((_) {
                            // This method gets callback after your SecondScreen is popped from the stack or finished.
                            getAllContactDetails();
                          }),
                          _showSuccessSnackbar(
                              'Contact details updated successfully')
                        }
                    });
                ;
                // if value 2 show dialog
              } else if (value == 2) {
                _deleteFromDialog(context, widget.contact.id);
              }
            },
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30.0,
              ),
              Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  //border: Border.all(width: 1, color: Colors.blueGrey)
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: widget.contact.photo != ""
                      ? Image.file(File(widget.contact.photo ?? ''),
                          fit: BoxFit.cover)
                      : Center(
                          child: CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            radius: 80,
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                widget.contact.name != ""
                    ? widget.contact.name ?? ''
                    : widget.contact.number ?? "",
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 30.0,
              ),
              ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      Icons.phone,
                      color: Colors.blueGrey,
                      size: 30,
                    ),
                  ],
                ),
                title: const Text('Number'),
                subtitle: Text(widget.contact.number ?? ''),
              ),
              const Divider(
                height: 1.0,
                indent: 1.0,
              ),
              widget.contact.extranumber != ""
                  ? ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.phone_android,
                            color: Colors.blueGrey,
                            size: 30,
                          ),
                        ],
                      ),
                      title: Text('Number'),
                      subtitle: Text(widget.contact.extranumber ?? ''),
                    )
                  : SizedBox.shrink(),
              widget.contact.extranumber != ""
                  ? const Divider(
                      height: 1.0,
                      indent: 1.0,
                    )
                  : SizedBox.shrink(),
              widget.contact.email != ""
                  ? ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.mail,
                            color: Colors.blueGrey,
                            size: 30,
                          ),
                        ],
                      ),
                      title: Text('Email'),
                      subtitle: Text(widget.contact.email ?? ''),
                    )
                  : SizedBox.shrink(),
              widget.contact.email != ""
                  ? const Divider(
                      height: 1.0,
                      indent: 1.0,
                    )
                  : SizedBox.shrink(),
              // ListTile(
              //   leading: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: const <Widget>[
              //       Icon(Icons.link, color: Colors.blueGrey,size: 30,),
              //     ],
              //   ),
              //   title: widget.contact.photo != null
              //       ? Text(widget.contact.photo??'') : Text("null"),
              // )
              // ,const Divider(
              //   height: 1.0,
              //   indent: 1.0,
              // ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          )),
    );
  }
}
