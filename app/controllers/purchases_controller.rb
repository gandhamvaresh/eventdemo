class PurchasesController < ApplicationController
  
  def delete
      #render :text => params
      @pur = Purchase.find(params[:id])
      user_id = @pur[:user_id]
      delete_order(@pur[:id],params[:qtys])
      
      redirect_to(APP_CONFIG['development']['site_url']+'admin/purchases/index/'+user_id.to_s)
      
  end
  
  
  
  def cancel
      #render :text => params
        @meta_title = I18n.t 'meta_title.cancel_order'
        @user = User.find(session[:user_id])
        @site = SiteSetting.find(:first)
        @pur = Purchase.find(params[:id])
        @event = Event.find(@pur[:event_id])
        
     if request.post?
        delete_order(params[:id],params[:qtys])
        flash[:notice1] = I18n.t 'purchase_controller.order_cancel'
        
        if params[:cancel]=='yes'
          redirect_to(:controller => 'my_tickets')
        else
          redirect_to(:controller => 'manage_event', :action => 'orders', :id => @pur[:event_id])
        end  
     end       
  end
  
  
  def show
     if params[:id]
      
          @meta_title = I18n.t 'meta_title.view_order'
          @user = User.find(session[:user_id])
          @site = SiteSetting.find(:first)
          @order = Purchase.find(params[:id])
          
       if Event.exists?(@order[:event_id])   
          @event = Event.find(@order[:event_id])
           @questions = Question.find(:all, :conditions => ['event_id=?', @event[:id]]) 
       else
        redirect_to :controller => 'events' 
      end      
    else
      redirect_to :controller => 'events'  
    end
  end
  
  def resend
    @pur = Purchase.find(params[:id])
     if (@pur[:transaction_key] && @pur[:transaction_key]>0)
       @parent = Purchase.find(@pur[:transaction_key])
       UserMailer.confirm_order(@parent).deliver
     else
       UserMailer.confirm_order(@pur).deliver
     end
       flash[:notice1] = I18n.t 'purchase_controller.conformation_email_successfully'
    redirect_to(:controller => 'manage_event', :action => 'orders', :id => @pur[:event_id])
  end
 
 
 private 
 def delete_order(id,qty)
      @pur = Purchase.find(id)
      @event = Event.find(@pur[:event_id])  
      
         @can = CancelOrder.new
         fields = Purchase.find_by_sql("SHOW FIELDS FROM  purchases WHERE FIELD NOT IN ('id')")
         
         for f in fields
           @can[f[:Field].to_s] = @pur[f[:Field].to_s]
         end
         
        @can.save
        
         @can = CancelOrder.find(:last)
         
      
      if @pur[:ticket_qty]==1 || @pur[:ticket_qty]==qty.to_i
         Ticket.update_all([" used = used - ? ", qty ], ["id = ?", @pur[:ticket_id]])
         Wallet.destroy_all("purchase_id = "+@pur[:id].to_s)
        
         if @can[:total]=='0.00' || @can[:total]==0.00
           @can[:with_con]=1
           @can.save
         end
         @pur.destroy
          
      else
        if @pur[:ticket_amt]=='' || @pur[:ticket_amt]==nil
          @pur[:ticket_amt]=0.00
        end
        if @pur[:total_fees]=='' || @pur[:total_fees]==nil
          @pur[:total_fees]=0.00
        end
         if @pur[:total]=='' || @pur[:total]==nil
          @pur[:total_fees]=0.00
        end
        
        orig_qty = @pur[:ticket_qty].to_f
        @total = @pur[:total]/orig_qty
        @total_fees = @pur[:total_fees]/orig_qty
        @ticket_amt = @pur[:ticket_amt]/orig_qty
        
        @pur[:total] = @pur[:total] - (@total*qty.to_f)
        @pur[:total_fees] = @pur[:total_fees] - (@total_fees*qty.to_f)
        @pur[:ticket_amt] = @pur[:ticket_amt] - (@ticket_amt*qty.to_f)
        @pur[:ticket_qty] = @pur[:ticket_qty]-qty.to_i
        @pur.save
        
       
          @can[:ticket_qty]=qty.to_i
          @can[:total]=@total*qty.to_f
          @can[:total_fees]=@total_fees*qty.to_f
          @can[:ticket_amt]=@ticket_amt*qty.to_f 
         
         if @can[:total]=='0.00' || @can[:total]==0.00
           @can[:with_con]=1
         end
         
          @can.save      
         
        Wallet.update_all(["credit = credit - ?", @ticket_amt*qty.to_f], ["purchase_id = ?", @pur[:transaction_key].to_i])
        Ticket.update_all([" used = used - ? ", qty ], ["id = ?", @pur[:ticket_id]])
        @event = Event.find(@pur[:event_id])
        generate_pdf(@pur, @event)
      end
      UserMailer.cancel_order_event(@can).deliver 
  end
 
 
end