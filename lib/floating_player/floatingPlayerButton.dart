import 'package:flutter/material.dart';
import 'package:you_play_list/assets_youtube_player.dart';
import 'package:you_play_list/floating_player/floating_player_content.dart';
import 'package:sizer/sizer.dart';
import 'package:you_play_list/player_page/player_page_scaffold.dart';
import 'package:you_play_list/player_page/player_update.dart';

// Will be replaced by a material button to avoid scale issues.

class FloattingPlayerButton extends StatefulWidget {
  FloattingPlayerButton();

  @override
  _FloattingPlayerButtonState createState() => _FloattingPlayerButtonState();
}

class _FloattingPlayerButtonState extends State<FloattingPlayerButton> {
  bool isButtonVisible = true;

  FloatingActionButton? floatingPlayer;

  @override
  Widget build(BuildContext context) {
    floatingPlayer = FloatingActionButton.extended(
      heroTag: null,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(45))),
      label: FloatingPlayerContent(),
      onPressed: () async {
        if (!PlayerUpdate.assetsAudioPlayer!.current.hasValue) {
          String? currentUrl =
              await PlayerUpdate.webViewController!.currentUrl();
          if (!currentUrl!.contains("playlist")) {
            return;
          }
        }

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => PlayerPageScaffold(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              final tween = Tween(begin: begin, end: end);
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: curve,
              );

              return SlideTransition(
                position: tween.animate(curvedAnimation),
                child: child,
              );
            },
            transitionDuration: Duration(milliseconds: 1000),
          ),
        );
      },
    );
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.h),
        child: Transform.scale(
            scale: 0.2493.h,
            child: SizedBox(
                child: FittedBox(
                    child: Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: floatingPlayer,
            )))));
  }
}
