// Generated code from Butter Knife. Do not modify!
package momo.momo_partner.demo;

import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import androidx.annotation.CallSuper;
import androidx.annotation.UiThread;
import butterknife.Unbinder;
import butterknife.internal.DebouncingOnClickListener;
import butterknife.internal.Utils;
import java.lang.IllegalStateException;
import java.lang.Override;

public class PaymentActivity_ViewBinding implements Unbinder {
  private PaymentActivity target;

  private View view7f070042;

  @UiThread
  public PaymentActivity_ViewBinding(PaymentActivity target) {
    this(target, target.getWindow().getDecorView());
  }

  @UiThread
  public PaymentActivity_ViewBinding(final PaymentActivity target, View source) {
    this.target = target;

    View view;
    target.tvEnvironment = Utils.findRequiredViewAsType(source, R.id.tvEnvironment, "field 'tvEnvironment'", TextView.class);
    target.tvMerchantCode = Utils.findRequiredViewAsType(source, R.id.tvMerchantCode, "field 'tvMerchantCode'", TextView.class);
    target.tvMerchantName = Utils.findRequiredViewAsType(source, R.id.tvMerchantName, "field 'tvMerchantName'", TextView.class);
    target.edAmount = Utils.findRequiredViewAsType(source, R.id.edAmount, "field 'edAmount'", EditText.class);
    target.tvMessage = Utils.findRequiredViewAsType(source, R.id.tvMessage, "field 'tvMessage'", TextView.class);
    view = Utils.findRequiredView(source, R.id.btnPayMoMo, "field 'btnPayMoMo' and method 'onViewClicked'");
    target.btnPayMoMo = Utils.castView(view, R.id.btnPayMoMo, "field 'btnPayMoMo'", Button.class);
    view7f070042 = view;
    view.setOnClickListener(new DebouncingOnClickListener() {
      @Override
      public void doClick(View p0) {
        target.onViewClicked();
      }
    });
  }

  @Override
  @CallSuper
  public void unbind() {
    PaymentActivity target = this.target;
    if (target == null) throw new IllegalStateException("Bindings already cleared.");
    this.target = null;

    target.tvEnvironment = null;
    target.tvMerchantCode = null;
    target.tvMerchantName = null;
    target.edAmount = null;
    target.tvMessage = null;
    target.btnPayMoMo = null;

    view7f070042.setOnClickListener(null);
    view7f070042 = null;
  }
}
