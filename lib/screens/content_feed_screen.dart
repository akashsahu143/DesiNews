
import 'package:flutter/material.dart';
import 'package:desishot_app/models/content.dart';
import 'package:desishot_app/services/firestore_service.dart';
import 'package:desishot_app/screens/video_player_screen.dart';

class ContentFeedScreen extends StatefulWidget {
  @override
  _ContentFeedScreenState createState() => _ContentFeedScreenState();
}

class _ContentFeedScreenState extends State<ContentFeedScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DesiShot Feed'),
      ),
      body: StreamBuilder<List<Content>>(
        stream: _firestoreService.getApprovedContentStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No content available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Content content = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          content.title,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (content.type == ContentType.video)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(videoContent: content),
                              ),
                            );
                          },
                          child: Container(
                            height: 200,
                            color: Colors.black,
                            child: Center(child: Icon(Icons.play_arrow, color: Colors.white, size: 50)),
                          ), // Placeholder for video thumbnail
                        ) 
                      else if (content.type == ContentType.meme)
                        Image.network(content.url),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(content.description),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              await _firestoreService.updateContentLikes(content.id, content.likes + 1);
                            },
                            icon: Icon(Icons.thumb_up),
                            label: Text('${content.likes} Likes'),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              await _firestoreService.updateContentComments(content.id, content.comments + 1);
                            },
                            icon: Icon(Icons.comment),
                            label: Text('${content.comments} Comments'),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              await _firestoreService.updateContentShares(content.id, content.shares + 1);
                            },
                            icon: Icon(Icons.share),
                            label: Text('${content.shares} Shares'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}


