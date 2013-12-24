OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '381033705363341', '33959df8593559d5b7e56bb9773b8ab2'
  
end


Rails.application.config.middleware.use OmniAuth::Builder do
  
  provider :twitter, 'lMq0xKLdK40bZ7OaGTpB8Q', 'Qs497SOoEO14pRv6OyPcN4rB4JnpEWL0eDXr6J5mKM'
end