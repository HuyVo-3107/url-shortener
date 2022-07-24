class Api::LinksController < Api::ApiController
  before_action :find_link, only: [:update, :show, :destroy, :get_url]

  def index
    links = @current_user.links

    page_size = params[:page_size] || 20
    page = params[:page] || 1
    links = links.order("#{params[:s_column] || "created_at"}": params[:s_type] || :DESC)
    pagy_detail, results = pagy(links, items: page_size, page: page)

    render json: {
        status: 200,
        data: {
            links: serializer(results, each_serializer: LinksSerializer),
            pagination: pagination(pagy_detail),
        }
    }, status: 200
  end

  def create
    url = params[:url]

    link = @current_user.links.find_by(url: url)
    if link.present?
      render json: {
          status: 200,
          data: {
              link: serializer(link, each_serializer: LinksSerializer),
          }
      }
    else
      next_id = Link.maximum(:id).present? ? Link.maximum(:id).next : 1
      link_id = 10000 + next_id
      link = @current_user.links.create!({url: url, link_id: link_id})

      render json: {
          status: 200,
          data: {
              link: serializer(link, each_serializer: LinksSerializer),
          }
      }, status: 201
    end
  end

  def show
    render json: {
        status: 200,
        data: {
            link: serializer(@link, each_serializer: LinksSerializer),
        }
    }, status: 201
  end

  def update
    @link.title = params[:title]
    if @link.save! && @link.reload
      render json: {
          status: 200,
          data: {
              link: serializer(@link, each_serializer: LinksSerializer),
          }
      }, status: 200
    end
  end

  def destroy
    if @link.destroy!
      render json: {
          status: 200,
      }, status: 200
    end
  end

  def get_url
    @link.clicked = @link.clicked + 1
    if @link.save!
      render json: {
          status: 200,
          data: {
              url: @link.url
          }
      }, status: 200
    end
  end

  private

  def find_link
    link_id = short_url_to_id params[:short_url]
    p link_id
    @link = @current_user.links.find_by!(link_id: link_id)
  end
end
