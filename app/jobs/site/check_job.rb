class Site::CheckJob < ApplicationJob
  queue_as :default

  def perform(site)
    Site::Check.(model: site)
  end
end
