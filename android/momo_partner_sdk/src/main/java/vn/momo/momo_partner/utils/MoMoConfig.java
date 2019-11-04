package vn.momo.momo_partner.utils;

/**
 * Created by hungdo on 5/8/17.
 */

public class MoMoConfig {
    public static final String MOMO_APP_PAKAGE_STORE_DOWNLOAD = "com.mservice.momotransfer";

    public static final String MOMO_APP_PAKAGE_CLASS_PRODUCTION = "com.mservice.momotransfer"; //production
    public static final String MOMO_APP_PAKAGE_CLASS_DEBUG = "com.mservice.debug";//debug
    public static final String MOMO_APP_PAKAGE_CLASS_DEVELOPER = "com.mservice";//dev

    public static final String ACTION_SDK = "com.android.momo.SDK";//action mapping
    public static final String ACTION_PAYMENT = "com.android.momo.PAYMENT";//action payment
    public static final int ENVIRONMENT_DEBUG = 0;//Debug
    public static final int ENVIRONMENT_DEVELOPER = 1;//developer
    public static final int ENVIRONMENT_PRODUCTION = 2;//production

    public static final String ACTION_TYPE_GET_TOKEN = "gettoken";//action mapping
    public static final String ACTION_TYPE_LINK = "link";//action payment
}
