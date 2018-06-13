package momo.momo_partner.demo;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import org.json.JSONException;
import org.json.JSONObject;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import vn.momo.momo_partner.AppMoMoLib;
import vn.momo.momo_partner.MoMoParameterNamePayment;

public class PaymentActivity extends Activity {
    @BindView(R.id.tvEnvironment)
    TextView tvEnvironment;
    @BindView(R.id.tvMerchantCode)
    TextView tvMerchantCode;
    @BindView(R.id.tvMerchantName)
    TextView tvMerchantName;
    @BindView(R.id.edAmount)
    EditText edAmount;
    @BindView(R.id.tvMessage)
    TextView tvMessage;
    @BindView(R.id.btnPayMoMo)
    Button btnPayMoMo;
    private String amount = "10000";
    private String fee = "0";
    int environment = 0;//developer default
    private String merchantName = "CGV Cinemas";
    private String merchantCode = "CGV19072017";
    private String merchantNameLabel = "Nhà cung cấp";
    private String description = "Fast & Furious 8";
    private String MOMO_WEB_SDK_DEV = "http://118.69.187.119:9090/sdk/api/v1/payment/request";//debug
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_payment);
        ButterKnife.bind(this);
        Bundle data = getIntent().getExtras();
        if(data != null){
            environment = data.getInt(MoMoConstants.KEY_ENVIRONMENT);
        }
        if(environment == 0){
            AppMoMoLib.getInstance().setEnvironment(AppMoMoLib.ENVIRONMENT.DEBUG);
            tvEnvironment.setText("Development Environment");
        }else if(environment == 1){
            AppMoMoLib.getInstance().setEnvironment(AppMoMoLib.ENVIRONMENT.DEVELOPMENT);
            tvEnvironment.setText("Development Environment");
        }else if(environment == 2){
            AppMoMoLib.getInstance().setEnvironment(AppMoMoLib.ENVIRONMENT.PRODUCTION);
            tvEnvironment.setText("PRODUCTION Environment");
        }

        tvMerchantCode.setText("Merchant Code: "+merchantCode);
        tvMerchantName.setText("Merchant Name: "+merchantName);
    }

    //example open app MoMo get token
    private void requestToken() {
        AppMoMoLib.getInstance().setAction(AppMoMoLib.ACTION.PAYMENT);
        AppMoMoLib.getInstance().setActionType(AppMoMoLib.ACTION_TYPE.GET_TOKEN);
        Map<String, Object> intentValue = new HashMap<>();
        //client Required
        intentValue.put(MoMoParameterNamePayment.MERCHANT_NAME, "Shanship.vn");
        intentValue.put(MoMoParameterNamePayment.MERCHANT_CODE, "CGV19072017");
        intentValue.put(MoMoParameterNamePayment.AMOUNT, "20000");
        intentValue.put(MoMoParameterNamePayment.DESCRIPTION, "description");
        //client Optional
        intentValue.put(MoMoParameterNamePayment.FEE, "0");
        intentValue.put(MoMoParameterNamePayment.MERCHANT_NAME_LABEL, "Service");

        JSONObject objExtraData = new JSONObject();
        try {
            objExtraData.put("key1", "value1");
            objExtraData.put("key2", "value2");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        intentValue.put(MoMoParameterNamePayment.EXTRA_DATA, "");
        intentValue.put(MoMoParameterNamePayment.REQUEST_TYPE, "payment");
        intentValue.put(MoMoParameterNamePayment.LANGUAGE, "vi");
        intentValue.put(MoMoParameterNamePayment.EXTRA, "");

        AppMoMoLib.getInstance().requestMoMoCallBack(this, intentValue);
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(requestCode == AppMoMoLib.getInstance().REQUEST_CODE_MOMO && resultCode == -1) {
            if(data != null) {
                if(data.getIntExtra("status", -1) == 0) {
                    tvMessage.setText("message: " + "Get token " + data.getStringExtra("message"));

                    if(data.getStringExtra("data") != null && !data.getStringExtra("data").equals("")) {
                        // TODO:

                    } else {
                        tvMessage.setText("message: " + this.getString(R.string.not_receive_info));
                    }
                } else if(data.getIntExtra("status", -1) == 1) {
                    String message = data.getStringExtra("message") != null?data.getStringExtra("message"):"Thất bại";
                    tvMessage.setText("message: " + message);
                } else if(data.getIntExtra("status", -1) == 2) {
                    tvMessage.setText("message: " + this.getString(R.string.not_receive_info));
                } else {
                    tvMessage.setText("message: " + this.getString(R.string.not_receive_info));
                }
            } else {
                tvMessage.setText("message: " + this.getString(R.string.not_receive_info));
            }
        } else {
            tvMessage.setText("message: " + this.getString(R.string.not_receive_info_err));
        }
    }

    @OnClick(R.id.btnPayMoMo)
    public void onViewClicked() {
        requestPayment();
    }
}
