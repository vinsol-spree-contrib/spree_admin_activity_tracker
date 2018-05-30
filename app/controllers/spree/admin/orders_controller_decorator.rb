Spree::Admin::OrdersController.class_eval do

  def close_adjustments
    adjustments = @order.all_adjustments.open
    adjustments.update_all(state: 'closed')
    flash[:success] = Spree.t(:all_adjustments_closed)
    respond_with(@order) { |format| format.html { redirect_back fallback_location: admin_order_adjustments_url(@order) } }
  end

  def open_adjustments
    adjustments = @order.all_adjustments.closed
    adjustments.update_all(state: 'open')
    flash[:success] = Spree.t(:all_adjustments_opened)
    respond_with(@order) { |format| format.html { redirect_back fallback_location: admin_order_adjustments_url(@order) } }
  end

end
