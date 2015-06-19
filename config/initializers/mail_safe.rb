if defined?(MailSafe::Config)
  MailSafe::Config.internal_address_definition = /.*@no-internal-address-definition\.com/i
  MailSafe::Config.replacement_address = 'davekaro@gmail.com'
end
