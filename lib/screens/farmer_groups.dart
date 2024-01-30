import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import "package:get/get.dart";
import "package:omulimisa2/screens/farmer_group_detail.dart";

import '../utils/CustomTheme.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  List<Map<String, String>> sampleData = [
    {
      'name': 'Group A',
      'leader': 'John Doe',
      'district': 'XYZ District',
      'code': 'ABC123',
    },
    {
      'name': 'Group B',
      'leader': 'Jane Smith',
      'district': 'ABC District',
      'code': 'DEF456',
    },
    // Add more sample data here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right:16, bottom: 25),
        child: FloatingActionButton(
          onPressed: () {
            // Add your desired functionality when the button is pressed
            // For example, navigate to the add screen or perform an action.
            // This is just a placeholder onPressed function.
          },
          backgroundColor: CustomTheme.primary, // Set the background color to dark green
          child: const Icon(Icons.add,color: Colors.white,),

        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: const [
          Icon(
            FeatherIcons.search,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(
            width: 15,
          )
        ],
        title: FxText.titleLarge(
          'Farmer Groups',
          color: Colors.white,
        ),
        backgroundColor: CustomTheme.primary,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: CustomTheme.primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Column(
        children: [

          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: sampleData.length,
                itemBuilder: (context, index) {
                  return GroupCard(
                    name: sampleData[index]['name'] ?? '',
                    leader: sampleData[index]['leader'] ?? '',
                    district: sampleData[index]['district'] ?? '',
                    code: sampleData[index]['code'] ?? '',
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final String name;
  final String leader;
  final String district;
  final String code;

  const GroupCard({super.key, 
    required this.name,
    required this.leader,
    required this.district,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(){
        Get.to(()=>FarmerGroupDetailScreen());
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(bottom: 9),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.0),
            left: const BorderSide(color:Colors.green, width:5.0)
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Name', name),
            _buildDetailRow('Leader', leader),
            _buildDetailRow('District', district),
            _buildDetailRow('Code', code),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 16.0),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value, style: TextStyle(color: label=='Code'?Colors.green[900]:Colors.black,fontWeight: label=='Code'?FontWeight.w600:FontWeight.w400),),
          ],
        ),
      ),
    );
  }
}
