import 'dart:io';

import 'package:firebase_proj_1/database_manager/database_manager.dart';
import 'package:firebase_proj_1/main.dart';
import 'package:firebase_proj_1/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthenticationService _auth = AuthenticationService();
  final _update = DatabaseManager();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _productController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  List userProfileList = [];
  String userID = "";
  String imageUrl = '';

  @override
  void initState() {
    fetchUserInfo();
    fetchDatabaseList();
    super.initState();
  }

  fetchDatabaseList() async {
    dynamic resultant = await DatabaseManager().getUsersList();
    if (resultant != null) {
      setState(() {
        userProfileList = resultant;
      });
    }
  }

  fetchUserInfo() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    userID = getUser!.uid;
  }

  updateData(String name, String product, String amount, String userID) async {
    await DatabaseManager()
        .updateUserList(name, product, amount, userID, imageUrl);
    fetchDatabaseList();
  }

  Future addImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    if (file == null) {
      return;
    }

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
    try {
      await referenceImageToUpload.putFile(File(file.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {}
  }

  alertbox(BuildContext context, index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Text(
              userProfileList[index]['name'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                          '${userProfileList[index]['imageurl']}')),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.exit_to_app),
                            label: Text('Press to exit to dialog box'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('🅻🅾🅲🅰🆃🅸🅾🅽'),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        userProfileList[index]['product'],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('🅳🅴🆂🅲🆁🅸🅿🆃🅸🅾🅽'),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('${userProfileList[index]["amount"]}'),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
            color: Colors.deepPurple,
            child: Padding(
              padding: const EdgeInsets.only(left: 105),
              child: Text(
                '🆆🅴🅻🅲🅾🅼🅴',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
            )),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            onPressed: () {
              openDialogBox(context);
            },
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
          ),
          ElevatedButton(
            onPressed: () async {
              await _auth.signOut().then((result) => Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(
                      builder: ((context) => const LoginScreen()))));
            },
            child: Icon(Icons.exit_to_app),
            style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
          )
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: userProfileList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  alertbox(context, index);
                },
                title: Text(
                    '🅲🅾🅽🆃🅰🅲🆃 🅸🅽🅵🅾 ${index + 1}:  ${userProfileList[index]['name']}'),
                //subtitle: Text('Address: ${userProfileList[index]['product']}'),
                leading: CircleAvatar(
                  child: Image(
                    image: AssetImage('assets/images/img2.png'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  openDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: const Text(
            '🅴🅳🅸🆃 🆄🆂🅴🆁 🅳🅴🆃🅰🅸🅻🆂',
            style: TextStyle(fontSize: 17),
          )),
          content: Container(
            height: 200,
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Contact Info'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _productController,
                  decoration: const InputDecoration(hintText: 'Location'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(hintText: 'Description'),
                )
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                  onPressed: () {
                    submitAction(context);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Submit'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    addImage();
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('Add Img'),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  submitAction(BuildContext context) {
    setState(() {
      _update.updateUrl(userID, imageUrl);
    });
    updateData(_nameController.text, _productController.text,
        _amountController.text, userID);
    _nameController.clear();
    _amountController.clear();
    _productController.clear();
  }
}
