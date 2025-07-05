
import 'package:flutter/material.dart';
import 'package:desishot_app/models/content.dart';
import 'package:desishot_app/services/firestore_service.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class AdminApprovalScreen extends StatefulWidget {
  @override
  _AdminApprovalScreenState createState() => _AdminApprovalScreenState();
}

class _AdminApprovalScreenState extends State<AdminApprovalScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Approval'),
      ),
      body: StreamBuilder<List<Content>>(
        stream: _firestoreService.getUnapprovedContentStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No content awaiting approval.'));
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
                        _VideoPreview(videoUrl: content.url)
                      else if (content.type == ContentType.meme)
                        Image.network(content.url),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(content.description),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await _firestoreService.approveContent(content.id);
                            },
                            child: Text('Approve'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              // Implement rejection logic (e.g., delete from Firestore/Storage)
                              // For now, just a placeholder
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Content rejected (not implemented yet)')),
                              );
                            },
                            child: Text('Reject'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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

class _VideoPreview extends StatefulWidget {
  final String videoUrl;

  _VideoPreview({required this.videoUrl});

  @override
  __VideoPreviewState createState() => __VideoPreviewState();
}

class __VideoPreviewState extends State<_VideoPreview> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      showControls: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
        ? Container(
            height: 200,
            child: Chewie(controller: _chewieController!),
          )
        : Container(
            height: 200,
            color: Colors.black,
            child: Center(child: CircularProgressIndicator()),
          );
  }
}


