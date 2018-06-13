package vn.momo.momo_partner.utils;

import android.os.Build;
import android.util.Base64;
import org.apache.http.conn.util.InetAddressUtils;

import java.io.UnsupportedEncodingException;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.X509EncodedKeySpec;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

/**
 * Created by hungdo on 5/8/17.
 */

public class MoMoUtils {
    public static String getIPAddress(boolean useIPv4) {
        try {
            ArrayList ex = Collections.list(NetworkInterface.getNetworkInterfaces());
            Iterator i$ = ex.iterator();
            while(i$.hasNext()) {
                NetworkInterface intf = (NetworkInterface)i$.next();
                ArrayList addrs = Collections.list(intf.getInetAddresses());
                Iterator i$1 = addrs.iterator();
                while(i$1.hasNext()) {
                    InetAddress addr = (InetAddress)i$1.next();
                    if(!addr.isLoopbackAddress()) {
                        String sAddr = addr.getHostAddress().toUpperCase();
                        boolean isIPv4 = InetAddressUtils.isIPv4Address(sAddr);
                        if(useIPv4) {
                            if(isIPv4) {
                                return sAddr;
                            }
                        } else if(!isIPv4) {
                            int delim = sAddr.indexOf(37);
                            return delim < 0?sAddr:sAddr.substring(0, delim);
                        }
                    }
                }
            }
        } catch (Exception var10) {

        }
        return "0.0.0.0";
    }

    public static String encodeString(String s) {
        byte[] data = new byte[0];

        try {
            data = s.getBytes("UTF-8");

        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } finally {
            String base64Encoded = Base64.encodeToString(data, Base64.DEFAULT);

            return base64Encoded;

        }
    }

    public static String decodeString(String encoded) {
        byte[] dataDec = Base64.decode(encoded, Base64.DEFAULT);
        String decodedString = "";
        try {

            decodedString = new String(dataDec, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();

        } finally {

            return decodedString;
        }
    }
    public static String getDeviceName() {
        String manufacturer = Build.MANUFACTURER;
        String model = Build.MODEL;
        if (model.startsWith(manufacturer)) {
            return capitalize(model);
        } else {
            return capitalize(manufacturer) + " " + model;
        }
    }

    public static String capitalize(String s) {
        if (s == null || s.length() == 0) {
            return "";
        }
        char first = s.charAt(0);
        if (Character.isUpperCase(first)) {
            return s;
        } else {
            return Character.toUpperCase(first) + s.substring(1);
        }
    }

    public static String getDeviceSoftwareVersion() {
        return Build.VERSION.SDK_INT+"";

    }
}
