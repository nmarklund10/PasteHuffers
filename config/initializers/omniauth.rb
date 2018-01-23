OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '689505337354-q1iajmjh8kuksrkhtqkqsdsd49ebl49f.apps.googleusercontent.com', 'ulZtEm9INon7dIjacs7s0lFT', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end