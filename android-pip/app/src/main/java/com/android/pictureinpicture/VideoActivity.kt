package com.android.pictureinpicture

import android.annotation.SuppressLint
import android.app.PictureInPictureParams
import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.util.Rational
import android.view.Gravity
import android.view.View
import android.webkit.JavascriptInterface
import android.webkit.WebChromeClient
import android.webkit.WebSettings
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.Button
import android.widget.LinearLayout
import org.json.JSONException
import org.json.JSONObject

class VideoActivity : AppCompatActivity() {

    private val TAG:String = "VIDEO_WEBVIEW_TAG"
    private var pictureInPictureParamsBuilder:PictureInPictureParams.Builder? = null
    private lateinit var webView: WebView

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        findViewById<Button>(R.id.banner_button)
        .setOnClickListener {
            this.sendToCharlla("{'action':'banner','payload':{'key':'hxSwHB54eVe','title':'여러개의 주식 정보를 표시하는 배너리스트, 여러개의 주식 정보를 표시하는 배너리스트','data':[{'type':'stock','image':'https://images.samsung.com/kdp/aboutsamsung/brand_identity/logo/300_186_3.png','name':'에코프로','rate':4.68,'compare':2,'link':'app://catenoid.net/086520'},{'type':'stock','image':'https://images.samsung.com/kdp/aboutsamsung/brand_identity/logo/300_186_3.png','name':'삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, ','rate':6999999453,'compare':0,'link':'app://catenoid.net/005930'},{'type':'stock','image':'https://images.samsung.com/kdp/aboutsamsung/brand_identity/logo/300_186_3.png','name':'삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, ','rate':0.88,'compare':1,'link':'app://catenoid.net/005930'},{'type':'stock','image':'https://images.samsung.com/kdp/aboutsamsung/brand_identity/logo/300_186_3.png','name':'삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, ','rate':0.88,'compare':0,'link':'app://catenoid.net/005930'},{'type':'stock','image':'https://images.samsung.com/kdp/aboutsamsung/brand_identity/logo/300_186_3.png','name':'삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, ','rate':0.4444,'compare':2,'link':'app://catenoid.net/005930'},{'type':'stock','image':'https://images.samsung.com/kdp/aboutsamsung/brand_identity/logo/300_186_3.png','name':'삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, 삼성전자, ','rate':6999999453,'compare':2,'link':'app://catenoid.net/005930'},{'type':'content','image':'https://images.pexels.com/photos/20279610/pexels-photo-20279610.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2','content':'가나다라마바사아자차카타파하가나다라마바사아자카타파하','link':'app://catenoid.net/content-link/111'}]}}")
        }

        findViewById<Button>(R.id.like_on_button)
            .setOnClickListener {
                this.sendToCharlla("{action: 'like', payload: { key: 'hxSwHB54eVe', status: true}}");
            }

        findViewById<Button>(R.id.like_off_button)
            .setOnClickListener {
                this.sendToCharlla("{action: 'like', payload: { key: 'hxSwHB54eVe', status: false}}");
            }

        findViewById<Button>(R.id.mini_on_button)
            .setOnClickListener {
                this.sendToCharlla("{action: 'mini', payload: { key: 'hxSwHB54eVe', mode: 'on'}}");
            }

        findViewById<Button>(R.id.mini_off_button)
            .setOnClickListener {
                this.sendToCharlla("{action: 'mini', payload: { key: 'hxSwHB54eVe', mode: 'off'}}");
            }

        //init PictureInPictureParams, requires Android O and above
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            pictureInPictureParamsBuilder = PictureInPictureParams.Builder()
        }

        webView = findViewById(R.id.webView)
        // Load web page in WebView
        webView.webViewClient = WebViewClient()
        this.setupWebView()
        webView.loadUrl("https://dev-player.charlla.io/shoplayer/list/QFuoEZxk1AJ?l=grid")
    }

    private fun sendToCharlla(message: String) {
        webView.evaluateJavascript("javascript:Charlla.recevieMessage(JSON.stringify($message))", null)
    }

    @SuppressLint("SetJavaScriptEnabled")
    private fun setupWebView() {
        val webSettings: WebSettings = webView.settings;
        webSettings.javaScriptEnabled = true
        webSettings.mediaPlaybackRequiresUserGesture = false
        webSettings.loadWithOverviewMode = true
        webSettings.useWideViewPort = true
        webSettings.domStorageEnabled = true

        webView.webViewClient = WebViewClient()
        webView.addJavascriptInterface(CharllaHandler(this), "Charlla")
        webView.webViewClient = object : WebViewClient() {
            override fun onPageStarted(view: WebView?, url: String?, favicon: android.graphics.Bitmap?) {
                super.onPageStarted(view, url, null)
                // Inject JavaScript code when the document starts
                val script:String = """
                javascript:(function() {
                    window.CharllaConfig = {};
                    CharllaConfig.webview = 'android';
                    CharllaConfig.bannerLinkExternal = true;
                    CharllaConfig.shareExternal = true;
                    CharllaConfig.customBanner = true;
                })();
                """
                webView.evaluateJavascript(script, null)
            }
        }
        webView.webChromeClient = object : WebChromeClient() {
            override fun onShowCustomView(view: View?, callback: CustomViewCallback?) {
                super.onShowCustomView(view, callback)
                pictureInPictureMode()
            }
        }
    }

    class CharllaHandler internal constructor(private val activity: VideoActivity) {
        private val TAG:String = "CHARLL_HANDLER_TAG";

        @JavascriptInterface
        fun postMessage(message: String) {
            Log.d(TAG, "Charlla.postMessage:")
            Log.d(TAG, message)
            try {
                val json = JSONObject(message)
                val action = json.getString("action")
                val payload = json.getJSONObject("payload")
                Log.d(TAG, action)
                if (action.equals(action, false)) {
                    val loadKey = payload.getString("key")
                    Log.d(TAG, loadKey);
                }
                // Parse the JSON data and perform necessary actions
                // ...
            } catch (e: JSONException) {
                e.printStackTrace()
            }
            Toast.makeText(activity, message, Toast.LENGTH_SHORT).show()
        }
    }

    private fun pictureInPictureMode(){
        //Requires Android O and higher
        Log.d(TAG, "pictureInPictureMode: Try to enter in PIP mode")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            Log.d(TAG, "pictureInPictureMode: Supports PIP")
            //setup PIP height width
            val aspectRatio = Rational(webView.width, webView.height)
            pictureInPictureParamsBuilder!!.setAspectRatio(aspectRatio).build()
            enterPictureInPictureMode(pictureInPictureParamsBuilder!!.build())
        }
        else{
            Log.d(TAG, "pictureInPictureMode: Doesn't supports PIP")
            Toast.makeText(this, "Your device doesn't supports PIP", Toast.LENGTH_LONG).show()
        }
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        //when user presses home button, if not in PIP mode, enter in PIP, requires Android N and above
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N){
            Log.d(TAG, "onUserLeaveHint: was not in PIP")
            pictureInPictureMode()
        }
        else{
            Log.d(TAG, "onUserLeaveHint: Already in PIP")
        }
    }

    override fun onBackPressed() {
        onUserLeaveHint()
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration?
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        if (isInPictureInPictureMode){
            Log.d(TAG, "onPictureInPictureModeChanged: Entered PIP")
        }
        else{
            Log.d(TAG, "onPictureInPictureModeChanged: Exited PIP")
        }
    }

    override fun onStop() {
        super.onStop()
    }
}