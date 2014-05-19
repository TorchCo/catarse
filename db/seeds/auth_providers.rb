# coding: utf-8
#
[
  {name: 'facebook', key: ENV['FACEBOOK_KEY'].to_s, secret: ENV['FACEBOOK_SECRET'].to_s, path: 'facebook'},
  {name: 'google_oauth2', key: ENV['GOOGLE_CLIENT_ID'].to_s, secret: ENV['GOOGLE_CLIENT_SECRET'].to_s, path: 'google_oauth2'},
  {name: 'linkedin', key: ENV['LINKEDIN_KEY'].to_s, secret: ENV['LINKEDIN_SECRET'].to_s, path: 'linkedin'}
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

