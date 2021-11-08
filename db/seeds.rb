# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

Faker::Config.locale = 'fr'

# Vider les tables à chaque nouveau seed via $ rails db:seed
City.destroy_all 
User.destroy_all 
Gossip.destroy_all
Tag.destroy_all 
JoinGossipTag.destroy_all
PrivateMessage.destroy_all
Comment.destroy_all 
Like.destroy_all

# Table cities
5.times do |c|
  city = City.create!(
    name: Faker::Address.city,
    zip_code: Faker::Address.zip_code
  )
end

# Table users
50.times do |u|
  user = User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    age: rand(18..100),
    city_id: City.ids.sample,
    password: Faker::Lorem.paragraph_by_chars(number: 6)
  )
end

# FOCUS ON :
# ids method >>> https://stackoverflow.com/questions/17103003/rails-active-record-get-ids-array-from-relation
# sample method >>> https://www.geeksforgeeks.org/ruby-array-sample-function/#:~:text=Array%23sample()%20%3A%20sample(),random%20elements%20from%20the%20array.&text=Return%3A%20a%20random%20element%20or%20n%20random%20elements%20from%20the%20array.
# Autre possibilité : "city_id : City.all.sample" va automatiquement récupérer aléatoirement un id d'objet City car les models doctor et city sont liés !


# Table gossips
100.times do
  gossip = Gossip.create!(
    title: Faker::Lorem.paragraph_by_chars(number: 15),
    content: Faker::Lorem.paragraph,
    user_id: User.ids.sample
  )
end

# Table tags
5.times do
  tag = Tag.create!(title: Faker::Color.color_name)
end

# Table join_gossip_tags
100.times do
  rand_gossip_id = Gossip.find_by(id: rand(1..Gossip.all.length)) #tirage aléatoire d'un id de la table gossips parmi le nombre d'entrées de la table (en évitant l'id 0 qui n'existe pas...)
  rand_tag_id = Tag.find_by(id: rand(1..Tag.all.length)) #idem

  gossip_tag_join = JoinGossipTag.create!(gossip: rand_gossip_id, tag: rand_tag_id)
end

# Table private_messages
10.times do 
  user_random = User.all.sample
  user_random2 = User.all.sample
  
  while user_random == user_random2
    user_random2 = User.all.sample #re-tirage aléatoire tant que les user_id sont identiques
  end
  #permet de ne pas avoir le même user sender et recipient

  PrivateMessage.create!(
    sender: user_random, 
    recipient: user_random2,
    content:Faker::Lorem.paragraph)
end

# Table comments
20.times do
  comment = Comment.create!(
    content: Faker::Lorem.sentence,
    gossip_id: Gossip.ids.sample,
    user_id: User.ids.sample
  )
end

# Table likes
50.times do
  like = Like.create!(
    user_id: User.ids.sample,
    comment_id: Comment.ids.sample,
    gossip_id: Gossip.ids.sample
  )
end