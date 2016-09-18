class SitesController < ApplicationController
  def index
    # TODO: Limit checks by 1 per site when https://github.com/rails/rails/issues/26541 will be fixed
    @collection = Site.all.eager_load(:checks).order('"sites"."uri" ASC, "checks"."created_at" DESC')
  end

  def new
    form Site::Create
  end

  def create
    run Site::Create do |_operation|
      return redirect_to sites_path, notice: 'Site successfully added'
    end
    render action: :new
  end

  def show
    redirect_to site_checks_path(site_id: params[:id])
  end

  def edit
    form Site::Update
  end

  def update
    run Site::Update do |_operation|
      return redirect_to sites_path, notice: 'Site successfully added'
    end
    render action: :new
  end

  def destroy
    run Site::Destroy do |_operation|
      return redirect_to sites_path, notice: 'Site was deleted'
    end
  end

  def check
    run Site::Check do |operation|
      return redirect_to site_check_path(operation.model, operation.check)
    end
  end
end
