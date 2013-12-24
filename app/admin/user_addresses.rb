ActiveAdmin.register UserAddress do
  menu false
   
   
   show :title => "User Addresses"+SiteSetting.site_title do |show|
      render "view" , :layout => 'active_admin'
   end
   
  controller do
     
      
   def index 
      redirect_to("/admin/users" ) and return
   end
   
      def list
        @page_title = 'User Address'+SiteSetting.site_title
        @addr = UserAddress.find(:first, :conditions => ['user_id=?', params[:id]])
        if @addr
           redirect_to(:action => "/"+@addr[:id].to_s) 
        else
            redirect_to(:action => 'new', :user => params[:id])
        end
        
      end
  end
  
  
   config.clear_action_items!   
      
   form :html => { :enctype => "multipart/form-data" } do |f|
        if f.object.new_record?       
          @user = User.find(params[:user])
        end
       
        f.inputs "Home Address" do
          if f.object.new_record?
              f.input :user_id, :as => :hidden, :input_html => { :value => params[:user] }
          end    
          f.input :home_add1, :label => 'Address'
          f.input :home_add2, :label => 'Address2'
          f.input :home_country, :label => 'Country', :as => :select,:include_blank => false, :collection => Country.all.map{|u| ["#{u.country_name}", u.country_name]}
          f.input :home_state, :label => 'State', :as => :select,:include_blank => false, :collection => State.all.map{|u| ["#{u.state_name}", u.state_name]}
          f.input :home_city, :label => 'City'
          f.input :home_zip, :label => 'Zipcode'
       end
       
       f.inputs "Billing Address" do
          f.input :bill_add1, :label => 'Address'
          f.input :bill_add2, :label => 'Address2'
          f.input :bill_country, :label => 'Country', :as => :select,:include_blank => false, :collection => Country.all.map{|u| ["#{u.country_name}", u.country_name]}
          f.input :bill_state, :label => 'State', :as => :select,:include_blank => false, :collection => State.all.map{|u| ["#{u.state_name}", u.state_name]}
          f.input :bill_city, :label => 'City'
          f.input :bill_zip, :label => 'Zipcode'
       end
       
       f.inputs "Shipping Address" do
          f.input :ship_add1, :label => 'Address'
          f.input :ship_add2, :label => 'Address2'
          f.input :ship_country, :label => 'Country', :as => :select,:include_blank => false, :collection => Country.all.map{|u| ["#{u.country_name}", u.country_name]}
          f.input :ship_state, :label => 'State', :as => :select,:include_blank => false, :collection => State.all.map{|u| ["#{u.state_name}", u.state_name]}
          f.input :ship_city, :label => 'City'
          f.input :ship_zip, :label => 'Zipcode'
       end
       
       f.inputs "Working Address" do
          f.input :work_add1, :label => 'Address'
          f.input :work_add2, :label => 'Address2'
          f.input :work_country, :label => 'Country', :as => :select,:include_blank => false, :collection => Country.all.map{|u| ["#{u.country_name}", u.country_name]}
          f.input :work_state, :label => 'State', :as => :select,:include_blank => false, :collection => State.all.map{|u| ["#{u.state_name}", u.state_name]}
          f.input :work_city, :label => 'City'
          f.input :work_zip, :label => 'Zipcode'
          f.input :work_job_title, :label => 'Job Title'
          f.input :work_company, :label => 'Company'
          f.input :work_phone, :label => 'Phone'
          f.input :work_blog, :label => 'Blog'
          f.input :work_website, :label => 'Website'
       end
       
       
       f.inputs "Other Information" do
          f.input :gender, :as => :select,:include_blank => false, :collection =>[['Male', 'Male'],['Female', 'Female']] 
          f.input :birth_date, :as => :datepicker
       end    
       
       f.buttons do
           f.action(:submit) 
       end
     end   
  
end
