package momo.momo_partner.demo;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.TextView;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import vn.momo.momo_partner.AppMoMoLib;
import vn.momo.momo_partner.MoMoParameterNameMap;

public class MappingActivity extends Activity {


    @BindView(R.id.tvEnvironment)
    TextView tvEnvironment;
    @BindView(R.id.tvClientId)
    TextView tvClientId;
    @BindView(R.id.tvUsername)
    TextView tvUsername;
    @BindView(R.id.tvPartnerCode)
    TextView tvPartnerCode;
    @BindView(R.id.tvMessage)
    TextView tvMessage;
    @BindView(R.id.btnMappingMoMo)
    Button btnMappingMoMo;

    int environment = 0;//developer default

    private String userName = "test MoMo";
    private String clientId = "billid_89733120121";
    private String partnerCode = "FACEBOOK";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_mapping);
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
        tvClientId.setText("Client ID: " + clientId);
        tvUsername.setText("Username: "+userName);
        tvPartnerCode.setText("Partner Code: " +partnerCode);

    }

    //example mapping
    private void requestMapping() {
        AppMoMoLib.getInstance().setAction(AppMoMoLib.ACTION.MAP);
        AppMoMoLib.getInstance().setActionType(AppMoMoLib.ACTION_TYPE.LINK);
        Map<String, Object> eventValue = new HashMap<>();
        //client Required
        eventValue.put(MoMoParameterNameMap.CLIENT_ID, clientId);
        eventValue.put(MoMoParameterNameMap.USER_NAME, userName);
        eventValue.put(MoMoParameterNameMap.PARTNER_CODE, partnerCode);
        //client info custom parameter
        JSONObject objExtra = new JSONObject();
        try {
            objExtra.put("key", "value");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        eventValue.put(MoMoParameterNameMap.EXTRA, objExtra);
        AppMoMoLib.getInstance().requestMoMoCallBack(this, eventValue);
    }

    @OnClick(R.id.btnMappingMoMo)
    public void onViewClicked() {
        requestMapping();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(requestCode == AppMoMoLib.getInstance().REQUEST_CODE_MOMO && resultCode == -1) {
            if(data != null) {
                tvMessage.setText("message: " + data.getStringExtra("message"));
                if(data.getIntExtra("status", -1) == 0) {
                    String token = data.getStringExtra("data");
                    String phoneNumber = data.getStringExtra("phonenumber");
                    if(token != null && !token.equals("")) {
                        // TODO:
                    } else {

                    }
                }
            } else {
                tvMessage.setText("message: " + this.getString(R.string.not_receive_info));
            }
        } else {
            tvMessage.setText("message: " + this.getString(R.string.not_receive_info_err));
        }
    }
}
