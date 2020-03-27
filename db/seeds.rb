require 'faker'
## Script to generate large quantities of seed data for dev 
## Stories, Places, Speakers w/ media fields + relationships
## run via docker command 

# PLACES
# t.string "name"
# t.string "type_of_place"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.decimal "lat", precision: 10, scale: 6
# t.decimal "long", precision: 10, scale: 6
# t.string "region"
# t.string "description"

places_list = Array.new

100.times do
  places_list << Array.new(Faker::Address.city, 'city', Faker::Address.latitude, Faker::Address.longitude, Faker::Lorem.sentence(word_count: 5))
end

places_list.each do |name, type_of_place, lat, long, region, description|
  Place.find_or_create_by(name: name, type_of_place: type_of_place, lat: lat, long: long, region: region, description: description)
end

# SPEAKERS
# t.string "name"
# t.string "photo"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.datetime "birthdate"
# t.integer "birthplace_id" ==> place
# t.string "community"

speaker_list = Array.new 

100.times do
  speaker_list << Array.new(Faker::Name.unique.name, DateTime.new([*1930...2015].sample), Faker::Address.community)
end

speaker_list.each do |name, birthdate, community|
  place = Place.order('RANDOM()').first
  Speaker.find_or_create_by(name: name, birthdate: birthdate, community: community, birthplace_id: place.id)
end

#STORIES
# t.string "title"
# t.text "desc"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.integer "permission_level"
# t.datetime "date_interviewed"
# t.string "language"
# t.integer "interview_location_id" ==> place
# t.integer "interviewer_id" ==> speaker

story_list = Array.new

100.times do
  story_list << Array.new(Faker::Book.title, Faker::Lorem.sentence, rand(0...5), DateTime.new(), Faker::Nation.language)
end

story_list.each do |title, desc, permission_level, date_interviewed, language|
  speaker = Speaker.order('RANDOM()').first
  story = Story.find_or_create_by(title: title, desc: desc, permission_level: permission_level, date_interviewed: date_interviewed, language: language, interview_location: Place.order('RANDOM()').first, interviewer_id: speaker.id)
  SpeakerStory.find_or_create_by(speaker_id: speaker.id, story_id: story.id)
end

# places_stories
#story_id, place_id
