class Site::Destroy < Trailblazer::Operation
  include Model
  model Site, :find

  def process(_params)
    @model.destroy!
    Sidekiq::Cron::Job.find("Check #{@model.id}")&.destroy
  end
end
