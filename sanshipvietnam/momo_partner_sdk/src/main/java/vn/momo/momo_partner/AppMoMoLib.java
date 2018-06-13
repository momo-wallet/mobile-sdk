package vn.momo.momo_partner;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.widget.Toast;
import org.json.JSONException;
import org.json.JSONObject;
import java.util.Iterator;
import java.util.Map;
import vn.momo.momo_partner.activity.ActivityMoMoWebView;
import vn.momo.momo_partner.utils.MoMoConfig;
import vn.momo.momo_partner.utils.MoMoUtils;

/**
 * Created by hungdo on 5/8/17.
 * Updated by LanhLuu on Sep 9, /2017
 */

public class AppMoMoLib{

    private static AppMoMoLib instance;
    public static AppMoMoLib getInstance(){
        if(instance == null)
            instance = new AppMoMoLib();
        return instance;
    }
    //action app momo ex: mapping, payment
    String action = "";
    //environment app momo default debug
    int environment = 0;
    //action type app momo ex: link, get token
    String actionType = "";
    //code request in app momo
    public int REQUEST_CODE_MOMO = 1000;

    //todo set action momo
    public String setAction(Enum _action){
        if(_action.equals(ACTION.MAP)){
            action = MoMoConfig.ACTION_SDK;
        }else{
            action = MoMoConfig.ACTION_PAYMENT;
        }
        return action;
    }
    
    //todo set action type
    public String setActionType(Enum _actionType){
        if(_actionType.equals(ACTION_TYPE.GET_TOKEN)){
            actionType = MoMoConfig.ACTION_TYPE_GET_TOKEN;
        }else {
            actionType = MoMoConfig.ACTION_TYPE_LINK;
        }
        return actionType;
    }

    //todo set environment momo
    public int setEnvironment(Enum _environment){
        if(_environment.equals(ENVIRONMENT.DEBUG)){
            environment = MoMoConfig.ENVIRONMENT_DEBUG;
        }else if(_environment.equals(ENVIRONMENT.DEVELOPMENT)){
            environment = MoMoConfig.ENVIRONMENT_DEVELOPER;
        }else if(_environment.equals(ENVIRONMENT.PRODUCTION)){
            environment = MoMoConfig.ENVIRONMENT_PRODUCTION;
        }else{
            environment = MoMoConfig.ENVIRONMENT_DEBUG;
        }
        return environment;
    }

