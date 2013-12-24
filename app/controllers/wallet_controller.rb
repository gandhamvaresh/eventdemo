class WalletController < ApplicationController
  def index
      @meta_title = I18n.t 'meta_title.manage_wallet'
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      @event_wallet = Wallet.event_wallet_amount(@user[:id])
      @ref_wallet = Wallet.ref_wallet_amount(@user[:id])
      @aff_wallet = Wallet.aff_wallet_amount(@user[:id])
      #render :text => @ref_wallet.count
  end
  
  def withdraw
    if params[:id]
      
        send_withdraw(params[:id])
        flash[:notice1] = I18n.t 'wallet_controller.withdraw_request_send'
        redirect_to :action => 'index'
        
    elsif params[:all_id].count > 0
        @all = params[:all_id]
        @all.each do |id|
          send_withdraw(id)
        end
        
        flash[:notice1] =  I18n.t 'wallet_controller.withdraw_request_send'
        redirect_to :action => 'index'
        
    else
      redirect_to :action => 'index'
    end
  end
  
  def withdraw123
    if params[:id]
       @meta_title = I18n.t 'meta_title.withdraw_wallet'
       @user = User.find(session[:user_id])
       @site = SiteSetting.find(:first)
       @wallet = Wallet.find(params[:id])
      
       if request.post?
          @amount = @wallet[:due].to_f + params[:amount].to_f
          Wallet.update_all(["due = ? ", @amount], ["id = ?", @wallet[:id]])
          
          @with = WalletWithdraw.new
          @with[:wallet_id] = @wallet[:id]
          @with[:withdraw_ip] = request.remote_ip
          @with[:user_id] = @user[:id]
          @with[:withdraw_amount] = params[:amount]
          
          @with.save
           
          UserMailer.withdraw_request(@user, @with).deliver
          flash[:notice1] =  I18n.t 'wallet_controller.withdraw_request_send'
          redirect_to :action => 'index'
       end
    else
      redirect_to :action => 'index'
    end
  end
  
  private
  def send_withdraw(id)
      @user = User.find(session[:user_id])
      @wallet = Wallet.find(id)
      @amount = @wallet[:credit].to_f
      Wallet.update_all(["due = ?, sent_with=1 ", @amount], ["id = ?", @wallet[:id]])
      
      @with = WalletWithdraw.new
      @with[:wallet_id] = @wallet[:id]
      @with[:withdraw_ip] = request.remote_ip
      @with[:user_id] = @user[:id]
      @with[:withdraw_amount] = @amount
      
      @with.save
      UserMailer.withdraw_request(@user, @with).deliver
  end
  
end
