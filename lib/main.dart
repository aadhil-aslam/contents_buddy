import 'package:contents_buddy/Windows/AddContact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'Windows/editContact.dart';
import 'Windows/searchResult.dart';
import 'Windows/viewContact.dart';
import 'db_helper/db_communication.dart';
import 'model/Contact.dart';

import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  bool typing = false;

  @override
  void initState() {
    getAllContactDetails();
    super.initState();
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
                      Navigator.pop(context);
                      setState(() {
                        getAllContactDetails();
                      });
                      _showSuccessSnackbar('Contact deleted successfully');
                    }
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(fontSize: 17),
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0.0,
        title: Text(
          "Contents Buddy",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon: Icon(
                  // typing ?
                  // Icons.home :
                  Icons.search),
              onPressed: () {
                // Navigator.of(context, rootNavigator: true).push(
                //   new CupertinoPageRoute<bool>(
                //     fullscreenDialog: false,
                //     builder: (BuildContext context) => new SearchBar(),
                //   ),
                // );
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 150),
                        isIos: true,
                        reverseDuration: Duration(milliseconds: 150),
                        child: SearchBar()));

                // showSearch(context: context, delegate: ContactSearch());
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => SearchBar()));
              },
            ),
          ),
        ],
      ),
      // appBar: AppBar(
      //   title: const Text("Contents Buddy"),
      // ),
      body: _contactList!.isNotEmpty
          ? Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                ListView.separated(
                  itemCount: _contactList!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewContact(
                                        contact: _contactList![index],
                                      )));
                        },
                        leading: Container(
                          child: _contactList![index].photo != ""
                              ? Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Image.file(
                                        File(_contactList![index].photo ?? ''),
                                        fit: BoxFit.cover),
                                  ),
                                )
                              : Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                  ),
                                ),
                        ),
                        title: Text(_contactList![index].name != ""
                            ? _contactList![index].name ?? ''
                            : _contactList![index].number ?? ''),
                        subtitle: Text(_contactList![index].name != ""
                            ? _contactList![index].number ?? ''
                            : ""),
                        trailing: PopupMenuButton<int>(
                          itemBuilder: (context) => [
                            // PopupMenuItem 1
                            PopupMenuItem(
                              value: 1,
                              // row with 2 children
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
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
                                  Icon(Icons.delete),
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
                                            contact: _contactList![index],
                                          ))).then((data) => {
                                    if (data != null)
                                      {
                                        getAllContactDetails(),
                                        _showSuccessSnackbar(
                                            'Contact details updated successfully')
                                      }
                                  });
                              ;
                              // if value 2 show dialog
                            } else if (value == 2) {
                              _deleteFromDialog(
                                  context, _contactList![index].id);
                            }
                          },
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                ),
              ],
            )
          : Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.contact_page_outlined, size: 150, color:Colors.blueGrey[200],),
                SizedBox(height: 50,),
                Text("No contacts\n",
                    style: TextStyle(color: Colors.black, fontSize: 15)),
                RichText(
                  //textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      // TextSpan(
                      //     text: "No contacts\n",
                      //     style: TextStyle(color: Colors.black, fontSize: 15)),
                      TextSpan(
                          text: "Click ",
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(Icons.add_circle_outline, size: 25),
                      ),
                      TextSpan(
                          text: " to add",
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                    ],
                  ),
                ),
              ],
            )
              //   Text(
              //   "No contacts\nPress  +  to add",
              //   style: TextStyle(fontSize: 16),
              //   textAlign: TextAlign.center,
              // )
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddContact()))
              .then((data) => {
                    if (data != null)
                      {
                        getAllContactDetails(),
                        _showSuccessSnackbar('New contact created successfully')
                      }
                  });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
