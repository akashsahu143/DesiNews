
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:desishot_app/models/content.dart';
import 'package:desishot_app/services/firestore_service.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Content videoContent;

  VideoPlayerScreen({required this.videoContent});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoContent.url));
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    setState(() {});
  }

  void _updateLikes() async {
    await _firestoreService.updateContentLikes(widget.videoContent.id, widget.videoContent.likes + 1);
    setState(() {
      widget.videoContent.likes++;
    });
  }

  void _updateComments() async {
    await _firestoreService.updateContentComments(widget.videoContent.id, widget.videoContent.comments + 1);
    setState(() {
      widget.videoContent.comments++;
    });
  }

  void _updateShares() async {
    await _firestoreService.updateContentShares(widget.videoContent.id, widget.videoContent.shares + 1);
    setState(() {
      widget.videoContent.shares++;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoContent.title),
      ),
      body: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
          ? Column(
              children: [
                Expanded(
                  child: Center(
                    child: Chewie(controller: _chewieController!),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.videoContent.description, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                            onPressed: _updateLikes,
                            icon: Icon(Icons.thumb_up),
                            label: Text("${widget.videoContent.likes} Likes"),
                          ),
                          TextButton.icon(
                            onPressed: _updateComments,
                            icon: Icon(Icons.comment),
                            label: Text("${widget.videoContent.comments} Comments"),
                          ),
                          TextButton.icon(
                            onPressed: _updateShares,
                            icon: Icon(Icons.share),
                            label: Text("${widget.videoContent.shares} Shares"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}


