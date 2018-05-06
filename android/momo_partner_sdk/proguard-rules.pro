-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**
-keepclassmembers class * extends com.actionbarsherlock.ActionBarSherlock {
    <init>(android.app.Activity, int);
}

#action bar
-keep class android.support.v4.app.** { *; }
-keep interface android.support.v4.app.** { *; }
-keepattributes *Annotation*
-keep class android.support.annotation.** { *; }

#fb
-keepclassmembers class * implements java.io.Serializable{
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

#-keep class com.facebook.** { *; }
-keepattributes Signature

#org.apache external lib
-dontwarn org.apache.**

-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver

#-keep class * implements android.os.Parcelable.** {*;}

# The maps library uses custom Parcelables.  Use this rule (which is slightly
# broader than the standard recommended one) to avoid obfuscating them.
-keepclassmembers class * implements android.os.Parcelable {static *** CREATOR;}

#Bao - 29.10.15 - keep annotation JavascriptInterface - vu WebInApp (VEXERE) - BEGIN
#-keepclassmembers class fqcn.of.javascript.interface.for.webview{
#   public *;
#}
-keepclassmembers class * {
    @android.webkit.JavascriptInterface *;
}
#To�n - 16.9.15 - BEGIN
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
-dontwarn android.support.annotation.Nullable