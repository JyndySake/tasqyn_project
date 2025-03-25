import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:project_app/feature/main/admin_panel/admin_panel_dashboard/admin_panel_dashboard.dart';
import 'package:project_app/feature/main/admin_panel/admin_panel_messages/admin_panel_message.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AddNewsPage(),
  ));
}

class AddNewsPage extends StatefulWidget {
  const AddNewsPage({super.key});

  @override
  _AddNewsPageState createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _deleteImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1D26),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Color(0xFF0B1D26),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Color(0xFF0B1D26)),
              title: Text('Profile', style: TextStyle(color: Color(0xFF0B1D26))),
              onTap: () {
                // Handle profile tap
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Color(0xFF0B1D26)),
              title: Text('Log Out', style: TextStyle(color: Color(0xFF0B1D26))),
              onTap: () {
                // Handle log out tap
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: MediaQuery.of(context).size.height * 0.3,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color(0xFF0B1D26),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          iconTheme: IconThemeData(color: Colors.white),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.15,
                        left: 20,
                        child: const Text(
                          "Add News",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  _buildSection(
                    title: "Main information",
                    child: Column(
                      children: [
                        _buildTextFieldWithButton("News title"),
                        const SizedBox(height: 10),
                        _buildTextFieldWithButton("Short description"),
                        const SizedBox(height: 10),
                        _buildLargeTextField("Type your text here"),
                      ],
                    ),
                  ),

                  _buildSection(
                    title: "Images",
                    child: Column(
                      children: [
                        _selectedImage != null ? _buildImagePreview() : _buildPlaceholderImage(),
                        const SizedBox(height: 10),
                        _buildImageUploadRow(),
                        const SizedBox(height: 15),
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B1D26),
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithButton(String hintText) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0B1D26),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Save"),
        ),
      ],
    );
  }

  Widget _buildLargeTextField(String hintText) {
    return TextField(
      maxLines: 3,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            _selectedImage!,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: _deleteImage,
            child: const CircleAvatar(
              backgroundColor: Colors.red,
              radius: 16,
              child: Icon(Icons.delete, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.image, color: Colors.grey, size: 50),
      ),
    );
  }

  Widget _buildImageUploadRow() {
    return Row(
      children: [
        if (_selectedImage != null) _buildThumbnailImage(),
        const SizedBox(width: 10),
        _buildAddImageButton(),
      ],
    );
  }

  Widget _buildThumbnailImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        _selectedImage!,
        height: 50,
        width: 50,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Center(
          child: Icon(Icons.add, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text("Save"),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
   final int currentIndex;

  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
       currentIndex: currentIndex,
      backgroundColor: const Color(0xFF0B1D26),
      selectedItemColor: const Color(0xFFFBD784),
      unselectedItemColor: Colors.white70,
      onTap: (index) {
        if (index == 0){
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const AdminDashboardApp()));
        }
        if (index == 2){
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const AdminMessageApp()));
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: "Add news"),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
      ],
    );
  }
}