    //todo request momo
    public void requestMoMoCallBack(final Activity activity, Map<String, Object> hashMap) {
        if(action.equals("")){
            Toast.makeText(activity, "Please init AppMoMoLib.getInstance().setAction", Toast.LENGTH_LONG).show();
            return;
        }

        if(hashMap == null){
            Toast.makeText(activity, "Please set data after request", Toast.LENGTH_LONG).show();
            return;
        }
        if(actionType.equals("")){
            Toast.makeText(activity, "Please init AppMoMoLib.getInstance().setActionType", Toast.LENGTH_LONG).show();
            return;
        }else{
            if((action.equals(MoMoConfig.ACTION_SDK) && !actionType.equals(MoMoConfig.ACTION_TYPE_LINK)) ||
                    (action.equals(MoMoConfig.ACTION_PAYMENT) && !actionType.equals(MoMoConfig.ACTION_TYPE_GET_TOKEN))){
                Toast.makeText(activity, "Please set action type and action", Toast.LENGTH_LONG).show();
                return;
            }
        }
        try{
            final String packageClass;
            String MoMoWebSDK = null;
            switch (environment){
                case MoMoConfig.ENVIRONMENT_DEBUG://environment debug
                    packageClass = MoMoConfig.MOMO_APP_PAKAGE_CLASS_DEBUG;
                    break;
                case MoMoConfig.ENVIRONMENT_DEVELOPER://environment developer
                    packageClass = MoMoConfig.MOMO_APP_PAKAGE_CLASS_DEVELOPER;
                    break;
                case MoMoConfig.ENVIRONMENT_PRODUCTION://environment production
                    packageClass = MoMoConfig.MOMO_APP_PAKAGE_CLASS_PRODUCTION;
                    break;
                default:
                    packageClass = MoMoConfig.MOMO_APP_PAKAGE_CLASS_DEBUG;
                    break;
            }
            final Intent[] intent = {new Intent()};

            String appName;
            ApplicationInfo applicationInfo = activity.getApplicationContext().getApplicationInfo();
            int stringId = applicationInfo.labelRes;
            activity.getPackageName();
            appName = (stringId == 0) ? applicationInfo.nonLocalizedLabel.toString() : activity.getApplicationContext().getString(stringId);
            String  packageName = activity.getPackageName();
            //put data to json object
            final JSONObject jsonData = new JSONObject();
            Iterator iterator = hashMap.keySet().iterator();
            try {
                while(iterator.hasNext()) {
                    String key=(String)iterator.next();
                    Object value = hashMap.get(key);
                    if(key.equals(MoMoParameterNamePayment.EXTRA_DATA) && value != null){
                        value = MoMoUtils.encodeString(value.toString());
                    }
                    if(key.equals(MoMoParameterNamePayment.EXTRA) && value != null){
                        value = MoMoUtils.encodeString(value.toString());
                    }
                    if(key.equals(MoMoParameterNamePayment.SUBMIT_URL_WEB) && value != null){
                        MoMoWebSDK = value.toString();
                    }
                    jsonData.put(key, value);
                }

            } catch (JSONException e) {
                e.printStackTrace();
            }
            jsonData.put("sdkversion", BuildConfig.VERSION_NAME);
            jsonData.put("clientIp", MoMoUtils.getIPAddress(true));
            jsonData.put("appname",appName);
            jsonData.put("packagename",packageName);
            jsonData.put("action", actionType);
            jsonData.put("clientos", "Android_" + MoMoUtils.getDeviceName() + "_"+MoMoUtils.getDeviceSoftwareVersion());

            if(appInstalledOrNot(activity,packageClass)) {
                intent[0].setAction(action);
                intent[0].putExtra("JSON_PARAM", jsonData.toString());
                activity.startActivityForResult(intent[0], REQUEST_CODE_MOMO);
            }else {
                //call web payment
                /*
                if(MoMoWebSDK == null || MoMoWebSDK.equals("")){
                    Toast.makeText(activity, "Please input request URL", Toast.LENGTH_LONG).show();
                    return;
                }
                if(action.equals(MoMoConfig.ACTION_PAYMENT)){
                    final String finalMoMoWebSDK = MoMoWebSDK;
                    (new ClientHttpAsyncTask(activity, new ClientHttpAsyncTask.RequestToServerListener() {
                        @Override
                        public void receiveResultFromServer(String param) {
                            handleWebView(activity, param, packageClass, jsonData.toString(), finalMoMoWebSDK);
                        }
                    }, jsonData.toString(), MoMoWebSDK, true)).executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR);
                }else{
                    //call download app
                    handleCallGooglePlay(activity, packageClass);
                } */
                handleCallGooglePlay(activity, MoMoConfig.MOMO_APP_PAKAGE_STORE_DOWNLOAD);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    //todo check is momo exits
    private boolean appInstalledOrNot (Activity mActivity, String uri) {
        PackageManager pm = mActivity.getPackageManager();
        boolean app_installed = false;
        try {
            pm.getPackageInfo(uri, PackageManager.GET_ACTIVITIES);
            app_installed = true;
        } catch (PackageManager.NameNotFoundException e) {
        }
        return app_installed;
    }

    private void handleCallGooglePlay(Activity mActivity, String packageClass){
        try {
            mActivity.startActivity(new Intent("android.intent.action.VIEW", Uri.parse("market://details?id="+packageClass)));
        } catch (Exception var4) {
            mActivity.startActivity(new Intent("android.intent.action.VIEW", Uri.parse("http://play.google.com/store/apps/details?id=" +MoMoConfig.MOMO_APP_PAKAGE_CLASS_PRODUCTION)));
        }
    }

    private void handleWebView(Activity mActivity, String param, String packageClass, String jsonData, String urlRequest){
        try {
            JSONObject obj = new JSONObject(param);
            if(obj.has("code") && obj.getInt("code") == 0 && obj.has("message") && obj.getString("message").equals("Success") && obj.has("url") && !obj.getString("url").equals("")){
                Intent intent = new Intent(mActivity, ActivityMoMoWebView.class);
                Bundle dataIntent = new Bundle();
                Iterator<String> iter = obj.keys();
                while (iter.hasNext()) {
                    String key = iter.next();
                    try {
                        Object value = obj.get(key);
                        if(!key.equals("code") && !key.equals("message") && !key.equals("url") && value != null){
                            intent.putExtra(key, value.toString());
                        }
                    } catch (JSONException e) {
                        // Something went wrong!
                    }
                }
                intent.putExtra(MoMoConfig.INTENT_URL_WEB, obj.getString("url"));
                intent.putExtra(MoMoConfig.INTENT_JSON_DATA, jsonData);
                intent.putExtra(MoMoConfig.INTENT_URL_REQUEST, urlRequest);
                mActivity.startActivityForResult(intent, REQUEST_CODE_MOMO);
            }else if(obj.has("code") && obj.getInt("code") == 9696){
                //todo call google play
                handleCallGooglePlay(mActivity, packageClass);

            }else{
                Intent intent = new Intent();
                intent.putExtra("status", -1);
                intent.putExtra("message", "Service is not available");
                mActivity.setResult(Activity.RESULT_OK, intent);
            }
        } catch (JSONException e) {
            e.printStackTrace();
            Intent intent = new Intent();
            intent.putExtra("status", -1);
            intent.putExtra("message", e.getMessage());
            mActivity.setResult(Activity.RESULT_OK, intent);
        }
    }
    //todo action request
    public enum ACTION{
        MAP,
        PAYMENT
    }

    //todo enum choose environment
    public enum ENVIRONMENT{
        DEBUG,
        DEVELOPMENT,
        PRODUCTION
    }

    //todo enum action type
    public enum ACTION_TYPE{
        GET_TOKEN,
        LINK
    }

}
