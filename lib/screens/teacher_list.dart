import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'adverting/advertining_screen.dart';

class TeacherList extends StatefulWidget {
  const TeacherList({Key? key}) : super(key: key);

  @override
  State<TeacherList> createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 1) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        automaticallyImplyLeading: false,
        title: Text("Our Teachers"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(

        child: Container(
          padding: EdgeInsets.only(top: 25),
          color: Colors.white,
          // height: 200,

          width: double.infinity,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("TeacherData").snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data!.docs.isNotEmpty) {
                return GridView.builder(
                  padding: EdgeInsets.only(left: 5,right: 5),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      childAspectRatio: 0.6,


                      // mainAxisExtent: 500,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                    itemBuilder:(BuildContext context,i){
                    return GestureDetector(
                      onTap: (){

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    AdvertisingScreen(snap: snapshot.data!.docs[i],)));                      },
                      child: Card(
                        // color: Colors.white10,
                        surfaceTintColor: Colors.white,

                        child: Column(
                          children: [
                            SizedBox(height: 15,),
                        CircleAvatar(
                        backgroundColor: Colors.grey[200],
                          radius: 70, // Adjust the radius as needed
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data!.docs[i]['img'],
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover, // Ensure the image is scaled to fit the circle
                                  ),
                                ),
                              );
                            },
                            placeholder: (context, url) => CircularProgressIndicator(), // Placeholder while the image loads
                            errorWidget: (context, url, error) => Icon(Icons.error), // Error icon if the image fails to load
                          ),),
                            SizedBox(height: 5,),
                            Text(snapshot.data!.docs[i]['name'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                            Text(snapshot.data!.docs[i]['subject'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blue),),
                            Text(snapshot.data!.docs[i]['description_1'],
                              maxLines: 4,textAlign: TextAlign.center,),



                          ],
                        ),

                      ),
                    );
                    } );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
