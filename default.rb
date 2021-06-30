run "if uname | grep -q 'Darwin'; then pgrep spring | xargs kill -9; fi"

# GEMFILE
########################################
inject_into_file 'Gemfile', before: 'group :development, :test do' do
  <<~RUBY
    gem 'autoprefixer-rails'
    gem 'uglifier'
    gem 'jquery-rails'
    gem 'font-awesome-sass'
    gem "strip_attributes"
    # Use Redis adapter to run Action Cable in production
    gem 'sidekiq'
    gem 'sidekiq-failures', '~> 1.0'
    gem 'sidekiq-cron'
  RUBY
end

inject_into_file 'Gemfile', after: 'group :development, :test do' do
  <<-RUBY
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'dotenv-rails'
  RUBY
end

gsub_file('Gemfile', /# gem 'redis'/, "gem 'redis'")

# Procfile
########################################
file 'Procfile', <<~YAML
  web: bundle exec puma -C config/puma.rb
YAML

# Assets CSS
########################################
run 'rm -rf app/assets/stylesheets'
run 'rm -rf vendor'
run 'curl -L https://github.com/ubi-legal-innovation-team/rails-stylesheets/archive/master.zip > stylesheets.zip'
run 'unzip stylesheets.zip -d app/assets && rm stylesheets.zip && mv app/assets/rails-stylesheets-master app/assets/stylesheets'

# Assets JS
########################################
run 'rm -rf app/assets/javascripts'
run 'curl -L https://github.com/ubi-legal-innovation-team/rails-javascripts/archive/master.zip > javascripts.zip'
run 'unzip javascripts.zip -d app/assets && rm javascripts.zip && mv app/assets/rails-javascripts-master app/assets/javascripts'

# Assets fonts
########################################
run 'rm -rf app/assets/fonts'
run 'curl -L https://github.com/ubi-legal-innovation-team/rails-fonts/archive/master.zip > fonts.zip'
run 'unzip fonts.zip -d app/assets && rm fonts.zip && mv app/assets/rails-fonts-master app/assets/fonts'

# Assets images
########################################
run 'rm -rf app/assets/images'
run 'curl -L https://github.com/ubi-legal-innovation-team/rails-images/archive/master.zip > images.zip'
run 'unzip images.zip -d app/assets && rm images.zip && mv app/assets/rails-images-master app/assets/images'

# Dev environment
########################################
gsub_file('config/environments/development.rb', /config\.assets\.debug.*/, 'config.assets.debug = false')

# Layout
########################################

# Application layout
# if Rails.version < "6"
#   scripts = <<~HTML
#     <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload', defer: true %>
#         <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
#   HTML
#   gsub_file('app/views/layouts/application.html.erb', "<%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>", scripts)
# end

style = <<~HTML
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
HTML
gsub_file('app/views/layouts/application.html.erb', "<%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>", style)

inject_into_file 'app/views/layouts/application.html.erb', after: "<body>" do
  <<-HTML

    <%= render 'shared/navbar' %>
    <%#= render 'shared/flashes' %>
  HTML
end

inject_into_file 'app/views/layouts/application.html.erb', before: "</body>" do
  <<-HTML

    <%= javascript_pack_tag 'application' %>
    <%= javascript_include_tag 'application' %>
  HTML
end

inject_into_file 'app/views/layouts/application.html.erb', after: "<%= yield %>" do
  <<-HTML

    <%#= render 'shared/footer' %>
  HTML
end

# Welcome layout
file 'app/views/layouts/welcome.html.erb', <<~HTML
HTML
inject_into_file 'app/views/layouts/welcome.html.erb' do
  <<-HTML
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

      <title>[APP NAME]</title>

      <%= csrf_meta_tags %>
      <%= action_cable_meta_tag %>
      <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    </head>

    <body>
      <%= render "shared/navbar" %>
      <%= yield %>
    </body>
  </html>
  HTML
end

# Partials
########################################
file 'app/views/shared/_flashes.html.erb', <<~HTML
HTML
file 'app/views/shared/_footer.html.erb', <<~HTML
HTML
file 'app/views/shared/_navbar.html.erb', <<~HTML
HTML
file 'app/views/shared/navbar_components/_menu.html.erb', <<~HTML
HTML
file 'app/views/shared/navbar_components/_notifications.html.erb', <<~HTML
HTML
file 'app/views/shared/navbar_components/_user_nav.html.erb', <<~HTML
HTML
file 'app/views/shared/navbar_components/responsive/_menu.html.erb', <<~HTML
HTML
file 'app/views/ajax/ajax_calls/dropdowns/_user_nav.html.erb', <<~HTML
HTML
file 'app/views/ajax/ajax_calls/dropdowns/_notifications.html.erb', <<~HTML
HTML
file 'app/views/ajax/ajax_calls/dropdowns/_menu_responsive.html.erb', <<~HTML
HTML
file 'app/views/ajax/ajax_calls/modals/_example.html.erb', <<~HTML
HTML

run 'curl -L https://raw.githubusercontent.com/ubi-legal-innovation-team/rails-partials/master/partials/_flashes.html.erb > app/views/shared/_flashes.html.erb'
run 'curl -L https://raw.githubusercontent.com/ubi-legal-innovation-team/rails-partials/master/partials/_footer.html.erb > app/views/shared/_footer.html.erb'
run 'curl -L https://raw.githubusercontent.com/ubi-legal-innovation-team/rails-partials/master/partials/_navbar.html.erb > app/views/shared/_navbar.html.erb'
run 'curl -L https://raw.githubusercontent.com/ubi-legal-innovation-team/rails-partials/master/partials/navbar_components/_menu.html.erb > app/views/shared/navbar_components/_menu.html.erb'
run 'curl -L https://raw.githubusercontent.com/ubi-legal-innovation-team/rails-partials/master/partials/navbar_components/_notifications.html.erb > app/views/shared/navbar_components/_notifications.html.erb'
run 'curl -L https://raw.githubusercontent.com/ubi-legal-innovation-team/rails-partials/master/partials/navbar_components/_user_nav.html.erb > app/views/shared/navbar_components/_user_nav.html.erb'
run 'curl -L https://raw.githubusercontent.com/ubi-legal-innovation-team/rails-partials/master/partials/navbar_components/responsive/_menu.html.erb > app/views/shared/navbar_components/responsive/_menu.html.erb'
run 'curl -L https://raw.githubusercontent.com/ubi-legal-innovation-team/rails-partials/master/ajax/ajax_calls/dropdowns/_user_nav.html.erb > app/views/ajax/ajax_calls/dropdowns/_user_nav.html.erb'
run 'curl -L https://raw.githubusercontent.com/ubi-legal-innovation-team/rails-partials/master/ajax/ajax_calls/dropdowns/_notifications.html.erb > app/views/ajax/ajax_calls/dropdowns/_notifications.html.erb'
run 'curl -L https://raw.githubusercontent.com/ubi-legal-innovation-team/rails-partials/master/ajax/ajax_calls/dropdowns/_menu_responsive.html.erb > app/views/ajax/ajax_calls/dropdowns/_menu_responsive.html.erb'
run 'curl -L https://raw.githubusercontent.com/ubi-legal-innovation-team/rails-partials/master/ajax/ajax_calls/modals/_example.html.erb > app/views/ajax/ajax_calls/modals/_example.html.erb'

# Public
########################################
# run 'rm -rf public'
# run 'curl -L https://gitlab-ncsa.ubisoft.org/adhuy/rails-public/-/archive/master/rails-public-master.zip > public.zip'
# run 'unzip public.zip -d public && rm public.zip && mv public/rails-public-master public'

# README
########################################
markdown_file_content = <<~MARKDOWN
  Rails app generated with [ubi-legal-innovation-team/templates](https://github.com/ubi-legal-innovation-team/templates), created by the [Innovation Legal](https://www.legallab.ubisoft.org/crew) team.
MARKDOWN
file 'README.md', markdown_file_content, force: true

# Generators
########################################
generators = <<~RUBY
  config.generators do |generate|
    generate.assets false
    generate.helper false
    generate.test_framework :test_unit, fixture: false
  end
RUBY

environment generators

########################################
# AFTER BUNDLE
########################################
after_bundle do
  # Generators: db + pages controller
  ########################################
  rails_command 'db:drop db:create db:migrate'
  generate(:controller, 'pages', ['home','welcome'], '--skip-routes', '--no-test-framework')
  # generate(:controller, 'pages', 'welcome', '--skip-routes', '--no-test-framework')

  inject_into_file 'app/controllers/pages_controller.rb', after: "def home" do
    <<-RUBY

    render :home
    RUBY
  end

  inject_into_file 'app/controllers/pages_controller.rb', after: "def welcome" do
    <<-RUBY

    render layout: 'welcome'
    RUBY
  end

  # Routes
  ########################################
  route "root         to: 'pages#welcome'"
  route "get '/home', to: 'pages#home', as: 'home'"

  route "get '/user-nav/call',        to: 'application#user_nav_call',        as: 'user_nav_call'"
  route "get '/notifications/call',   to: 'application#notifications_call',   as: 'notifications_call'"
  route "get '/menu-responsive/call', to: 'application#menu_responsive_call', as: 'menu_responsive_call'"
  route "get '/example-modal/call',   to: 'application#example_modal_call',   as: 'example_modal_call'"

  # Pages
  ########################################
  run 'rm -rf app/views/pages/home.html.erb'
  run 'rm -rf app/views/pages/welcome.html.erb'
  file 'app/views/pages/home.html.erb', <<~HTML
  HTML
  file 'app/views/pages/welcome.html.erb', <<~HTML
  HTML

  run 'curl -L https://raw.githubusercontent.com/ubi-legal-innovation-team/rails-pages/master/home.html.erb > app/views/pages/home.html.erb'
  run 'curl -L https://raw.githubusercontent.com/ubi-legal-innovation-team/rails-pages/master/welcome.html.erb > app/views/pages/welcome.html.erb'

  # Git ignore
  ########################################
  append_file '.gitignore', <<~TXT
    # Ignore .env file containing credentials.
    .env*
    # Ignore Mac and Linux file system files
    *.swp
    .DS_Store
  TXT

  # App controller
  ########################################
  run 'rm app/controllers/application_controller.rb'
  file 'app/controllers/application_controller.rb', <<~RUBY
    class ApplicationController < ActionController::Base
      #{"protect_from_forgery with: :exception"}

      def example_modal_call
        params.extract!("utf8", "authenticity_token", "controller", "action")
        unsafe_params = params.to_unsafe_hash
        render partial: "/ajax/ajax_calls/modals/example"
      end

      def user_nav_call
        render partial: "/ajax/ajax_calls/dropdowns/user_nav"
      end

      def menu_responsive_call
        render partial: "/ajax/ajax_calls/dropdowns/menu_responsive"
      end

      def notifications_call
        render partial: "/ajax/ajax_calls/dropdowns/notifications"
      end
    end
  RUBY

  inject_into_file 'app/controllers/application_controller.rb', after: 'notifications_call' do
    <<~TXT

      # Notification.user(current_user.id).recent.unview.each do |notification|
      #   notification.update(view:true)
      # end
    TXT
  end

  # App helpers
  ########################################
  run 'rm app/helpers/application_helper.rb'
  file 'app/helpers/application_helper.rb', <<~RUBY
    module ApplicationHelper
      def svg(name)
        file_path = Rails.root.join('app/assets/images/svg/').join(name+".svg")
        if File.exists?(file_path)
          File.read(file_path).html_safe
        else
          '(not found)'
        end
      end
    end
  RUBY

  # Webpacker / Yarn
  ########################################
  run 'yarn add popper.js jquery @fortawesome/fontawesome-free'
  append_file 'app/javascript/packs/application.js', <<~JS
    // ----------------------------------------------------
    // Note(Legal lab): ABOVE IS RAILS DEFAULT CONFIGURATION
    // WRITE YOUR OWN JS STARTING FROM HERE 👇
    // ----------------------------------------------------

    // External imports

    // Internal imports, e.g:
    // import { initSelect2 } from '../components/init_select2';
    document.addEventListener('turbolinks:load', () => {
      // Call your functions here, e.g:
      // yourMethod();
    });
  JS

  inject_into_file 'config/webpack/environment.js', before: 'module.exports' do
    <<~JS
      const webpack = require('webpack');
      // Preventing Babel from transpiling NodeModules packages
      environment.loaders.delete('nodeModules');
      environment.plugins.prepend('Provide',
        new webpack.ProvidePlugin({
          $: 'jquery',
          jQuery: 'jquery',
          Popper: ['popper.js', 'default']
        })
      );
    JS
  end

  # Assets config
  ########################################
    inject_into_file 'app/assets/config/manifest.js', after: '//= link_directory ../stylesheets .css' do
    <<~JS

      #{"\n//= link_directory ../javascripts .js"}
    JS
  end
  run 'rm config/initializers/assets.rb'
  file 'config/initializers/assets.rb', <<~RUBY
    # Be sure to restart your server when you modify this file.

    # Version of your assets, change this if you want to expire all your assets.
    #{"Rails.application.config.assets.version = '1.0'"}

    # Add additional assets to the asset load path.
    # Rails.application.config.assets.paths << Emoji.images_path
    # Add Yarn node_modules folder to the asset load path.
    #{"Rails.application.config.assets.paths << Rails.root.join('node_modules')"}

    # Precompile additional assets.
    # application.js, application.css, and all non-JS/CSS in the app/assets
    # folder are already added.
    #{"Rails.application.config.assets.precompile += %w( application.js application.css application.scss )"}
  RUBY

  # Dotenv
  ########################################
  run 'touch .env'

  # Rubocop
  ########################################
  run 'curl -L https://raw.githubusercontent.com/ubi-legal-innovation-team/templates/master/rubocop.yml > .rubocop.yml'

  # Git
  ########################################
  git add: '.'
  git commit: "-m 'Initial commit with minimal template from https://github.com/ubi-legal-innovation-team/templates'"

  # Fix puma config
  gsub_file('config/puma.rb', 'pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }', '# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }')
end
