class Visit < ActiveRecord::Base
  def self.record_visit!(user, shortened_url)
    Visit.create({user_id: user.id, shortened_url_id: shortened_url.id})
  end

  belongs_to :visitors,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  belongs_to :visited_urls,
    class_name: "ShortenedURL",
    foreign_key: :shortened_url_id,
    primary_key: :id
end
