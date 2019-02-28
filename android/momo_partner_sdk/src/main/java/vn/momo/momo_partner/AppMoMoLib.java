package vn.momo.momo_partner;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;
import java.util.Map;

import vn.momo.momo_partner.utils.MoMoConfig;
import vn.momo.momo_partner.utils.MoMoUtils;

/**
 * Created by hungdo on 5/8/17.
 * Updated by LanhLuu on Sep 9, /2017
 */

public class AppMoMoLib {

    private static AppMoMoLib instance;
    //code request in app momo
    public int REQUEST_CODE_MOMO = 1000;
    //action app momo ex: mapping, payment
    String action = "";
    //environment app momo default debug
    int environment = 0;
    //action type app momo ex: link, get token
    String actionType = "";
    JSONObject dataRequest = null;
    String token = "";
    public static AppMoMoLib getInstance() {
        if (instance == null)
            instance = new AppMoMoLib();
        return instance;
    }

    //todo set action momo
    public String setAction(Enum _action) {
        if (_action.equals(ACTION.MAP)) {
            action = MoMoConfig.ACTION_SDK;
        } else {
            action = MoMoConfig.ACTION_PAYMENT;
        }
        return action;
    }

    //todo set action type
    public String setActionType(Enum _actionType) {
        if (_actionType.equals(ACTION_TYPE.GET_TOKEN)) {
            actionType = MoMoConfig.ACTION_TYPE_GET_TOKEN;
        } else {
            actionType = MoMoConfig.ACTION_TYPE_LINK;
        }
        return actionType;
    }

    //todo set environment momo
    public int setEnvironment(Enum _environment) {
        if (_environment.equals(ENVIRONMENT.DEBUG)) {
            environment = MoMoConfig.ENVIRONMENT_DEBUG;
        } else if (_environment.equals(ENVIRONMENT.DEVELOPMENT)) {
            environment = MoMoConfig.ENVIRONMENT_DEVELOPER;
        } else if (_environment.equals(ENVIRONMENT.PRODUCTION)) {
            environment = MoMoConfig.ENVIRONMENT_PRODUCTION;
        } else {
            environment = MoMoConfig.ENVIRONMENT_DEBUG;
        }
        return environment;
    }

    //todo set token momo
    public String setToken(String _token) {
        token =  _token;
        return token;
    }

