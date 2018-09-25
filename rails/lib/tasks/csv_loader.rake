require 'csv'

namespace :csv_loader do

  # TODO Add more fields like the birth year and location to the Speaker model?
  task :speakers, [:file] => :environment do |task, args|
    file = args[:file]
    if file.blank?
      puts "Specify the CSV file to import with rake csv_loader:speakers[speakers.csv]"
      puts "Expecting the following header row in the CSV file:"
      puts "Name (text field),Birth year (text field),Born where (tag field),Photo (file upload field)"
      exit 1;
    end
    puts "Loading speakers from: #{file}"
    row_count = 0
    CSV.foreach(file, headers: true) do |row|
      row_count += 1
      begin
        Speaker.create(name: row['Name (text field)'])
      rescue StandardError => e
        puts "Error on speaker row #{row_count}. (Row #{row_count+1} if the header counts as row 1.)"
        raise e
      end
    end
    puts "Created #{row_count} speakers."
  end

  # TODO Confirm use of Name, Type of Place and Region
  task :points, [:file] => :environment do |task, args|
    file = args[:file]
    if file.blank?
      puts "Specify the CSV file to import with rake csv_loader:points[places.csv]"
      puts "Expecting the following header row in the CSV file:"
      puts "Name (text field),Type of place (tag field),lat,long,Photo (file upload),Region"
      exit 1;
    end
    puts "Loading points from: #{file}"
    row_count = 0
    CSV.foreach(file, headers: true) do |row|
      row_count += 1
      begin
        Point.create(title: row['Name (text field)'], lng: row['long'], lat:row['lat'], region: row['Region'])
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
      puts "Title of story (text field),Description (text field),Tags (tag field),Speakers (tag field) - linked to Speaker name,Place (tag field) - linked to Place name,Where interviewed (tag field),Date of interview (date field),Interviewer (tag field),Language (tag field),Video (file upload),Restricted to user (tag field)"
      exit 1;
    end
    puts "Loading stories from: #{file}"
    row_count = 0
    CSV.foreach(file, headers: true) do |row|
      row_count += 1
      if row['Speakers (tag field) - linked to Speaker name'].present?
        speaker = Speaker.where(name: row['Speakers (tag field) - linked to Speaker name'])&.first
        puts "Could not match speaker name for story #{row_count}. (Row #{row_count+1} if the header counts as row 1.)" if speaker.nil?
      end
      if row['Place (tag field) - linked to Place name'].present?
        point = Point.where(title: row['Place (tag field) - linked to Place name'])&.first
        puts "Could not match point name for story #{row_count}. (Row #{row_count+1} if the header counts as row 1.)" if point.nil?
      end
      begin
        Story.create(title: row['Title of story (text field)'],
          desc: row['Description (text field)'],
          speaker_id: speaker&.id,
          point_id: point&.id
          )
      rescue StandardError => e
        puts "Error on story row #{row_count}. (Row #{row_count+1} if the header counts as row 1.)"
        raise e
      end
    end
    puts "Created #{row_count} stories."
  end

end
