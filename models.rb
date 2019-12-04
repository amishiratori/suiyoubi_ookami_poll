ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || "sqlite3:db/development.db")


class Mentor < ActiveRecord::Base
  has_many :mentors_uuids
end

class MentorsUuid < ActiveRecord::Base
  belongs_to :mentor
end