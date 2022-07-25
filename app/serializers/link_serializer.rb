class LinkSerializer < ActiveModel::Serializer
  include ApplicationHelper
  attributes :id, :title, :shortener_path,:shortener_url, :clicked, :created_at, :url

  def shortener_path
      id_to_short_url object.link_id
  end
  def shortener_url
    path = id_to_short_url object.link_id
    ENV["SHORTENER_URL_CLIENT"] + '/s/' + path
  end
end
