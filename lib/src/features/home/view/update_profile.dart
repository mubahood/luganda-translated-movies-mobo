import 'dart:convert';
import 'package:flutx/flutx.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

import '../../../../core/styles.dart';
import '../../../../utils/CustomTheme.dart';
import '../controller/update_user_profle_controller.dart';
// Import the UpdateProfileController

class UpdateProfileScreen extends StatelessWidget {
  final UpdateProfileController _controller = Get.put(UpdateProfileController()); // Initialize the UpdateProfileController

   UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: FxText.titleLarge(
          'My Profile',
          color: Colors.white,
        ),
        backgroundColor: CustomTheme.primary,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: CustomTheme.primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ProfilePicturePicker(),
              const SizedBox(height: 24),
              ProfileField(
                icon: Icons.person,
                label: 'Name',
                currentValue: 'John Doe', // Replace with user's current name
                onEditTapped: () {
                  _showEditDialog(context, 'Name', _controller.nameController, (newValue) {
                    _controller.updateName(newValue);
                  });
                },
              ),
              ProfileField(
                icon: Icons.phone,
                label: 'Phone Number',
                currentValue: '+1 123 456 7890', // Replace with user's current phone number
                onEditTapped: () {
                  _showEditDialog(context, 'Phone Number', _controller.phoneController, (newValue) {
                    _controller.updatePhone(newValue);
                  });
                },
              ),
              ProfileField(
                icon: Icons.email,
                label: 'Email',
                currentValue: 'john.doe@example.com', // Replace with user's current email
                onEditTapped: () {
                  _showEditDialog(context, 'Email', _controller.emailController, (newValue) {
                    _controller.updateEmail(newValue);
                  });
                },
              ),
              ProfileField(
                icon: Icons.lock,
                label: 'Password',
                currentValue: 'romina',
                onEditTapped: () {
                  _showEditDialog(context, 'Password', _controller.passwordController, (newValue) {
                    _controller.updatePassword(newValue);
                  });
                },
                isPassword: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryColor,
                  surfaceTintColor: AppStyles.primaryColor,
                ),
                onPressed: () {
                  _controller.updateUserProfile(); // Handle the form submission and update the profile
                },
                child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(
      BuildContext context,
      String label,
      TextEditingController controller,
      Function(String) onSave,
      ) {
    String newValue = controller.text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $label'),
          content: TextFormField(
            controller: controller,
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog using Get
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(newValue); // Call the callback with the updated value
                Get.back(); // Close the dialog using Get
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class ProfileField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String currentValue;
  final Function() onEditTapped;
  final bool isPassword;

  const ProfileField({super.key, 
    required this.icon,
    required this.label,
    required this.currentValue,
    required this.onEditTapped,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            currentValue,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        IconButton(
          onPressed: onEditTapped,
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }
}

class ProfilePicturePicker extends StatefulWidget {
  const ProfilePicturePicker({super.key});

  @override
  _ProfilePicturePickerState createState() => _ProfilePicturePickerState();
}

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showImagePicker(context);
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipOval(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: _imageFile != null
                  ? Image(image: FileImage(_imageFile!)).image
                  : const NetworkImage('https://www.woolha.com/media/2020/03/eevee.png'),
              // backgroundImage:NetworkImage('https://www.woolha.com/media/2020/03/eevee.png') ,
              // Replace with the URL of the user's profile picture
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Center(child: Icon(Icons.edit, color: Colors.white, size:20)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showImagePicker(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // You can also use ImageSource.camera for the camera.

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      List<int> photoBytes = await _imageFile!.readAsBytes();
      final photoBase64 = base64Encode(photoBytes);
      Get.find<UpdateProfileController>().updatePhoto(photoBase64);
    }
  }

}

