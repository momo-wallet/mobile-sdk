/**
 * Created By Bao.Nguyen on Sep 24, 2015
 * Edited by Lanh.Luu,Hung.Do on 2/24/17.
 * https://github.com/lanhmomo/MoMoPaySDK
 */


package vn.momo.momo_partner;

import android.app.Activity;
import android.os.AsyncTask;
import android.util.Log;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.HttpURLConnection;
import java.net.URL;
import javax.net.ssl.HttpsURLConnection;
import vn.momo.momo_partner.utils.ClientProgressBar;
import vn.momo.momo_partner.utils.MoMoConfig;

public class ClientHttpAsyncTask extends AsyncTask<Void, Void, String> {
    private Activity activity;
    private ClientProgressBar progressBar;
    private RequestToServerListener listener;
    private String jsonParam = "";
    private String urlEndPoint = "";
    private boolean isShowProgresBar = false;


    public ClientHttpAsyncTask(Activity activity, RequestToServerListener listener, String jsonParam, String urlEndPoint, boolean isShowProgresBar) {
        this.activity = activity;
        this.listener = listener;
        this.jsonParam = jsonParam;
        this.urlEndPoint = urlEndPoint;
        this.isShowProgresBar = isShowProgresBar;
    }

    protected void onPreExecute() {
        super.onPreExecute();
        if(this.isShowProgresBar){
            if(this.progressBar == null) {
                this.progressBar = new ClientProgressBar();
            }
            Log.d("Đang thực hiện","");

            this.progressBar.showProgessDialog(this.activity, "Đang thực hiện");
            this.progressBar.forceDimissProgessDialog(MoMoConfig.MOMO_TIME_OUT);
            this.progressBar.setCancelable(true);
        }
    }

    protected String doInBackground(Void... params) {
        String response = "";
        try {
            URL url = new URL(this.urlEndPoint);
            HttpURLConnection httpURLConnection = (HttpURLConnection)url.openConnection();
            httpURLConnection.setDoOutput(true);
            httpURLConnection.setReadTimeout(MoMoConfig.MOMO_TIME_OUT);
            httpURLConnection.setConnectTimeout(MoMoConfig.MOMO_TIME_OUT);
            httpURLConnection.setRequestMethod("POST"); // here you are telling that it is a POST request, which can be changed into "PUT", "GET", "DELETE" etc.
            httpURLConnection.setRequestProperty("Content-Type", "application/json;charset=UTF-8"); // here you are setting the `Content-Type` for the data you are sending which is `application/json`
            httpURLConnection.connect();
            Writer writer = new BufferedWriter(new OutputStreamWriter(httpURLConnection.getOutputStream(), "UTF-8"));
            writer.write(this.jsonParam);
            writer.flush();
            writer.close();
            if (httpURLConnection.getResponseCode() == HttpsURLConnection.HTTP_OK) {
                response = readStream(httpURLConnection.getInputStream());
            }
            else {
                response="";
            }
            httpURLConnection.disconnect();
        } catch (Exception var7) {
            Log.d("ERROR REQUEST TO SERVER", var7.toString());
        }
        return response;
    }

    protected void onPostExecute(String result) {
        super.onPostExecute(result);
        if(this.isShowProgresBar){
            if(this.progressBar != null) {
                this.progressBar.dimissProgessDialog();
            }
        }

        Log.d("post result ",result);
        this.listener.receiveResultFromServer(result);
    }

    public interface RequestToServerListener {
        void receiveResultFromServer(String var1);
    }

    private String readStream(InputStream in) {
        BufferedReader reader = null;
        StringBuffer response = new StringBuffer();
        try {
            reader = new BufferedReader(new InputStreamReader(in));
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return response.toString();
    }
}
