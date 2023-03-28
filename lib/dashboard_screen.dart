import 'package:firebase_proj_1/database_manager/database_manager.dart';
import 'package:firebase_proj_1/main.dart';
import 'package:firebase_proj_1/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthenticationService _auth = AuthenticationService();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _productController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  List userProfileList = [];
  String userID = "";

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
    await DatabaseManager().updateUserList(name, product, amount, userID);
    fetchDatabaseList();
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
                      child: Image.asset('')),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.add),
                          label: Text('Add Img'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.delete),
                          label: Text('Delete Img'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        '🅻🅾🅲🅰🆃🅸🅾🅽: ${userProfileList[index]['product']}',
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                          '🅳🅴🆂🅲🆁🅸🅿🆃🅸🅾🅽: ${userProfileList[index]["amount"]}'),
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
                    color: Colors.grey),
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
                title: Text('Contact Info: ${userProfileList[index]['name']}'),
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
          title: const Text('Edit User Details'),
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
              ],
            )
          ],
        );
      },
    );
  }

  submitAction(BuildContext context) {
    updateData(_nameController.text, _productController.text,
        _amountController.text, userID);
    _nameController.clear();
    _amountController.clear();
    _productController.clear();
  }
}
