class CreateMentors < ActiveRecord::Migration[5.2]
  def change
    create_table :mentors do |t|
      t.string :name
      t.string :image
      t.integer :votes, default:0
    end
  end
end
