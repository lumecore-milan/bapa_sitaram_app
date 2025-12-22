import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomYoutubeVideoPlayer extends StatefulWidget {
  final String url;

  const CustomYoutubeVideoPlayer({super.key, required this.url});

  @override
  State<CustomYoutubeVideoPlayer> createState() => _CustomYoutubeVideoPlayerState();
}

class _CustomYoutubeVideoPlayerState extends State<CustomYoutubeVideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url) ?? "",
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false, controlsVisibleAtStart: true, hideControls: false, disableDragSeek: false, loop: false, enableCaption: true),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _controller, showVideoProgressIndicator: true, progressIndicatorColor: Colors.red, aspectRatio: 16 / 9, onReady: () => _isPlayerReady = true),

      // ---------- PAGE UI ----------
      builder: (context, player) {
        return Scaffold(
          appBar: CustomAppbar(
            title: "Live Aarti",
            showDrawerIcon: false,
            onBackTap: () {
              Navigator.pop(context);
            },
          ),

          body: Column(
            children: [
              Expanded(child: Container(color: CustomColors().black)),
              player,
              Expanded(child: Container(color: CustomColors().black)),
            ],
          ),
        );
      },
    );
  }
}
