class Check < ApplicationRecord
  belongs_to :site

  def duration
    finished_at - started_at
  end
end
