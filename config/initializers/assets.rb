# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
%w[print admin cards free_forms monsters items spells static_pages filters users sessions password_resets spellbooks hero_classes admin/card_imports admin/admin].each do |controller|
  Rails.application.config.assets.precompile += %W[#{controller}.js #{controller}.css]
end
