class LinksSerializer < ActiveModel::Serializer
  include ApplicationHelper
  attributes :title, :shortener_path, :clicked, :created_at

  def shortener_path
      id_to_short_url object.link_id
  end
end
