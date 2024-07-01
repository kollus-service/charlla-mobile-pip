# PiPlayground

A simple iOS app exploring how to implement Picture in Picture in a custom player.



## Webview
- source: `charlla-player-webview/ios-pip/PiPlayground/PiPlayground/Views/WebView.swift`

- interface config : `CharllaConfig`, `Charlla`
  ```swift
    func addJavascriptInterface() {
      logger.notice("[JavaScriptWebView] addJavascriptInterface()")
      let script = """
      window.CharllaConfig = {};
      CharllaConfig.os = 'ios';
      CharllaConfig.bannerLinkExternal = true;
      CharllaConfig.shareExternal = true;
      """
      let userScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
      let contentController = configuration.userContentController
      contentController.addUserScript(userScript)
      contentController.add(self, name: "Charlla")
    }
  ```

- message send to charlla
    ```swift
    func runJavascript(script: String) {
      let postMessageScript = "window.postMessage(JSON.stringify(\(script)))"
      logger.notice("[JavaScriptWebView] runJavascript: \(postMessageScript)")
      evaluateJavaScript(postMessageScript) { (result, error) in
        if let error = error {
          self.logger.error("[JavaScriptWebView] \(error)")
        }
      }
    }
    ```
- Receive message from charlla
    ```swift
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
      logger.notice("Received message from JavaScript: \(message)")
    }
    ```


## Picture In Picture
- send action message
  ```swift
  func startPiP() {
    logger.notice("[WebViewWrapper] startPiP")
    self._webView.runJavascript(script: "{action: 'pip', payload: {mode: 'on'}}")
  }
  ```


## Reference github repo
- https://github.com/tfaki/PictureInPicture