    //todo request momo
    public void requestMoMoCallBack(final Activity activity, Map<String, Object> hashMap) {
        JSONObject jsonData = new JSONObject();
        Iterator iterator = hashMap.keySet().iterator();
        try {
            while (iterator.hasNext()) {
                String key = (String) iterator.next();
                Object value = hashMap.get(key);
                if (key.equals(MoMoParameterNamePayment.EXTRA_DATA) && value != null) {
                    value = MoMoUtils.encodeString(value.toString());
                }
                if (key.equals(MoMoParameterNamePayment.EXTRA) && value != null) {
                    value = MoMoUtils.encodeString(value.toString());
                }
                jsonData.put(key, value);
            }

        } catch (JSONException e) {
            submitBehaviorData("deeplink_invalid_format", jsonData, activity);
            e.printStackTrace();
        }
        dataRequest = jsonData;
        submitBehaviorData("click_checkout_btn", jsonData, activity);
        if (action.equals("")) {
            Toast.makeText(activity, "Please init AppMoMoLib.getInstance().setAction", Toast.LENGTH_LONG).show();
            submitBehaviorData("deeplink_invalid_format", jsonData, activity);
            return;
        }

        if (hashMap == null) {
            Toast.makeText(activity, "Please set data after request", Toast.LENGTH_LONG).show();
            submitBehaviorData("deeplink_invalid_format", jsonData, activity);
            return;
        }
        if (actionType.equals("")) {
            submitBehaviorData("deeplink_invalid_format", jsonData, activity);
            Toast.makeText(activity, "Please init AppMoMoLib.getInstance().setActionType", Toast.LENGTH_LONG).show();
            return;
        } else {
            if ((action.equals(MoMoConfig.ACTION_SDK) && !actionType.equals(MoMoConfig.ACTION_TYPE_LINK)) ||
                    (action.equals(MoMoConfig.ACTION_PAYMENT) && !actionType.equals(MoMoConfig.ACTION_TYPE_GET_TOKEN))) {
                submitBehaviorData("deeplink_invalid_format", jsonData, activity);
                Toast.makeText(activity, "Please set action type and action", Toast.LENGTH_LONG).show();
                return;
            }
        }
        try {
            String packageClass;
            switch (environment) {
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

            Intent intent = new Intent();
            String appName;
            ApplicationInfo applicationInfo = activity.getApplicationContext().getApplicationInfo();
            int stringId = applicationInfo.labelRes;
            appName = (stringId == 0) ? applicationInfo.nonLocalizedLabel.toString() : activity.getApplicationContext().getString(stringId);

            //put data to json object
            jsonData.put("sdkversion", BuildConfig.VERSION_NAME);
            jsonData.put("clientIp", MoMoUtils.getIPAddress(true));
            jsonData.put("appname", appName);
            jsonData.put("packagename", activity.getPackageName());
            jsonData.put("action", actionType);
            jsonData.put("clientos", "Android_" + MoMoUtils.getDeviceName() + "_" + MoMoUtils.getDeviceSoftwareVersion());

            if (appInstalledOrNot(activity, packageClass)) {
                intent.setAction(action);
                intent.putExtra("JSON_PARAM", jsonData.toString());
                activity.startActivityForResult(intent, REQUEST_CODE_MOMO);
                submitBehaviorData("open_app_momo_success", jsonData, activity);
            } else {
                handleCallGooglePlay(activity, MoMoConfig.MOMO_APP_PAKAGE_STORE_DOWNLOAD);
                submitBehaviorData("open_app_store", jsonData, activity);
            }
        } catch (Exception e) {
            submitBehaviorData("open_app_momo_fail", jsonData, activity);
            e.printStackTrace();
        }
    }


    //todo check is momo exits
    private boolean appInstalledOrNot(Activity mActivity, String uri) {
        PackageManager pm = mActivity.getPackageManager();
        boolean app_installed = false;
        try {
            pm.getPackageInfo(uri, PackageManager.GET_ACTIVITIES);
            app_installed = true;
        } catch (PackageManager.NameNotFoundException e) {
        }
        return app_installed;
    }

    private void handleCallGooglePlay(Activity mActivity, String packageClass) {
        try {
            mActivity.startActivity(new Intent("android.intent.action.VIEW", Uri.parse("market://details?id=" + packageClass)));
        } catch (Exception var4) {
            mActivity.startActivity(new Intent("android.intent.action.VIEW", Uri.parse("http://play.google.com/store/apps/details?id=" + MoMoConfig.MOMO_APP_PAKAGE_CLASS_PRODUCTION)));
        }
    }

    public void trackEventResult(Activity mActivity, Intent data) {
        JSONObject jsonObject = new JSONObject();
        if(dataRequest != null){
            jsonObject = dataRequest;
        }
        String eventName = "user_cancel_payment";
        if (data != null) {
            Bundle bundle = data.getExtras();
            if (bundle != null) {
                int status = bundle.getInt("status");
                if (status == 0) {
                    eventName = "callback_successed";
                } else if (status == 5) {
                    eventName = "timeout_payment";
                }
            }
        }
        submitBehaviorData(eventName, jsonObject, mActivity);
    }

    //Tracking event
    private void submitBehaviorData(String eventName, JSONObject params, Activity mActivity) {
        if(!token.equals("")){
            JSONObject jsonObject = new JSONObject();
            try {
                jsonObject.put("event", eventName);
                jsonObject.put("sdkversion", "1.1.8");
                jsonObject.put("appId", mActivity.getPackageName());
                jsonObject.put("client", "sdk_mobile");
                if (params.has("billId")) {
                    jsonObject.put("billId", params.getString("billId"));
                }
                if (params.has("orderId")) {
                    jsonObject.put("billId", params.getString("orderId"));
                }
                if (params.has("username")) {
                    jsonObject.put("user", params.getString("username"));
                }
                if (params.has("partnerCode")) {
                    jsonObject.put("partnerCode", params.getString("partnerCode"));
                }
                if (params.has("merchantcode")) {
                    jsonObject.put("partnerCode", params.getString("merchantcode"));
                }
                jsonObject.put("description", "Android " + MoMoUtils.getDeviceName() + " " + MoMoUtils.getDeviceSoftwareVersion());
                jsonObject.put("extraData", params.toString());
            } catch (JSONException e) {
                e.printStackTrace();
            }
            new ClientHttpAsyncTask(jsonObject.toString(), token).executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR);
        }
    }

    //todo action request
    public enum ACTION {
        MAP,
        PAYMENT
    }

    //todo enum choose environment
    public enum ENVIRONMENT {
        DEBUG,
        DEVELOPMENT,
        PRODUCTION
    }

    //todo enum action type
    public enum ACTION_TYPE {
        GET_TOKEN,
        LINK
    }

}
