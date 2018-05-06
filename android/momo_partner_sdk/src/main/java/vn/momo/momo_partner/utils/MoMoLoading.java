package vn.momo.momo_partner.utils;

import android.app.Activity;
import android.app.Dialog;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ProgressBar;
import android.widget.TextView;

import java.util.Timer;
import java.util.TimerTask;

import vn.momo.momo_partner.R;

public class MoMoLoading {

    public static Dialog dialogProcessBar;
    private static ProgressBar mprogressBar;
    private static TextView tv_process;



    public static void showLoading(final Activity activity) {
        showLoadingWithMessage(activity,null,true);
    }


    public static void showLoadingWithMessage(final Activity activity, final String text,final boolean isCancel) {
        if (activity!=null){
            activity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        //synchronized (dialogProcessBar){
                        if (dialogProcessBar != null && dialogProcessBar.isShowing()) {
                            dialogProcessBar.dismiss();
                        }

                        dialogProcessBar = new Dialog(activity, R.style.myDialog_2);
                        dialogProcessBar.requestWindowFeature(Window.FEATURE_NO_TITLE);


                        dialogProcessBar.setCancelable(isCancel);


                        dialogProcessBar.setContentView(R.layout.popup_processing_bar);
                        tv_process = (TextView) dialogProcessBar.findViewById(R.id.popup_processing_bar_tv);
                        if (TextUtils.isEmpty(text)){
                            tv_process.setVisibility(View.INVISIBLE);
                        }else {
                            tv_process.setVisibility(View.VISIBLE);
                            tv_process.setText(text);
                        }
                        mprogressBar = (ProgressBar) dialogProcessBar.findViewById(R.id.circular_progress_bar);
                        final Animation myRotation = AnimationUtils.loadAnimation(activity.getApplicationContext(), R.anim.rotator);
                        mprogressBar.startAnimation(myRotation);

                        if (dialogProcessBar != null && !dialogProcessBar.isShowing())
                            dialogProcessBar.show();
                        //}


                    } catch (Exception e) {
                        //android.util.Log.e("showLoading", e.toString());
                    }
                }
            });
        }
    }



    public static void hideLoading(final Activity activity) {
        try {
            if (activity !=null){
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        hideLoadingDialog();
                    }
                });
            }else {
                hideLoadingDialog();
            }
        }catch (Exception e){
            //android.util.Log.e("hideLoading", e.toString());
        }
    }

    public static void showDoneLoading(final Activity activity) {
        try {
            if (activity!=null){
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        mprogressBar.clearAnimation();
                        mprogressBar.setVisibility(View.INVISIBLE);

                        dismissTimerTask(200L);

                        if (dialogProcessBar != null)
                            dialogProcessBar.show();
                    }
                });
            }else {
                if(dialogProcessBar != null && dialogProcessBar.isShowing()){
                    dialogProcessBar.dismiss();
                }
            }
        }catch (Exception e){
            //android.util.Log.e("showDoneLoading", e.toString());
        }
    }

    public static void dismissLoadingDialog(final Activity activity) {
        try {
            if (activity!=null){
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if(dialogProcessBar != null && dialogProcessBar.isShowing()){
                            dialogProcessBar.dismiss();
                        }
                    }
                });
            }else {
                if(dialogProcessBar != null && dialogProcessBar.isShowing()){
                    dialogProcessBar.dismiss();
                }
            }
        }catch (Exception e){
            //android.util.Log.e("dismissLoadingDialog", e.toString());
        }
    }

    private static void hideLoadingDialog(){
        if (dialogProcessBar != null) {
            mprogressBar.clearAnimation();
            mprogressBar.setVisibility(View.INVISIBLE);
            dismissTimerTask(200L);
        }
    }

    private static void dismissTimerTask(long milisecond){
        try {
            TimerTask task = new TimerTask() {
                public void run() {
                    dismissLoadingDialog(null);
                }
            };
            Timer timer2 = new Timer("Timer");
            long delay = milisecond;
            timer2.schedule(task, delay);
        }catch (Exception e){
            //android.util.Log.e("dismissTimerTask", e.toString());
        }
    }

}
