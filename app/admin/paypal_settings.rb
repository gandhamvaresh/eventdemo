ActiveAdmin.register PaypalSetting do
   #menu :parent => "Setting", :url => "/admin/paypal_settings/1/edit"  ,:priority => 4
   menu false
   
    config.clear_sidebar_sections! 
    config.clear_action_items!
    
  controller do
    def index
      redirect_to("/admin/paypal_settings/1/edit" )
    end
   
   
    def update
        update! do |format|
            redirect_to("/admin/paypal_settings/1/edit") and return
        end
    end
  end
  
   form do |f|
      f.inputs "Paypal Setting" do
	  	f.input :site_status,:as => :select,:include_blank => false, :collection =>[["sandbox", "Sandbox"],["live", "Live"]] 
		f.input :paypal_email
		f.input :gateway_status,:as => :select,:include_blank => false, :collection =>[["Active", 1],["Inactive", 0]] 
	  end
       f.buttons do
	     f.action(:submit) 
	   end
    end
end
