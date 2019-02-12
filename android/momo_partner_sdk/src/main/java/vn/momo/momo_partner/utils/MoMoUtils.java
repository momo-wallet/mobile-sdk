package vn.momo.momo_partner.utils;

import android.os.Build;
import android.util.Base64;
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
        return "0.0.0.0";
    }
    
    public static String encryptRSA(String source, String publicKey) {
        byte[] publicKeyByte = Base64.decode(publicKey, 2);
        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(publicKeyByte);
        String encrypted = "";
        try {
            KeyFactory e = KeyFactory.getInstance("RSA");
            Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
            cipher.init(1, e.generatePublic(keySpec));
            encrypted = Base64.encodeToString(cipher.doFinal(source.getBytes()), 2);
        } catch (NoSuchAlgorithmException var7) {
            var7.printStackTrace();
        } catch (NoSuchPaddingException var8) {
            var8.printStackTrace();
        } catch (InvalidKeySpecException var9) {
            var9.printStackTrace();
        } catch (InvalidKeyException var10) {
            var10.printStackTrace();
        } catch (BadPaddingException var11) {
            var11.printStackTrace();
        } catch (IllegalBlockSizeException var12) {
            var12.printStackTrace();
        }
        return encrypted;
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
