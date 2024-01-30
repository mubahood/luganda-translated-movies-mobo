import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import '../../../../models/TrainingModel.dart';
import '../../../../utils/CustomTheme.dart';


class TrainingCard extends StatelessWidget {
  final TrainingModel session;

  const TrainingCard(this.session, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:200,
      child: Card(
        elevation: 6.0,
        color:Colors.white,
        surfaceTintColor: Colors.white,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxContainer(
              color: CustomTheme.primary,
              borderRadiusAll: 0,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: ListTile(
                title: FxText.bodySmall(
                  session.name,
                  fontWeight: 800,
                  fontSize: 18,
                  color: Colors.white,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.bodySmall(
                      'Venue: ${session.venue}',
                      fontWeight: 800,
                      fontSize: 15,
                      color: Colors.white,
                    ),

                    FxText.bodySmall(
                      'Date: ${session.date}',
                      fontWeight: 800,
                      fontSize: 15,
                      color: Colors.white,
                    ),

                    FxText.bodySmall(
                      'Time: ${session.time }',
                      fontWeight: 800,
                      fontSize: 15,
                      color: Colors.white,
                    ),

                  ],
                ),
                onTap: () {
                  // Handle onTap event if needed
                },
              ),

            ),

          ],
        ),
      ),
    );
  }
}




class TrainingDetailsPage extends StatelessWidget {
  final Map<String, dynamic> trainingData = {
    "id": 1,
    "session_date": "2023-06-15",
    "start_date": "00:00:47",
    "end_date": "00:00:47",
    "details": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed commodo arcu vel sapien vestibulum, quis iaculis sapien tincidunt. Integer non justo vel turpis interdum ullamcorper eu quis est. Nunc ullamcorper tellus a tristique hendrerit. Nulla facilisi. Duis in tincidunt nisi. Fusce ac dolor vel enim rhoncus ultricies. Aenean vel luctus purus, eu cursus nunc. Pellentesque eu malesuada turpis, id elementum orci. Sed ut neque sit amet neque convallis rhoncus. Nam eget tortor eu odio egestas facilisis vel id lacus.",
    "topics_covered": [
      "Introduction to Flutter",
      "Working with Widgets",
      "State Management",
      "Building UI",
    ],
    "attendance_list_pictures": [
      "https://unified.m-omulimisa.com/storage/images/1688737350-151350.jpg",
      "https://unified.m-omulimisa.com/storage/images/1688772646-970358.png",
      "https://unified.m-omulimisa.com/storage/images/Shorts-3_First_Frame.png",
    ],
    "members_pictures": [
      "https://unified.m-omulimisa.com/storage/images/1688737350-151350.jpg",
      "https://unified.m-omulimisa.com/storage/images/1688772646-970358.png",
      "https://unified.m-omulimisa.com/storage/images/Shorts-3_First_Frame.png",

    ],
  };

  TrainingDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: FxText.titleLarge(
          'Completed Trainings',
          color: Colors.white,
        ),
        backgroundColor: CustomTheme.primary,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: CustomTheme.primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: TrainingDetailsWidget(trainingData: trainingData),
    );
  }
}

class TrainingDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> trainingData;

  const TrainingDetailsWidget({super.key, required this.trainingData});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Card(
          elevation: 4.0,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxContainer(
                  color: CustomTheme.primary,
                  borderRadiusAll: 0,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: FxText.bodySmall(
                    'Session Date: ${trainingData['session_date']}',
                    fontWeight: 800,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Details:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                SingleChildScrollView(
                  child: Text(trainingData['details'] ?? ''),
                ),
                const SizedBox(height: 16.0),
                if (trainingData['topics_covered'] != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Topics Covered:',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      for (var topic in trainingData['topics_covered'])
                        ListTile(
                          leading: const Icon(Icons.check),
                          title: Text(topic),
                        ),
                    ],
                  ),
                const SizedBox(height: 16.0),
                const Divider(),
                if (trainingData['attendance_list_pictures'] != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Attendance List Pictures:',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        SizedBox(
                          height: 200.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: trainingData['attendance_list_pictures'].length,
                            itemBuilder: (context, index) {
                              final imageUrl = trainingData['attendance_list_pictures'][index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  imageUrl,
                                  height: 150.0,
                                  width: 150.0,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                const Divider(),
                const SizedBox(height: 16.0),
                if (trainingData['members_pictures'] != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Members Pictures:',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        SizedBox(
                          height: 200.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: trainingData['members_pictures'].length,
                            itemBuilder: (context, index) {
                              final imageUrl = trainingData['members_pictures'][index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  imageUrl,
                                  height: 150.0,
                                  width: 150.0,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

              ],
            ),
          ),
        ),




      ],
    );
  }
}
