class Site::Destroy < Trailblazer::Operation
  include Model
  model Site, :find

  def process(_params)
    @model.destroy!
  end
end
