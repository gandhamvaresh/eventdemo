ActiveAdmin.register EmailTemplate do
  #menu :parent => "Setting",:priority => 9
  menu false
  
  index :title => 'Email Templates'+SiteSetting.site_title do       
      column :from_name                    
      column :task        
      column :subject    
      column :from_address        
      column :reply_address         
      
      column do |show|
        link_to image_tag('event.png'), {:action => show.id.to_s}
      end
      
      column do |show|
        link_to 'Edit', {:action => show.id.to_s+'/edit'}
      end 
  end  
  
   show :title => 'Email Template'+SiteSetting.site_title do |show|
      render "view" , :layout => 'active_admin'
   end
   
     config.batch_actions = false
     config.clear_action_items!
     
     filter :from_name
     filter :task
     filter :subject 
     filter :from_address 
     filter :reply_address 
     
     
     
     
      form :html => { :enctype => "multipart/form-data" } do |f|
        f.inputs do
          f.input :from_name
          f.input :from_address
          f.input :reply_address
          f.input :subject
          f.input :message 
       end
       
       
       f.buttons do
           f.action(:submit) 
       end
     end  
     
     
end
