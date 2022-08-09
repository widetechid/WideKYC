package com.wide.mobile.wkycdemo;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.PermissionRequest;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

public class WebViewActivity extends AppCompatActivity {
    final static String TAG = "WebViewActivity";
    final static int CAMERA_PERMISSION_REQUEST = 0;
    private Activity activity;
    private WebView webView;
    private String url, product, trxId;
    private PermissionRequest cameraRequest;
    private LinearLayout loader;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.activity = this;

        initActivity();
        initWebView();
    }

    private void initActivity(){
        setContentView(R.layout.webview_activity);
        webView = findViewById(R.id.webview);
        loader = findViewById(R.id.mainLoader);

        url = "https://cripix.com/widekyc3";
        product = getIntent().getStringExtra("product");
        trxId = getIntent().getStringExtra("trxId");
    }

    private void initWebView(){
        loader.setVisibility(View.VISIBLE);

        webView.setWebViewClient(new myWebclient());
        webView.setWebChromeClient(new myChromeClient());
        webView.getSettings().setJavaScriptEnabled(true);
        webView.addJavascriptInterface(new WebAppInterface(this), "Mobile");

        webView.loadUrl(url+"?product="+product+"&trxid="+trxId);
    }

    public class myWebclient extends WebViewClient {
        private ProgressBar progressBar;

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            super.onPageStarted(view, url, favicon);
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
            loader.setVisibility(View.GONE);
        }

        @Override
        public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
            super.onReceivedError(view, request, error);
            loader.setVisibility(View.GONE);
        }
    }

    public class myChromeClient extends WebChromeClient {
        @Override
        public void onPermissionRequest(PermissionRequest request) {
            if (ActivityCompat.checkSelfPermission(getApplicationContext(), Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED){
                ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.CAMERA}, CAMERA_PERMISSION_REQUEST);
                cameraRequest = request;
            }
            else{
                request.grant(request.getResources());
            }
        }
        @Override
        public Bitmap getDefaultVideoPoster() {
            return Bitmap.createBitmap(10, 10, Bitmap.Config.ARGB_8888);
        }
    }

    public class WebAppInterface {
        Context mContext;

        /** Instantiate the interface and set the context */
        WebAppInterface(Context c) {
            mContext = c;
        }

        /** Show a toast from the web page */
        @JavascriptInterface
        public void notify(String message) {
            Intent intent = new Intent();
            intent.putExtra("result", message);
            intent.putExtra("trxId", trxId);
            setResult(Activity.RESULT_OK, intent);
            finish();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        switch (requestCode) {
            case CAMERA_PERMISSION_REQUEST: {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    cameraRequest.grant(cameraRequest.getResources());

                } else {
                    showToast("Camera Permission Denied");
                    finish();
                }
                return;
            }
        }
    }

    private void showToast(String message){
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                loader.setVisibility(View.INVISIBLE);
                Toast.makeText(activity, message, Toast.LENGTH_SHORT).show();
            }
        });
    }

}