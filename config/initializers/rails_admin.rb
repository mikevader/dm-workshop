# RailsAdmin.config do |config|
#   config.asset_source = :importmap
#   # config.asset_source = :webpacker
#
#   ### Popular gems integration
#   config.parent_controller = '::ApplicationController'
#   config.authorize_with do
#     redirect_to main_app.root_path unless admin_user?
#   end
#
#   ## == Devise ==
#   # config.authenticate_with do
#   #   warden.authenticate! scope: :user
#   # end
#   # config.current_user_method(&:current_user)
#
#   ## == Cancan ==
#   # config.authorize_with :cancan
#
#   ## == PaperTrail ==
#   # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0
#
#   ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration
#   #config.included_models = %w(Category Rarity HeroClass User Skill Monster Spell Item)
#
#   config.actions do
#     dashboard                     # mandatory
#     index                         # mandatory
#     new
#     export
#     bulk_delete
#     show
#     edit
#     delete
#     show_in_app
#
#     ## With an audit adapter, you can add:
#     # history_index
#     # history_show
#   end
# end
