package vn.momo.momo_partner.activity;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.support.annotation.Nullable;
import android.support.annotation.RequiresApi;
import android.util.Base64;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.webkit.JsResult;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

import javax.net.ssl.SSLException;

import vn.momo.momo_partner.ClientHttpAsyncTask;
import vn.momo.momo_partner.MoMoParameterNamePayment;
import vn.momo.momo_partner.R;
import vn.momo.momo_partner.utils.MoMoConfig;
import vn.momo.momo_partner.utils.MoMoLoading;
import vn.momo.momo_partner.utils.MoMoUtils;

/**
 * Created by hungdo on 7/14/17.
 * Updated by Lanh Luu on Sep 9, /2017
 */

public class ActivityMoMoWebView extends Activity{

    private  static  WebView webView, webViewMapBank;
    LinearLayout lnBack, lnReload,ll_progressbar_circle;
    TextView tvTitle;
    ImageView imgReload;
    String webURL = "";
    Bundle dataExtra = null;
    String jsonData = "";
    String urlRequest = "";
    ImageView imgClose,imgBack;
    boolean isLoadBank = false;
    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN)
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.momo_webview_activity);
        imgClose = (ImageView)findViewById(R.id.imgClose);
        imgBack = (ImageView)findViewById(R.id.imgBack);
        dataExtra = getIntent().getExtras();
        if(dataExtra != null){
            webURL = dataExtra.getString(MoMoConfig.INTENT_URL_WEB);
            jsonData = dataExtra.getString(MoMoConfig.INTENT_JSON_DATA);
            urlRequest = dataExtra.getString(MoMoConfig.INTENT_URL_REQUEST);
        }

        webView = (WebView)findViewById(R.id.webView);
        webViewMapBank = (WebView)findViewById(R.id.webViewMapBank);

        lnBack = (LinearLayout)findViewById(R.id.lnBack);
        lnReload = (LinearLayout)findViewById(R.id.lnReload);
        ll_progressbar_circle = (LinearLayout)findViewById(R.id.ll_progressbar_circle);
        tvTitle = (TextView)findViewById(R.id.tvTitle);
        imgReload = (ImageView)findViewById(R.id.imgReload);
        lnBack.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                if(motionEvent.getAction() == motionEvent.ACTION_DOWN){
                    imgClose.setAlpha((float)0.5);
                }
                if(motionEvent.getAction() == motionEvent.ACTION_UP){
                    imgClose.setAlpha((float)1.0);
                }
                return false;
            }
        });
        lnBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String dataRequest = "";
                try {
                    JSONObject obj = new JSONObject(jsonData);
                    obj.put("requestType", "close");
                    obj.put("url_occur", webView.getUrl());
                    dataRequest = obj.toString();
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                (new ClientHttpAsyncTask(ActivityMoMoWebView.this, new ClientHttpAsyncTask.RequestToServerListener() {
                    @Override
                    public void receiveResultFromServer(String param) {
                        finish();
                    }
                }, dataRequest, urlRequest, false)).executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR);
                finish();
            }
        });

        imgBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                webViewMapBank.setVisibility(View.GONE);
                ll_progressbar_circle.setVisibility(View.GONE);
                webView.setVisibility(View.VISIBLE);
                webView.reload();


                long duration = 3000; // 3 seconds
                long tick = 10; // 0.1 seconds;
                new CountDownTimer(duration, tick) {
                    public void onTick(long millisUntilFinished) {
                        imgBack.setVisibility(View.GONE);
                    }
                    public void onFinish() {

                        imgClose.setVisibility(View.VISIBLE);
                    }
                }.start();

            }
        });

        lnReload.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                if(motionEvent.getAction() == motionEvent.ACTION_DOWN){
                    imgReload.setAlpha((float)0.5);
                }
                if(motionEvent.getAction() == motionEvent.ACTION_UP){
                    imgReload.setAlpha((float)1.0);
                }
                return false;
            }
        });
        lnReload.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                imgReload.setImageResource(R.drawable.ic_reload);
                webView.reload();

            }
        });
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP) {
            webView.setWebChromeClient(new WebChromeClient() {
                @Override
                public boolean onJsAlert(WebView view, String url, String message, JsResult result) {
                    AlertDialog dialog = new AlertDialog.Builder(ActivityMoMoWebView.this)
                            .setTitle(url)
                            .setMessage(message)
                            .setOnCancelListener(new DialogInterface.OnCancelListener() {
                                @Override
                                public void onCancel(DialogInterface dialog) {
                                    //Log.d("TEST_CANCEL", "OK");
                                    if(dialog != null)
                                        dialog.dismiss();
                                }
                            })
                            .setPositiveButton(android.R.string.ok,new DialogInterface.OnClickListener()
                            {
                                public void onClick(DialogInterface dialog, int which)
                                {
                                    dialog.cancel();
                                }
                            })
                            .create();
                    if(Build.VERSION.SDK_INT > 19){//Android 6
                        dialog.getWindow().setType(WindowManager.LayoutParams.TYPE_APPLICATION_PANEL);
                    }else{
                        dialog.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT);
                    }
                    dialog.show();
                    return false;
                }
            });
        }else{
            webView.setWebChromeClient(new WebChromeClient());
        }
        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setDomStorageEnabled(true);
        webSettings.setAppCacheEnabled(true);
        webSettings.setAllowFileAccessFromFileURLs(true);
        webSettings.setAllowUniversalAccessFromFileURLs(true);
        webSettings.setDatabaseEnabled(true);
        webView.clearCache(true);
        webView.clearHistory();
        webView.setWebViewClient(new myWebViewClient());
        webView.requestFocus();
        webView.loadUrl(webURL);

