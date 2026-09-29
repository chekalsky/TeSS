RailsAdmin.config do |config|
  config.main_app_name = ['TeSS', 'Administration']
  config.asset_source = :sprockets

  config.authenticate_with do
    redirect_to main_app.root_path unless current_user.try(:is_admin?)
    warden.authenticate! scope: :user
  end

  config.current_user_method(&:current_user)

  # Devise 5 declares password length validators with procs, which crash rails_admin's generated help text.
  config.model 'User' do
    configure :password do
      help { "Length of #{Devise.password_length.min}-#{Devise.password_length.max} characters." }
    end
  end

  # activerecord.attributes.event.presence holds the enum value labels, so it can't be used as the field label.
  config.model 'Event' do
    configure :presence do
      label 'Presence'
    end
  end

  # No STI column on materials: records saved here are plain Materials but get indexed in Solr as ElearningMaterial.
  config.excluded_models = ['ElearningMaterial']
end