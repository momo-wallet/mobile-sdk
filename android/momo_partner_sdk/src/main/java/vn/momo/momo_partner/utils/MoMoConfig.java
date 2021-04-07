package vn.momo.momo_partner.utils;

/**
 * Created by hungdo on 5/8/17.
 */

public class MoMoConfig {
    public static final String MOMO_APP_PAKAGE_STORE_DOWNLOAD = "com.mservice.momotransfer";

    public static final String MOMO_APP_PAKAGE_CLASS_PRODUCTION = "com.mservice.momotransfer"; //production
    public static final String MOMO_APP_PAKAGE_CLASS_DEBUG = "com.mservice.debug";//DEBUG MODE IS NO LONGER SUPPORTED 
    public static final String MOMO_APP_PAKAGE_CLASS_DEVELOPER = "vn.momo.platform.test";// App Test ver 3.0.12 or newest supported appid "vn.momo.platform.test", App Test ver 3.0.11 or lower using id "com.mservice";

    public static final String ACTION_SDK = "com.android.momo.SDK";//action mapping
    public static final String ACTION_PAYMENT = "com.android.momo.PAYMENT";//action payment
    public static final int ENVIRONMENT_DEBUG = 0;//Debug
    public static final int ENVIRONMENT_DEVELOPER = 1;//developer
    public static final int ENVIRONMENT_PRODUCTION = 2;//production

    public static final String ACTION_TYPE_GET_TOKEN = "gettoken";//action mapping
    public static final String ACTION_TYPE_LINK = "link";//action payment
}
