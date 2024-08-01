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
      guard let messageBody = message.body as? String, let data = messageBody.data(using: String.Encoding.utf8) else {
            return
          }
      logger.notice("Received message from JavaScript: \(messageBody)")
      print(data)
  }

  // Add JavaScript Interface
  func addJavascriptInterface() {
    logger.notice("[JavaScriptWebView] addJavascriptInterface()")
    let script = """
    window.CharllaConfig = {};
    CharllaConfig.webview = 'ios';
    CharllaConfig.bannerLinkExternal = true;
    CharllaConfig.shareExternal = true;
    CharllaConfig.customBanner = true;
    """
    let userScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
    let contentController = configuration.userContentController
    contentController.addUserScript(userScript)
    contentController.add(self, name: "Charlla")
  }

  func runJavascript(script: String) {
    let postMessageScript = "window.Charlla.recevieMessage(JSON.stringify(\(script)))"
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
    configuration.allowsInlineMediaPlayback = true
    if #available(iOS 14.0, *) {
      configuration.defaultWebpagePreferences.allowsContentJavaScript = true
    } else {
      configuration.preferences.javaScriptEnabled = true
    }
    self._webView = JavaScriptWebView(frame: .zero, configuration: configuration)
    self._webView.isInspectable = true
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
  }

  func sendAction(action: String, payload: String) {
    logger.notice("[WebViewWrapper] sendAction")
    self._webView.runJavascript(script: "{action: '\(action)', payload: \(payload)}")
  }
}


// Create SwiftUI View
struct ContentView: View {
  @Environment(\.scenePhase) var scenePhase

  private let logger = Logger(category: "contentView")
  private let webViewWrapper: WebViewWrapper
  let url: URL
  private let contentKey: String = "hxSwHB54eVe"

  init(url: URL) {
    self.url = url
    self.webViewWrapper = WebViewWrapper(url: url)
    print("contentView init")
  }

  var body: some View {
    // Text("Example Text")
    //   .onChange(of: scenePhase) { newPhase in
    //       if newPhase == .inactive {
    //           print("Inactive")
    //       } else if newPhase == .active {
    //           print("Active")
    //       } else if newPhase == .background {
    //           print("Background")
    //       }
    //   }
    webViewWrapper.onAppear {
      print("WebViewWrapper onAppear")
    }
  }

  func startWebviewPiP() {
    webViewWrapper.startPiP()
  }

  func sendBanner() {
    webViewWrapper.sendAction(
      action: "banner",
      payload: "{'key':'\(self.contentKey)','title':'여러개의 주식 정보를 표시하는 배너리스트, 여러개의 주식 정보를 표시하는 배너리스트','data':[{'type':'stock','image':'https://images.samsung.com/kdp/aboutsamsung/brand_identity/logo/300_186_3.png','name':'에코프로','rate':4.68,'compare':2,'link':'app://catenoid.net/086520'},{'type':'stock','image':'https://images.samsung.com/kdp/aboutsamsung/brand_identity/logo/300_186_3.png','name':'삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, ','rate':6999999453,'compare':0,'link':'app://catenoid.net/005930'},{'type':'stock','image':'https://images.samsung.com/kdp/aboutsamsung/brand_identity/logo/300_186_3.png','name':'삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, ','rate':0.88,'compare':1,'link':'app://catenoid.net/005930'},{'type':'stock','image':'https://images.samsung.com/kdp/aboutsamsung/brand_identity/logo/300_186_3.png','name':'삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, ','rate':0.88,'compare':0,'link':'app://catenoid.net/005930'},{'type':'stock','image':'https://images.samsung.com/kdp/aboutsamsung/brand_identity/logo/300_186_3.png','name':'삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, ','rate':0.4444,'compare':2,'link':'app://catenoid.net/005930'},{'type':'stock','image':'https://images.samsung.com/kdp/aboutsamsung/brand_identity/logo/300_186_3.png','name':'삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, ','rate':6999999453,'compare':2,'link':'app://catenoid.net/005930'},{'type':'content','image':'https://images.pexels.com/photos/20279610/pexels-photo-20279610.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2','content':'가나다라마바사아자차카타파하가나다라마바사아자카타파하','link':'app://catenoid.net/content-link/111'}]}"
    )
  }

  func sendLikeOn() {
    webViewWrapper.sendAction(
      action: "like",
      payload: "{'key':'\(self.contentKey)','status': true}"
    )
  }

  func sendLikeOff() {
    webViewWrapper.sendAction(
      action: "like",
      payload: "{'key':'\(self.contentKey)','status': false}"
    )
  }

  func sendMiniOn() {
    webViewWrapper.sendAction(
      action: "mini",
      payload: "{'key':'\(self.contentKey)','mode': 'on'}"
    )
  }

  func sendMiniOff() {
    webViewWrapper.sendAction(
      action: "mini",
      payload: "{'key':'\(self.contentKey)','mode': 'off'}"
    )
  }

  func sendPiPOn() {
    webViewWrapper.sendAction(
      action: "pip",
      payload: "{'key':'\(self.contentKey)','mode': 'on'}"
    )
  }

  func sendPiPOff() {
    webViewWrapper.sendAction(
      action: "pip",
      payload: "{'key':'\(self.contentKey)','mode': 'off'}"
    )
  }
}

// Preview Provider
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      ContentView(url: URL(string: "http://")!) // Add a URL to preview the WebView
  }
}
