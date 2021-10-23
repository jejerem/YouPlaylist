import 'package:webview_flutter/webview_flutter.dart';
import 'package:you_play_list/constants/values.dart';

class Link {
  Link();

  static void mutation(WebViewController webviewController) async {
    await webviewController.evaluateJavascript("""
    // Select the node that will be observed for mutations
    var targetNode = document.getElementsByClassName("page-container")[0];
 

    // Options for the observer (which mutations to observe)
    var config = { subtree: true, childList: true };

    // Callback function to execute when mutations are observed
    var callback = function(mutationsList) {
          Place.postMessage("");
    };

    // Create an observer instance linked to the callback function
    var observer = new MutationObserver(callback);

    // Start observing the target node for configured mutations
    try{
      observer.observe(targetNode, config);
    } catch(e){
      Loop.postMessage("");
    }
      """);
  }
}
