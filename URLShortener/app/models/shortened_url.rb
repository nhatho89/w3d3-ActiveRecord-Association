class ShortenedURL < ActiveRecord::Base

  validates :submitter_id, presence: true
  validates :short_url, uniqueness: true, presence: true

  def self.create_for_user_and_long_url!(user,long_url)
    ShortenedURL.create({short_url: self.random_code, submitter_id: user.id, long_url: long_url})
  end

  def self.random_code

    begin
    code = SecureRandom.urlsafe_base64
    raise StandardError if ShortenedURL.exists?(:short_url => code)
    rescue
      retry
    end
    code
  end

  belongs_to :submitter,
  class_name: "User",
  foreign_key: :submitter_id,
  primary_key: :id

  has_many :visits,
  class_name: "Visit",
  foreign_key: :shortened_url_id,
  primary_key: :id

  has_many :visitors,
  -> { distinct },
  through: :visits,
  source: :visitors

  def num_clicks
    Visit.where(shortened_url_id: id).count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    Visit.where(shortened_url_id: id).distinct.where(updated_at > 10.minutes.ago).count
  end



end
