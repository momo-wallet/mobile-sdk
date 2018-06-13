package vn.momo.momo_partner.utils;


import android.app.ProgressDialog;
import android.content.Context;
import android.os.Handler;

public class ClientProgressBar {
    private ProgressDialog progress;
    private Handler mHandler = new Handler();
    private onListennerDismissTimeOut Listener;
    private onListennerDismiss ListenerNormal;

    public ClientProgressBar() {
    }

    public void setOnDismissTimeOutListenner(onListennerDismissTimeOut onListennerDismissTimeOut) {
        this.Listener = onListennerDismissTimeOut;
    }

    public void setOnDismissListenner(onListennerDismiss onListennerDismiss) {
        this.ListenerNormal = onListennerDismiss;
    }

    public void showProgessDialog(Context context, String message) {
        if(this.progress == null) {
            this.progress = new ProgressDialog(context);
            this.progress.setMessage(message);
            this.progress.setProgressStyle(0);
            this.progress.setIndeterminate(true);
            this.progress.setCancelable(false);
            this.progress.setCanceledOnTouchOutside(false);
            this.progress.show();
        }

    }

    public void setCancelable(boolean isCancelable) {
        this.progress.setCancelable(isCancelable);
    }

    public void setCanceledOnTouchOutside(boolean isCanceledOnTouchOutside) {
        this.progress.setCanceledOnTouchOutside(isCanceledOnTouchOutside);
    }

    public void dimissProgessDialog() {
        try {
            if(this.progress != null) {
                this.progress.dismiss();
                this.progress = null;
                if(this.ListenerNormal != null) {
                    this.ListenerNormal.onDismissNormal();
                    this.ListenerNormal = null;
                }
            }
        } catch (Exception var2) {
            var2.printStackTrace();
            this.progress = null;
        }

    }

    public void forceDimissProgessDialog() {
        if(this.mHandler != null) {
            this.mHandler = new Handler();
        }

        this.mHandler.postDelayed(new Runnable() {
            public void run() {
                ClientProgressBar.this.dimissProgessDialog();
            }
        }, 5000L);
    }

    public void forceDimissProgessDialog(int miliseconds) {
        if(this.mHandler != null) {
            this.mHandler = new Handler();
        }

        this.mHandler.postDelayed(new Runnable() {
            public void run() {
                try {
                    if(ClientProgressBar.this.progress != null) {
                        ClientProgressBar.this.progress.dismiss();
                        ClientProgressBar.this.progress = null;
                        if(ClientProgressBar.this.Listener != null) {
                            ClientProgressBar.this.Listener.onDismiss();
                        }
                    }
                } catch (Exception var2) {
                    ClientProgressBar.this.progress = null;
                }

            }
        }, (long)miliseconds);
    }

    public interface onListennerDismiss {
        void onDismissNormal();
    }

    public interface onListennerDismissTimeOut {
        void onDismiss();
    }
}
