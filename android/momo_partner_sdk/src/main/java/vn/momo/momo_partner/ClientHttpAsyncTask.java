/**
 * Created By Bao.Nguyen on Sep 24, 2015
 * Edited by Lanh.Luu,Hung.Do on 2/24/17.
 * https://github.com/lanhmomo/MoMoPaySDK
 */
package vn.momo.momo_partner;
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
import vn.momo.momo_partner.utils.MoMoConfig;

public class ClientHttpAsyncTask extends AsyncTask<Void, Void, String> {
    private String jsonParam;
    private String token;
    public ClientHttpAsyncTask(String _jsonParam, String _token) {
        jsonParam = _jsonParam;
        token = _token;
    }

    protected String doInBackground(Void... params) {
        String response = "";
        try {
            String urlTrack = BuildConfig.URL_TRACK_DEV;
            if(AppMoMoLib.getInstance().environment == MoMoConfig.ENVIRONMENT_PRODUCTION){
                urlTrack = BuildConfig.URL_TRACK;
            }
            URL url = new URL(urlTrack);
            HttpURLConnection httpURLConnection = (HttpURLConnection)url.openConnection();
            httpURLConnection.setDoOutput(true);
            httpURLConnection.setReadTimeout(MoMoConfig.MOMO_TIME_OUT);
            httpURLConnection.setConnectTimeout(MoMoConfig.MOMO_TIME_OUT);
            httpURLConnection.setRequestMethod("POST");
            httpURLConnection.setRequestProperty("Content-Type", "application/json");
            httpURLConnection.setRequestProperty("X-Authorization", "X-Token "+token);
            httpURLConnection.setRequestProperty("Accept-Encoding", "gzip");
            httpURLConnection.connect();
            Writer writer = new BufferedWriter(new OutputStreamWriter(httpURLConnection.getOutputStream(), "UTF-8"));
            writer.write(jsonParam);
            writer.flush();
            writer.close();
            int responseCode = httpURLConnection.getResponseCode();
            if (responseCode == HttpsURLConnection.HTTP_OK) {
                response = readStream(httpURLConnection.getInputStream());
            }
            httpURLConnection.disconnect();
        } catch (Exception var7) {
            Log.d("ERROR REQUEST TO SERVER", var7.toString());
        }
        return response;
    }

    protected void onPostExecute(String result) {
        super.onPostExecute(result);
        Log.d("post result ",result);
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
