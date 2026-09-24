class PagesController < ApplicationController
  before_action :require_login
  before_action :set_page, only: [ :show, :destroy ]

  def index
    query = params[:query].to_s.strip
    pages = policy_scope(Page)
    authorize Page

    @pages =
      if query.present?
        safe_query = Page.sanitize_sql_like(query.downcase)
        pages.where("LOWER(title) LIKE ?", "%#{safe_query}%").order(:title)
      else
        pages.order(:title)
      end
  end

  def show
    authorize @page
  end

  def new
    @page = current_user.pages.build
    @page.content_items.build
    authorize @page
  end

  def create
    @page = current_user.pages.build(page_params)
    authorize @page

    saved = Page.transaction do
      if @page.save
        ActivityLog.create!(
          user: current_user,
          action: "create_page",
          subject_type: "Page",
          subject_id: @page.id,
          details: @page.title
        )
        true
      else
        false
      end
    end

    if saved
      redirect_to @page, notice: "Archive page created."
    else
      @page.content_items.build if @page.content_items.empty?
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @page

    @page.with_lock do
      Page.transaction do
        ActivityLog.create!(
          user: current_user,
          action: "delete_page",
          subject_type: "Page",
          subject_id: @page.id,
          details: @page.title
        )
        @page.destroy!
      end
    end

    redirect_to pages_path, notice: "Archive page deleted."
  end

  private

  def set_page
    @page = Page.includes(:content_items).find(params[:id])
  end

  def page_params
    params.require(:page).permit(
      :title,
      :image,
      content_items_attributes: [ :content_type, :text, :url, :datetime ]
    )
  end
end
