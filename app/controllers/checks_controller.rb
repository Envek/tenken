class ChecksController < ApplicationController
  before_action do
    @site = Site.find(params.require(:site_id))
  end

  def index
    @collection = @site.checks.order(created_at: :desc)
  end

  def show
    @model = @site.checks.find(params[:id])
  end
end
