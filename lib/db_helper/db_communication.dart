import 'package:contents_buddy/db_helper/functions.dart';
import 'package:contents_buddy/model/Contact.dart';

class dbCommunication{
  late Functions _functions;
  dbCommunication(){
    _functions = Functions();
  }

  //SaveContact
  saveContact(Contact contact) async{
  return await _functions.insertContacts('contacts', contact.contactMap());
  }

  //Read all contacts
  readContacts() async{
    return await _functions.readAllContacts('contacts');
  }

  //EditContact
  UpdateContact(Contact contact) async {
    return await _functions.updateContacts('contacts', contact.contactMap());
  }

  deleteContact(contactId) async{
    return await _functions.deleteContacts('contacts', contactId);
  }

  searchContact(contactName, contactNumber, extraNumber) async{
    print(contactName);
    return await _functions.searchContacts('contacts', contactName, contactNumber, extraNumber);
  }
}

