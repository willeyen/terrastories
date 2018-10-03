class AddFieldsToSpeakers < ActiveRecord::Migration[5.2]
 def change
   add_column(:speakers, :birth_year, :string)
   add_column(:speakers, :birth_place, :string)
 end
end
