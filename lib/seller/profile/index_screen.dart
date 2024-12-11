import 'package:flutter/material.dart';
import 'package:flutter_bootcamp/api/user_api.dart';
import 'package:flutter_bootcamp/model/user_model.dart';

class IndexProfileScreen extends StatefulWidget {
  @override
  _IndexCategoryState createState() => _IndexCategoryState();
}

class _IndexCategoryState extends State<IndexProfileScreen> {
  late UserApi userApi;
  late Future<User?> futureUser;

  @override
  void initState() {
    super.initState();
    userApi = new UserApi();
    futureUser = UserApi().getUser();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<User?>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('User not found.'));
          } else {
            // Data tersedia
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('images/profile.jpg'), // Ganti dengan path gambar profil Anda
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: user.name),
                    decoration: InputDecoration(
                      labelText: "Nama",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: user.email),
                    decoration: InputDecoration(
                      labelText: "E-Mail",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: user.address ?? ""),
                    decoration: InputDecoration(
                      labelText: "Alamat",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}