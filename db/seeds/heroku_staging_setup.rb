# coding: utf-8
#
puts 'Seeding the database...'

[
  Contribution,
  Reward,
  Notification,
  Project,
  Category,
  User,
  OauthProvider,
  CatarseSettings
].each do |klass|
  puts "\nDeleting all #{klass.name.pluralize}..."
  klass.delete_all
  puts "Done.\n"
end



puts "\nCreating categories"

[
  {pt: 'Biocombustíveis', en: 'Biofuel'},
  {pt: 'Geotérmica', en: 'Geothermal'},
  {pt: 'Hidro', en: 'Hydro'},
  {pt: 'Petróleo e Gás', en: 'Oil and Gas'},
  {pt: 'Solar', en: 'Solar'},
  {pt: 'Vento', en: 'Wind'}
].each do |name|
  category = Category.find_or_initialize_by(name_pt: name[:pt])
  category.update_attributes({
    name_en: name[:en]
  })
end
puts "Done.\n"

{
  company_name: 'EnergyFunding',
  company_logo: 'http://catarse.me/assets/catarse_bootstrap/logo_icon_catarse.png',

  host: 'torchco-cf-staging.herokuapp.com',
  base_url: "http://torchco-cf-staging.herokuapp.com",
  base_domain: 'torchco-cf-staging.herokuapp.com',

  email_contact: 'contato@catarse.me',
  email_payments: 'financeiro@catarse.me',
  email_projects: 'projetos@catarse.me',
  email_system: 'system@catarse.me',
  email_no_reply: 'no-reply@catarse.me',

  facebook_url: "http://facebook.com/catarse.me",
  facebook_app_id: ENV['FACEBOOK_KEY'],

  twitter_url: 'http://twitter.com/catarse',
  twitter_username: "catarse",

  mailchimp_url: "http://catarse.us5.list-manage.com/subscribe/post?u=ebfcd0d16dbb0001a0bea3639&amp;id=149c39709e",
  catarse_fee: '0.13',
  support_forum: 'http://suporte.catarse.me/',
  uservoice_secret_gadget: 'change_this',
  uservoice_key: 'uservoice_key',
  faq_url: 'http://suporte.catarse.me/',
  feedback_url: 'http://suporte.catarse.me/forums/103171-catarse-ideias-gerais',
  terms_url: 'http://suporte.catarse.me/knowledgebase/articles/161100-termos-de-uso',
  privacy_url: 'http://suporte.catarse.me/knowledgebase/articles/161103-pol%C3%ADtica-de-privacidade',
  about_channel_url: 'http://blog.catarse.me/conheca-os-canais-do-catarse/',
  instagram_url: 'http://instagram.com/catarse_',
  blog_url: "http://blog.catarse.me",
  github_url: 'http://github.com/torchco/catarse',
  contato_url: 'http://suporte.catarse.me/'
}.each do |name, value|
   conf = CatarseSettings.find_or_initialize_by(name: name)
   conf.update_attributes({
     value: value
   }) if conf.new_record?
end


Channel.find_or_create_by!(name: "Channel name") do |c|
  c.permalink = "sample-permalink"
  c.description = "Lorem Ipsum"
end


[
  {name: 'facebook', key: ENV['FACEBOOK_KEY'].to_s, secret: ENV['FACEBOOK_SECRET'].to_s, path: 'facebook'},
  {name: 'google_oauth2', key: ENV['GOOGLE_CLIENT_ID'].to_s, secret: ENV['GOOGLE_CLIENT_SECRET'].to_s, path: 'google_oauth2'}
].each do |hash|
  provider = OauthProvider.find_or_initialize_by_name hash[:name]
  provider.update_attributes(hash.slice(:key, :secret, :path))
end

if !Rails.env.staging? && !Rails.env.production?
  puts '\n============================================='
  puts ' Showing all Authentication Providers'
  puts '---------------------------------------------'

  OauthProvider.all.each do |conf|
    a = conf.attributes
    puts "  name #{a['name']}"
    puts "     key: #{a['key']}"
    puts "     secret: #{a['secret']}"
    puts "     path: #{a['path']}"
    puts
  end
end


puts "Adding Admin user..."

User.find_or_create_by!(name: "Admin") do |u|
  u.nickname = "Admin"
  u.email = "admin@admin.com"
  u.password = "cf-password"
  u.password_confirmation = "cf-password"
  u.remember_me = false
  u.admin = true
end

puts "Adding Funder user..."

User.find_or_create_by!(name: "Funder") do |u|
  u.nickname = "Funder"
  u.email = "funder@funder.com"
  u.nickname = "Funder"
  u.password = "cf-password"
  u.password_confirmation = "cf-password"
  u.remember_me = false
end

puts "Adding Test user..."

User.find_or_create_by!(name: "Test") do |u|
  u.nickname = "Test"
  u.email = "test@test.com"
  u.nickname = "Test"
  u.password = "cf-password"
  u.password_confirmation = "cf-password"
  u.remember_me = false
end

if !Rails.env.staging? && !Rails.env.production?
  puts '\n============================================='
  puts ' Showing all entries in Configuration Table...'
  puts '---------------------------------------------'

  CatarseSettings.all.each do |conf|
    a = conf.attributes
    puts "  #{a['name']}: #{a['value']}"
  end
end


puts '---------------------------------------------'
puts 'Done!'

