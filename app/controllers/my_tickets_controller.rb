class MyTicketsController < ApplicationController
   
    before_filter :authorize
   
    def index
        @meta_title = I18n.t 'meta_title.my_tickets'
        @tickets = Purchase.where('ticket_id > 0 and payment=1 and user_id='+session[:user_id].to_s).order('id DESC')
        @site = SiteSetting.find(:first)
        @user = User.find(session[:user_id])
        
        @this_week_events = Event.find(:all, :conditions => ['event_start_date_time > ? AND event_start_date_time < ? AND active = ? AND cancel = ? AND user_id = ?', Time.now, Time.now + 7.days, 1, 0, session[:user_id]])
    end
    
    def view
        @meta_title = I18n.t 'meta_title.my_tickets'
        @my_ticket = Purchase.find(params[:id])
        @event = Event.find(@my_ticket[:event_id])
        @all_tickets = Purchase.find(:all, :conditions => ['transaction_key=? ', params[:id].to_s])
        @site = SiteSetting.find(:first)
        @user = User.find(session[:user_id])
        @this_week_events = Event.find(:all, :conditions => ['event_start_date_time > ? AND event_start_date_time < ? AND active = ? AND cancel = ? AND user_id = ?', Time.now, Time.now + 7.days, 1, 0, session[:user_id]])
        
    end
    
    
  
    
  def download_pdf
     @pur = Purchase.find(params[:id])
     if (@pur[:transaction_key] && @pur[:transaction_key]>0)
      # @pur = Purchase.find(@pur[:transaction_key])
     end
     
     send_file 'public/data/docs/'+@pur[:random_no]+'.pdf', :type =>'application/pdf', :disposition => 'attachment'  
  end
    
end