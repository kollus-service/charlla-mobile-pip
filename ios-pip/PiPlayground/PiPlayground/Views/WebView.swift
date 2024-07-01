import SwiftUI
import WebKit
import AVKit
import OSLog

// Create WKWebView subclass
class JavaScriptWebView: WKWebView, WKScriptMessageHandler {
  private let logger = Logger(category: "webview")

  override init(frame: CGRect, configuration: WKWebViewConfiguration) {
    super.init(frame: frame, configuration: configuration)
    addJavascriptInterface()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    logger.notice("Received message from JavaScript: \(message)")
  }

  // Add JavaScript Interface
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

  func runJavascript(script: String) {
    let postMessageScript = "window.postMessage(JSON.stringify(\(script)))"
    logger.notice("[JavaScriptWebView] runJavascript: \(postMessageScript)")
    evaluateJavaScript(postMessageScript) { (result, error) in
      if let error = error {
        self.logger.error("[JavaScriptWebView] \(error)")
      }
    }
  }
}

// Create WebView Wrapper
struct WebViewWrapper: UIViewRepresentable {
  let url: URL
  private let logger = Logger(category: "webview")
  private var _webView: JavaScriptWebView

  init(url: URL) {
    self.url = url
    let configuration = WKWebViewConfiguration()
    self._webView = JavaScriptWebView(frame: .zero, configuration: configuration)
    self._webView.load(URLRequest(url: url))
  }

  func makeUIView(context: Context) -> JavaScriptWebView {
      return self._webView
  }

  func updateUIView(_ uiView: JavaScriptWebView, context: Context) {
    // Update the view if needed.
  }

  func startPiP() {
    logger.notice("[WebViewWrapper] startPiP")
    self._webView.runJavascript(script: "{action: 'pip', payload: {mode: 'on'}}")
  }
}


// Create SwiftUI View
struct ContentView: View {
  private let logger = Logger(category: "contentView")
  private let webViewWrapper: WebViewWrapper
  let url: URL

  init(url: URL) {
    self.url = url
    self.webViewWrapper = WebViewWrapper(url: url)
  }

  var body: some View {
    webViewWrapper.onAppear {
      setupPiP()
    }
  }

  // Setup PiP
  func setupPiP() {
    logger.notice("[ContentView] setupPiP")
    guard let videoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"),
        AVPictureInPictureController.isPictureInPictureSupported() else { return }

    logger.notice("[ContentView] PiP is supported")

    let playerItem = AVPlayerItem(url: videoURL)
    let player = AVPlayer(playerItem: playerItem)
    let playerLayer = AVPlayerLayer(player: player)

    // Assuming PiP setup is similar to UIKit, but might need adjustments for SwiftUI
    let pipController = AVPictureInPictureController(playerLayer: playerLayer)
    pipController?.startPictureInPicture()
  }

  func startWebviewPiP() {
    webViewWrapper.startPiP()
  }
}

// Preview Provider
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      ContentView(url: URL(string: "http://")!) // Add a URL to preview the WebView
  }
}
