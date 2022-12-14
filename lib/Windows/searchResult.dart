import 'package:contents_buddy/Windows/viewContact.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../db_helper/db_communication.dart';
import '../model/Contact.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();
  late List<Contact>? _searchedList = null;
  final _dbCommunication = dbCommunication();

  getSearchedContactDetails() async {
    _searchedList = <Contact>[];
    var contacts = await _dbCommunication.searchContact(_controller.text, _controller.text, _controller.text);
    contacts.forEach((contact) {
      setState(() {
        var contactModel = Contact();
        contactModel.id = contact['id'];
        contactModel.name = contact['name'];
        contactModel.number = contact['number'];
        contactModel.email = contact['email'];
        contactModel.photo = contact['photo'];
        _searchedList!.add(contactModel);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              autofocus: true,
              controller: _controller,
              onSubmitted: (value) async {
                if (value.isNotEmpty) {
                  var result = await _dbCommunication.searchContact(value, value, value);
                  setState(() {
                    getSearchedContactDetails();
                  });
                  //print(value);
                  // if (result != null) {
                  //   showDialog(
                  //       context: context,
                  //       builder: (parm) {
                  //         return Center(
                  //           child: ListView.builder(
                  //               itemCount: _searchedList.length,
                  //               itemBuilder: (context, index) {
                  //                 return _searchedList.isNotEmpty
                  //                     ? Material(
                  //                   child: ListTile(
                  //                     onTap: () {
                  //                       Navigator.push(
                  //                           context,
                  //                           MaterialPageRoute(
                  //                               builder:
                  //                                   (context) =>
                  //                                   ViewContact(
                  //                                     contact:
                  //                                     _searchedList[
                  //                                     index],
                  //                                   )));
                  //                     },
                  //                     leading: Container(
                  //                       child:
                  //                       _searchedList[index]
                  //                           .photo !=
                  //                           ""
                  //                           ? Container(
                  //                         height: 50,
                  //                         width: 50,
                  //                         decoration:
                  //                         BoxDecoration(
                  //                           shape: BoxShape
                  //                               .circle,
                  //                         ),
                  //                         child:
                  //                         ClipRRect(
                  //                           borderRadius:
                  //                           BorderRadius
                  //                               .circular(
                  //                               100.0),
                  //                           child: Image.file(
                  //                               File(_searchedList[index]
                  //                                   .photo ??
                  //                                   ''),
                  //                               fit: BoxFit
                  //                                   .cover),
                  //                         ),
                  //                       )
                  //                           : Container(
                  //                         height: 50,
                  //                         width: 50,
                  //                         decoration:
                  //                         BoxDecoration(
                  //                           shape: BoxShape
                  //                               .circle,
                  //                         ),
                  //                         child: Icon(
                  //                           Icons.person,
                  //                           size: 40,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     title: Text(
                  //                         _searchedList[index]
                  //                             .name ??
                  //                             ''),
                  //                     subtitle: Text(
                  //                         _searchedList[index]
                  //                             .number ??
                  //                             ''),
                  //                   ),
                  //                 )
                  //                     : Text("No contacts");
                  //               }),
                  //         );
                  //       });
                  // }
                }
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body: _searchedList != null
          ? ListView.builder(
              itemCount: _searchedList!.length,
              itemBuilder: (context, index) {
                return Material(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new ViewContact(
                                    contact: _searchedList![index],
                                  )));
                      //Navigator.pop(context);
                    },
                    leading: Container(
                      child: _searchedList![index].photo != ""
                          ? Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.file(
                                    File(_searchedList![index].photo ?? ''),
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
                    title: Text(_searchedList![index].name ?? ''),
                    subtitle: Text(_searchedList![index].number ?? ''),
                  ),
                );
              })
          : const SizedBox.shrink(),
    );
  }
}
