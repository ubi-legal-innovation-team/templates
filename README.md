# Rails Template


Quickly generate a rails app with the default Legal lab (at Ubisoft Legal Innovation Team) configuration using [Rails Templates](https://guides.rubyonrails.org/rails_application_templates.html).


## Default

Get a minimal rails app ready to be deployed on Heroku with debugging gems and assets configuration.

```git
rails new \
  --database postgresql \
  --webpack \
  -m https://raw.githubusercontent.com/ubi-legal-innovation-team/templates/master/default.rb \
  CHANGE_THIS_TO_YOUR_RAILS_APP_NAME
```
