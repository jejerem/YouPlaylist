import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:you_play_list/constants/values.dart';

import 'player_page/player_update.dart';

class MainMenuSilverAppBar extends StatefulWidget {
  const MainMenuSilverAppBar({Key? key}) : super(key: key);

  @override
  _MainMenuSilverAppBarState createState() => _MainMenuSilverAppBarState();
}

class _MainMenuSilverAppBarState extends State<MainMenuSilverAppBar>
    with WidgetsBindingObserver {
  FocusNode inputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final value = WidgetsBinding.instance!.window.viewInsets.bottom;
    if (value == 0) {
      inputFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizerUtil.height = MediaQuery.of(context).size.height;
    SizerUtil.width = MediaQuery.of(context).size.width;
    SizerUtil.orientation = Orientation.portrait;

    return Container(
      height: 5.h,
      child: TextFormField(
        focusNode: inputFocusNode,
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (value) async {
          await PlayerUpdate.webViewController!
              .loadUrl(Constants.youtube_query_url + value);

          /*await PlayerUpdate.webViewController!.evaluateJavascript("""
                avatarElements = document.getElementsByClassName('icon-button topbar-menu-button-avatar-button');
                if (avatarElements.length != 0){
                  avatar[elements]
                }
                """);*/
        },
        decoration: InputDecoration(
          labelText: "Search",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
