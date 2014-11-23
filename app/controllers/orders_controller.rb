class OrdersController < ApplicationController
  include ApplicationHelper

  def cart
    if current_customer.present?
      @line_items = current_order.line_items
    else
      flash[:error] = 'You must be logged in!'
      redirect_to '/'
    end
  end

  def remove
    current_order.line_items.find(params[:id]).destroy
    flash[:notice] = "Removed from shopping cart"
    redirect_to cart_orders_path
  end

  def show
    @order = current_customer.orders.find(params[:id])
  end

  def checkout
    order_id = current_order.id
    current_order.update_attributes status: 1
    flash[:notice] = "Successfully Placed Order!"
    redirect_to order_path(order_id)
  end
end