//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
//         This line enable webview inspect from chrome while debugging.
//         open chrome -> go to "chrome://inspect" -> connect your device and debug.
//            webView.setWebContentsDebuggingEnabled(true);
//        }
    }


    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN)
    @Override
    protected void onResume() {
        super.onResume();
    }

    String urlTemp = "";
    String happyStyle = "";
    public class myWebViewClient extends WebViewClient {
        @Override
        public void onPageFinished(final WebView view, final String url) {
            MoMoLoading.hideLoading(ActivityMoMoWebView.this);
            try{
                super.onPageFinished(view, url);
            }catch(Exception e){
                e.printStackTrace();
            }

        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            // TODO Auto-generated method stub
            super.onPageStarted(view, url, favicon);
            MoMoLoading.showLoading(ActivityMoMoWebView.this);


            if(!url.startsWith("http") && url.contains("://") && !url.contains("market://") &&  !url.contains("close://")){
                webViewMapBank.loadUrl("javascript:( function () { var resultSrc = document.getElementById(\"image\").getAttribute(\"src\"); window.HTMLOUT.someCallback(resultSrc); } ) ()");

                String orginalUrl = "";

                JSONObject jsonParam = getParamFromUrl(url);
                if (jsonParam.length()>0){
                    try {
                        orginalUrl = (String) jsonParam.get("bankUrl");
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                    try {
                        urlTemp = (String) jsonParam.get("bankScript");
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                }else
                {
                    ArrayList<String>  arrParam = handleUrlCallbackBrowse(url);
                    if (arrParam.size() > 1 ){
                        orginalUrl = (String)arrParam.get(0);
                        urlTemp = (String)arrParam.get(1);
                    }

                }
                Log.d( "SDK Redirect IBanking ", orginalUrl);

                isLoadBank = true;
                webView.setVisibility(View.GONE);
                ll_progressbar_circle.setVisibility(View.VISIBLE);
                webViewMapBank.setVisibility(View.VISIBLE);
                imgBack.setVisibility(View.VISIBLE);
                imgClose.setVisibility(View.GONE);

                WebSettings webSettings = webViewMapBank.getSettings();
                webSettings.setJavaScriptEnabled(true);
                webSettings.setDomStorageEnabled(true);
                webSettings.setAppCacheEnabled(true);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                    webSettings.setAllowFileAccessFromFileURLs(true);
                    webSettings.setAllowUniversalAccessFromFileURLs(true);
                }

                webSettings.setDatabaseEnabled(true);
                webViewMapBank.clearCache(false);
                webViewMapBank.clearHistory();
                //webViewMapBank.setWebViewClient(new myWebViewClientAddScript());

                webViewMapBank.setWebViewClient(new WebViewClient() {


                    @Override
                    public void onPageStarted(
                            WebView view, String url, Bitmap favicon) {
                        super.onPageStarted(view, url, favicon);
                        ll_progressbar_circle.setVisibility(View.VISIBLE);


                        if(url.startsWith("close://")){
                            //todo
                            isLoadBank = false;
                            handleUrlCallback(url);
                            return;
                        }
                        else  if (url.startsWith("market://")){
                            startActivity(new Intent("android.intent.action.VIEW", Uri.parse(url)));
                            return;

                        }

                        Uri uri = Uri.parse(url);
                        if(tvTitle != null)
                            tvTitle.setText(uri.getScheme()+"://"+uri.getHost());

                        //SHOW LOADING IF IT ISNT ALREADY VISIBLE
                    }

                    @Override
                    public void onPageFinished(WebView view, String url) {
                        if (happyStyle.length() > 0 ){
                            //Load cached
                            view.loadUrl("javascript:(function() {" + happyStyle +"})()");
                            ll_progressbar_circle.setVisibility(View.GONE);
                        }
                        else{
                            if (urlTemp.startsWith("http")) {
                                ll_progressbar_circle.setVisibility(View.VISIBLE);
                                new ClientHttpAsyncTaskBack(ActivityMoMoWebView.this, urlTemp, view).execute();
                            }
                            else{
                                ll_progressbar_circle.setVisibility(View.GONE);
                            }
                        }
                        try{
                            super.onPageFinished(view, url);
                        }catch(Exception e){
                            e.printStackTrace();
                        }
                    }
                });
                webViewMapBank.requestFocus();
                webViewMapBank.loadUrl(orginalUrl);
            }
            else if(url.contains("payment.momo.vn/callbacksdk") || url.startsWith("close://")){
                //todo
                isLoadBank = false;
                handleUrlCallback(url);
            }
            else  if (url.startsWith("market://")){
                startActivity(new Intent("android.intent.action.VIEW", Uri.parse(url)));

            }

            Uri uri = Uri.parse(url);
            if(tvTitle != null)
                tvTitle.setText(uri.getScheme()+"://"+uri.getHost());

        }

        /*
        @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN)
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            // TODO Auto-generated method stub
            view.setVisibility(View.VISIBLE);
            urlTemp = "";
            happyStyle = "";
            if(!url.startsWith("http") && url.contains("://") && !url.contains("market://") &&  !url.contains("close://")){
                webViewMapBank.loadUrl("javascript:( function () { var resultSrc = document.getElementById(\"image\").getAttribute(\"src\"); window.HTMLOUT.someCallback(resultSrc); } ) ()");


                ArrayList<String>  arrParam = handleUrlCallbackBrowse(url);

                String orginalUrl = "";

                if (arrParam.size() > 1 ){
                    orginalUrl = (String)arrParam.get(0);
                    urlTemp = (String)arrParam.get(1);
                }

                isLoadBank = true;
                webView.setVisibility(View.GONE);
                ll_progressbar_circle.setVisibility(View.VISIBLE);
                webViewMapBank.setVisibility(View.VISIBLE);
                imgBack.setVisibility(View.VISIBLE);
                imgClose.setVisibility(View.GONE);

                WebSettings webSettings = webViewMapBank.getSettings();
                webSettings.setJavaScriptEnabled(true);
                webSettings.setDomStorageEnabled(true);
                webSettings.setAppCacheEnabled(true);
                webSettings.setAllowFileAccessFromFileURLs(true);
                webSettings.setAllowUniversalAccessFromFileURLs(true);
                webSettings.setDatabaseEnabled(true);
                webViewMapBank.clearCache(true);
                webViewMapBank.clearHistory();
                //webViewMapBank.setWebViewClient(new myWebViewClientAddScript());

                webViewMapBank.setWebViewClient(new WebViewClient() {


                    @Override
                    public void onPageStarted(
                            WebView view, String url, Bitmap favicon) {
                        super.onPageStarted(view, url, favicon);

                        //SHOW LOADING IF IT ISNT ALREADY VISIBLE
                    }

                    @Override
                    public void onPageFinished(WebView view, String url) {
                        webViewMapBank.loadUrl("javascript:(function() {" +
                                "var parent = document.getElementsByTagName('head').item(0);" +
                                "var script = document.createElement('script');" +
                                "script.type = 'text/javascript';" +
                                // Tell the browser to BASE64-decode the string into your script !!!
                                "script.innerHTML = window.atob('var href=window.location.href,return_url=\"https://app.momo.vn/icon/momo_app_v2/mapvi/success.html\";if(\"https://www.vietcombank.com.vn/IBanking2015\"==href||\"https://www.vietcombank.com.vn/IBanking2015/\"==href||href.length>70&&href.length<90)for(var array=[],links=document.getElementsByTagName(\"a\"),i=0;i<links.length;i++)links[i].href.indexOf(\"dangkysudungmoi\")>10&&(window.location.href=links[i].href);else{if(href.indexOf(\"/vidientu/dangkysudungmoi\")>10){var delay=3e3;setInterval(function(){var a=document.getElementById(\"lblketqua\");a&&a.innerHTML.length>30&&(window.location.href=return_url)},delay)}if(href.indexOf(\"/vidientu/ngungsudung\")>10){var delay=3e3;setInterval(function(){var a=document.getElementById(\"lblketqua\");a&&a.innerHTML.length>80&&(window.location.href=return_url)},delay)}};');" +
                                "parent.appendChild(script)" +
                                "})()");
                    }
                });
                webViewMapBank.requestFocus();
                webViewMapBank.loadUrl(orginalUrl);
            }
            else if(url.contains("payment.momo.vn/callbacksdk") || url.startsWith("close://")){
                //todo
                isLoadBank = false;
                handleUrlCallback(url);
            }
            else  if (url.startsWith("market://")){
                startActivity(new Intent("android.intent.action.VIEW", Uri.parse(url)));

            }
            return true;
        }
        */
        @Override
        public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {

        }
        @Override
        public void doUpdateVisitedHistory(WebView view, String url, boolean isReload) {
            super.doUpdateVisitedHistory(view, url, isReload);
        }

    }

    public class myWebViewClientAddScript extends WebViewClient {

        @Override
        public void onPageFinished(final WebView view, final String url) {
            if(isLoadBank && !urlTemp.equals("")){
                isLoadBank = false;

                if (happyStyle.length() > 0 ){

                    if (urlTemp.length() > 0){
                        view.loadUrl("javascript:setTimeout(test(), 300)");
                    }
                    //Load cached
                    view.loadUrl("javascript:(function() {" + happyStyle +"})()");

                    ll_progressbar_circle.setVisibility(View.GONE);
                }
                else{
                    ll_progressbar_circle.setVisibility(View.VISIBLE);
                    new ClientHttpAsyncTaskBack(ActivityMoMoWebView.this, urlTemp, view).execute();
                }

            }
            try{
                super.onPageFinished(view, url);
            }catch(Exception e){
                e.printStackTrace();
            }
        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            // TODO Auto-generated method stub
            super.onPageStarted(view, url, favicon);
//            if(!url.startsWith("http") && url.contains("://")){
//                return;
//            }
            ll_progressbar_circle.setVisibility(View.VISIBLE);
            Uri uri = Uri.parse(url);
            if(tvTitle != null)
                tvTitle.setText(uri.getScheme()+"://"+uri.getHost());

            if(url.startsWith("close://")){
                //todo
                isLoadBank = false;
                handleUrlCallback(url);
                ll_progressbar_circle.setVisibility(View.GONE);
                return;
            }
            else  if (url.startsWith("market://")){
                startActivity(new Intent("android.intent.action.VIEW", Uri.parse(url)));
                ll_progressbar_circle.setVisibility(View.GONE);
                return;

            }

        }

        @Override
        public void doUpdateVisitedHistory(WebView view, String url, boolean isReload) {
            super.doUpdateVisitedHistory(view, url, isReload);
        }

    }

    public class ClientHttpAsyncTaskBack extends AsyncTask<Void, Void, String> {
        private Activity activity;
        private String urlEndPoint;
        WebView wbBank;

        public ClientHttpAsyncTaskBack(Activity activity, String urlEndPoint, WebView wbBank) {
            this.activity = activity;
            this.urlEndPoint = urlEndPoint;
            this.wbBank = wbBank;
        }

        protected void onPreExecute() {
            super.onPreExecute();

        }

        protected String doInBackground(Void... params) {
            boolean passed = true;
            String fullString = "";
            try {

                URL url = new URL(this.urlEndPoint);
                //BufferedReader reader = new BufferedReader(new InputStreamReader(url.openStream()));
                BufferedReader reader = new BufferedReader(new InputStreamReader(url.openStream(),"UTF-8"));
                String line;
                while ((line = reader.readLine()) != null) {
                    fullString += line;
                }
                reader.close();
                //Document doc = db.parse(new InputSource(new InputStreamReader(in, "UTF-8")));
            } catch (Exception var7) {
                passed = false;
                Log.d("ERROR REQUEST TO SERVER", var7.toString());
            }

            if (!passed || fullString.length() == 0){
                try {
                    URL obj = new URL(this.urlEndPoint);
                    HttpURLConnection con = (HttpURLConnection) obj.openConnection();
                    con.setRequestMethod("GET");
                    int responseCode = con.getResponseCode();
                    System.out.println("\nSending 'GET' request to URL : " + this.urlEndPoint);
                    System.out.println("Response Code : " + responseCode);

                    BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
                    String inputLine;
                    StringBuffer response = new StringBuffer();

                    while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine);
                    }
                    in.close();

                    fullString =  response.toString();
                    //print result
                    //System.out.println(response.toString());
                }
                catch (SSLException e){
                    e.printStackTrace();
                }
                catch (Exception e) {
                    e.printStackTrace();
                }
            }

            return fullString;
        }

        protected void onPostExecute(String result) {
            super.onPostExecute(result);

            happyStyle =  result;
            //Log.d("onPostExecute ", result);
            this.wbBank.loadUrl("javascript:(function() {" + happyStyle +"})()");

            ll_progressbar_circle.setVisibility(View.GONE);

        }
    }

    private ArrayList<String> handleUrlCallbackBrowse(String mUrl) {
        ArrayList<String> arrData = new ArrayList<>();
        if(mUrl != null &&  mUrl.contains("&")){
            for (String param : mUrl.split("&")) {
                try{
                    if(param.contains("=")){
                        String valueParam = param.substring(param.indexOf("=") + 1);
                        arrData.add(valueParam);
                    }
                }catch (Exception e){
                    e.printStackTrace();
                }

            }
        }
        return arrData;
    }

    private JSONObject getParamFromUrl(String mUrl) {
        JSONObject jsonData = new JSONObject();
        //
        try{
            Uri uri = Uri.parse(mUrl);
            String query = uri.getQuery();

            if(mUrl != null &&  query.contains("&")){
                for (String param : query.split("&")) {
                    try{
                        if(param.contains("=")){
                            String key = param.substring(0,param.indexOf("="));
                            String valueParam = param.substring(param.indexOf("=") + 1);
                            jsonData.put(key, valueParam);
                        }
                    }catch (Exception e){
                        e.printStackTrace();
                    }

                }
            }
        }
        catch (Exception e){
            e.printStackTrace();
        }

        return jsonData;
    }

    private void handleUrlCallback(String mUrl){
        Intent intent = new Intent();
        String[] dataUrl = null;
        if(mUrl.contains("callbacksdk?")){
            dataUrl = mUrl.split("callbacksdk\\?");
        }
        if(dataUrl != null && dataUrl.length == 2 && dataUrl[1].contains("&")){
            for (String param : dataUrl[1].split("&")) {
                try{
                    String keyParam =  param.substring(0, param.indexOf("="));
                    String valueParam = param.substring(param.indexOf("=") + 1);
                    if(keyParam != null && valueParam != null && valueParam.length() > 0){
                        if(keyParam.equals("status")){
                            intent.putExtra(keyParam, Integer.valueOf(valueParam));
                            dataExtra.putInt(keyParam, Integer.valueOf(valueParam));
                        }else{
                            //Log.d("dataweb ", valueParam);
                            if(keyParam.equals(MoMoParameterNamePayment.EXTRA_DATA) && valueParam != null){
                                valueParam = MoMoUtils.decodeString(valueParam);
                            }
                            if(keyParam.equals(MoMoParameterNamePayment.EXTRA) && valueParam != null){
                                valueParam = MoMoUtils.decodeString(valueParam);
                            }
                            dataExtra.putString(keyParam, valueParam);
                        }
                    }
                }catch (Exception e){
                    e.printStackTrace();
                }

            }
        }
        dataExtra.putString("url", webURL);
        intent.putExtras(dataExtra);
        ActivityMoMoWebView.this.setResult(Activity.RESULT_OK, intent);
        ActivityMoMoWebView.this.finish();
    }

}
