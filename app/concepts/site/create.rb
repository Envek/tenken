class Site::Create < Trailblazer::Operation
  include Model, Callback

  model Site, :create

  contract do
    feature Disposable::Twin::Persisted

    property :uri, validates: { presence: true, url: true }
    property :name
    validates_uniqueness_of :uri
  end

  callback :after_create do
    on_create :setup_cron!
  end

  def process(params)
    validate(params[:site]) do
      contract.save
      callback! :after_create
    end
  end

  protected

  def setup_cron!(*args)
    puts args.inspect
    Sidekiq::Cron::Job.create(
      name: "Check #{@model.id}",
      cron: '* * * * *',
      class: 'Site::CheckJob',
      args: [@model.to_global_id.to_s],
    )
  end
end
