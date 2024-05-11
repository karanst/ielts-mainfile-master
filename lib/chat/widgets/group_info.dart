import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String teacherId;

  GroupInfo({required this.teacherId, Key? key}) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center children vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center children horizontally
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection("Teacher").doc(widget.teacherId).snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  List groupMember = snapshot.data!['membersID'];
                  List groupMemberDetails = snapshot.data!['members'];
                  return Column(

                    children: [
                 Container(
                   child: Column(

                     children: [
                       Image.network(
                         snapshot.data!["GroupImage"],
                         width: 100,
                       ),
                       SizedBox(height: 10), // Add some spacing between the image and text
                       Text(
                         snapshot.data!["GroupTitle"],
                         style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       Text("Group Members ${groupMember.length}"),

                     ],
                   ),
                 ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: groupMemberDetails.length,
                          itemBuilder: ( context,i){
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ListTile(
                                leading:   Image.network(
                                  snapshot.data!["GroupImage"],
                                  width: 100,
                                ),
                                title: Text(groupMemberDetails[i]['name']),
                              ),
                            );
                          })

                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


class CommunityInfo extends StatefulWidget {


  CommunityInfo({ Key? key}) : super(key: key);

  @override
  State<CommunityInfo> createState() => _CommunityInfoState();
}

class _CommunityInfoState extends State<CommunityInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center children vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center children horizontally
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection("Community").doc('chats').snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  List groupMember = snapshot.data!['membersID'];
                  List groupMemberDetails = snapshot.data!['members'];
                  return Column(

                    children: [
                      Container(
                        child: Column(

                          children: [
                            Image.network(
                              snapshot.data!["GroupImage"],
                              width: 100,
                            ),
                            SizedBox(height: 10), // Add some spacing between the image and text
                            Text(
                              snapshot.data!["GroupTitle"],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("Group Members ${groupMember.length}"),

                          ],
                        ),
                      ),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: groupMemberDetails.length,
                          itemBuilder: ( context,i){
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ListTile(
                                leading:   Image.network(
                                  snapshot.data!["GroupImage"],
                                  width: 100,
                                ),
                                title: Text(groupMemberDetails[i]['name']),
                              ),
                            );
                          })

                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}