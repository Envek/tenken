class Site::Create < Trailblazer::Operation
  include Model

  model Site, :create

  contract do
    property :uri, validates: { presence: true, url: true }
    property :name
    validates_uniqueness_of :uri
  end

  def process(params)
    validate(params[:site]) do
      contract.save
    end
  end
end
