// Generated code from Butter Knife. Do not modify!
package momo.momo_partner.demo;

import android.view.View;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import androidx.annotation.CallSuper;
import androidx.annotation.UiThread;
import butterknife.Unbinder;
import butterknife.internal.DebouncingOnClickListener;
import butterknife.internal.Utils;
import java.lang.IllegalStateException;
import java.lang.Override;

public class MainActivity_ViewBinding implements Unbinder {
  private MainActivity target;

  private View view7f070043;

  private View view7f070041;

  @UiThread
  public MainActivity_ViewBinding(MainActivity target) {
    this(target, target.getWindow().getDecorView());
  }

  @UiThread
  public MainActivity_ViewBinding(final MainActivity target, View source) {
    this.target = target;

    View view;
    target.rdEnvironmentProduction = Utils.findRequiredViewAsType(source, R.id.rdEnvironmentProduction, "field 'rdEnvironmentProduction'", RadioButton.class);
    target.rdGroupEnvironment = Utils.findRequiredViewAsType(source, R.id.rdGroupEnvironment, "field 'rdGroupEnvironment'", RadioGroup.class);
    view = Utils.findRequiredView(source, R.id.btnPaymentMoMo, "field 'btnPaymentMoMo' and method 'onViewClicked'");
    target.btnPaymentMoMo = Utils.castView(view, R.id.btnPaymentMoMo, "field 'btnPaymentMoMo'", Button.class);
    view7f070043 = view;
    view.setOnClickListener(new DebouncingOnClickListener() {
      @Override
      public void doClick(View p0) {
        target.onViewClicked(p0);
      }
    });
    view = Utils.findRequiredView(source, R.id.btnMappingMoMo, "field 'btnMappingMoMo' and method 'onViewClicked'");
    target.btnMappingMoMo = Utils.castView(view, R.id.btnMappingMoMo, "field 'btnMappingMoMo'", Button.class);
    view7f070041 = view;
    view.setOnClickListener(new DebouncingOnClickListener() {
      @Override
      public void doClick(View p0) {
        target.onViewClicked(p0);
      }
    });
  }

  @Override
  @CallSuper
  public void unbind() {
    MainActivity target = this.target;
    if (target == null) throw new IllegalStateException("Bindings already cleared.");
    this.target = null;

    target.rdEnvironmentProduction = null;
    target.rdGroupEnvironment = null;
    target.btnPaymentMoMo = null;
    target.btnMappingMoMo = null;

    view7f070043.setOnClickListener(null);
    view7f070043 = null;
    view7f070041.setOnClickListener(null);
    view7f070041 = null;
  }
}
