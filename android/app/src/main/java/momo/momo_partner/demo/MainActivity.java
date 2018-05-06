package momo.momo_partner.demo;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.IdRes;
import android.view.View;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class MainActivity extends Activity {


    int environment = 1;//developer default - Production environment = 2
//    @BindView(R.id.rdEnvironmentDebug)
//    RadioButton rdEnvironmentDebug;
//    @BindView(R.id.rdEnvironmentDeveloper)
//    RadioButton rdEnvironmentDeveloper;
    @BindView(R.id.rdEnvironmentProduction)
    RadioButton rdEnvironmentProduction;
    @BindView(R.id.rdGroupEnvironment)
    RadioGroup rdGroupEnvironment;
    @BindView(R.id.btnPaymentMoMo)
    Button btnPaymentMoMo;
    @BindView(R.id.btnMappingMoMo)
    Button btnMappingMoMo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ButterKnife.bind(this);

        rdGroupEnvironment.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup radioGroup, @IdRes int checkedId) {
//                if (checkedId == R.id.rdEnvironmentDebug) {
//                    environment = 0;
//                }else if (checkedId == R.id.rdEnvironmentDeveloper) {
//                    environment = 1;
//                }else if (checkedId == R.id.rdEnvironmentProduction) {
//                    environment = 2;
//                }
            }
        });
    }

    @OnClick({R.id.btnPaymentMoMo, R.id.btnMappingMoMo})
    public void onViewClicked(View view) {
        Intent intent;
        Bundle data = new Bundle();
        switch (view.getId()) {
            case R.id.btnPaymentMoMo:
                intent = new Intent(MainActivity.this, PaymentActivity.class);
                data.putInt(MoMoConstants.KEY_ENVIRONMENT, environment);
                intent.putExtras(data);
                startActivity(intent);
                break;
            case R.id.btnMappingMoMo:
                intent = new Intent(MainActivity.this, MappingActivity.class);
                data.putInt(MoMoConstants.KEY_ENVIRONMENT, environment);
                intent.putExtras(data);
                startActivity(intent);
                break;
        }
    }
}
