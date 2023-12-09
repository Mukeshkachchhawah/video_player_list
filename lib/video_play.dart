import 'package:flutter/material.dart';
import 'package:video_play_list/video_clip.dart';
import 'package:video_player/video_player.dart';

class VideoPlay extends StatefulWidget {
  final List<VideoClip> clips;
   VideoPlay({required this.clips});

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  VideoPlayerController? mController;

  List<VideoClip> get _clips{
    return widget.clips;
  }

  var isPlayingValue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var videoUrl =
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
    mController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    mController!.initialize();
    mController!.play();

    mController!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Play"),
      ),
      body: Column(
        children: <Widget>[
          PlayVideo(),
          SizedBox(
            height: 10,
          ),
          Expanded(child: VideoList())
        ],
      ),
    );
  }

  Widget PlayVideo() {
    return mController != null
        ? AspectRatio(
            aspectRatio: mController!.value.aspectRatio,
            child: Stack(
              children: <Widget>[
                VideoPlayer(mController!),

                /// left skeep and right skeep
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /// 10 second back
                    InkWell(
                      onDoubleTap: () {
                        if (mController!.value.position.inSeconds - 10 <
                            mController!.value.duration.inSeconds) {
                          mController!.seekTo(Duration(
                              seconds:
                                  mController!.value.position.inSeconds - 10));
                        } else {
                          mController!.seekTo(mController!.value.duration);
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // color: Colors.white.withOpacity(0.4)
                        ),
                        child: Center(child: Icon(Icons.arrow_back)),
                      ),
                    ),

                    /// Video Play and pause icons control
                    Center(
                      child: InkWell(
                        onTap: () {
                          mController!.value.isPlaying
                              ? mController!.pause()
                              : mController!.play();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.4)),
                          child: Center(
                            child: mController!.value.isPlaying
                                ? Icon(Icons.pause)
                                : Icon(Icons.play_circle_outline),
                          ),
                        ),
                      ),
                    ),

                    /// 10 second in forward
                    InkWell(
                      onDoubleTap: () {
                        if (mController!.value.position.inSeconds + 10 <
                            mController!.value.duration.inSeconds) {
                          mController!.seekTo(Duration(
                              seconds:
                                  mController!.value.position.inSeconds + 10));
                        } else {
                          mController!.seekTo(mController!.value.duration);
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),
                  ],
                ),

                /// seek video control
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Slider(
                      /// video start duration 0
                      min: 0,

                      /// video end duration
                      max: mController!.value.duration.inSeconds.toDouble(),

                      /// video ki current position
                      value: mController!.value.position.inSeconds.toDouble(),
                      onChanged: (value) {
                        mController!.seekTo(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                )
              ],
            ))
        : AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Center(
              child: Text("data Not Fount"),
            ));
  }

  Widget VideoList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {},
            leading: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://i.ytimg.com/vi/_dwRaeFbqnI/maxresdefault.jpg"))),
            ),
            title: Text("title"),
            subtitle: Text("Subtitle"),
            trailing: Icon(Icons.play_circle_outline),
          ),
        );
      },
    );
  }
}
