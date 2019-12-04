class CreateMentorsUuids < ActiveRecord::Migration[5.2]
  def change
    create_table :mentors_uuids do |t|
      t.string :uuid
      t.references :mentor
      t.timestamps null: false
    end
  end
end
