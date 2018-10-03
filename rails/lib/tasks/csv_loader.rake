require 'csv'

namespace :csv_loader do

  # TODO Add more fields like the birth year and location to the Speaker model?
  task :speakers, [:file] => :environment do |task, args|
    file = args[:file]
    if file.blank?
      puts "Specify the CSV file to import with rake csv_loader:speakers[speakers.csv]"
      puts "Expecting the following header row in the CSV file:"
      puts "Speaker_name (text field),Birth_year (text field),Born_where (tag field),Photo (file upload field)"
      exit 1;
    end
    puts "Loading speakers from: #{file}"
    row_count = 0
    CSV.foreach(file, headers: true) do |row|
      row_count += 1
      begin
       row['Birth_year (text field)'] = nil if row['Birth_year (text field)'] == 'unknown'
        Speaker.create(
          name: row['Speaker_name (text field)'],
          birth_year: row['Birth_year (text field)'],
          birth_place: row['Born_where (tag field)']
        )
      rescue StandardError => e
        puts "Error on speaker row #{row_count}. (Row #{row_count+1} if the header counts as row 1.)"
        raise e
      end
    end
    puts "Created #{row_count} speakers."
  end

  # TODO Confirm use of Name, Type of Place and Region
  task :places, [:file] => :environment do |task, args|
    file = args[:file]
    if file.blank?
      puts "Specify the CSV file to import with rake csv_loader:places[places.csv]"
      puts "Expecting the following header row in the CSV file:"
      puts "Place_name (text field),Type_of_place (tag field),Description,Region (tag field),lat,long,Photo (file upload)"
      exit 1;
    end
    puts "Loading places and points from: #{file}"
    row_count = 0
    CSV.foreach(file, headers: true) do |row|
      row_count += 1
      begin
        place = Place.where(name: row['Name (text field)'], type_of_place: row['Type_of_place (tag field)'])&.first
        if place.nil?
          place = Place.create(
            name: row['Place_name (text field)'],
            type_of_place: row['Type_of_place (tag field)']
          )
        end
        Point.create(
          title: row['Place_name (text field)'],
          lng: row['long'],
          lat:row['lat'],
          region: row['Region (tag field)'],
          place_id: place.id
        )
      rescue StandardError => e
        puts "Error on point row #{row_count}. (Row #{row_count+1} if the header counts as row 1.)"
        raise e
      end
    end
    puts "Created #{row_count} points."
  end

  # TODO Handle multiple speakers once the Story model supports it.
  # TODO Handle the restricted to user field.
  task :stories, [:file] => :environment do |task, args|
    file = args[:file]
    if file.blank?
      puts "Specify the CSV file to import with rake csv_loader:stories[stories.csv]"
      puts "Expecting the following header row in the CSV file:"
      puts "Title_of_story (text field),Description (text field),Restricted_to_user (tag field),Speaker_name (tag field) - linked to Speaker name,Place_name (tag field) - linked to Place name,Where_interviewed (tag field),Date_interview (date field),Interviewer (tag field),Language (tag field),Video (file upload)"
      exit 1;
    end
    puts "Loading stories from: #{file}"
    row_count = 0
    CSV.foreach(file, headers: true) do |row|
      row_count += 1
      if row['Speaker_name (tag field) - linked to Speaker name'].present?
        first_speaker = row['Speaker_name (tag field) - linked to Speaker name'].split(',')&.first
        speaker = Speaker.where(name: first_speaker)&.first
      end
      puts "Could not match speaker name for story #{row_count}. (Row #{row_count+1} if the header counts as row 1.) Speaker name: '#{row['Speaker_name (tag field) - linked to Speaker name']}'" if speaker.nil?
      if row['Place_name (tag field) - linked to Place name'].present?
        first_point = row['Place_name (tag field) - linked to Place name'].split(',')&.first
        point = Point.where(title: first_point)&.first
      end
      puts "Could not match point name for story #{row_count}. (Row #{row_count+1} if the header counts as row 1.) Place name: '#{row['Place_name (tag field) - linked to Place name']}'" if point.nil?
      begin
        permission_level = :anonymous
        permission_level = :user_only if row['Restricted_to_user (tag field)'].to_s.gsub(/\s+/,'').present?
        Story.create(title: row['Title_of_story (text field)'],
          desc: row['Description (text field)'],
          speaker_id: speaker&.id,
          point_id: point&.id,
          permission_level: permission_level
          )
      rescue StandardError => e
        puts "Error on story row #{row_count}. (Row #{row_count+1} if the header counts as row 1.)"
        raise e
      end
    end
    puts "Created #{row_count} stories."
  end

end
