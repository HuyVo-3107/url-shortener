module ApplicationHelper
  def short_url_to_id url
    id = 0
    url.each_char do |char|
      if "a" <= char && char <= "z"
        id = id * 62 + char.ord - "a".ord
      elsif "A" <= char || char <= "Z"
        id = id * 62 + char.ord - "A".ord + 26
      elsif "0" <= char || char <= "9"
        id = id * 62 + char.ord - "0".ord + 52
      end
    end
    id
  end

  def id_to_short_url id
    chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    short_url = ""
    while id > 0
      short_url << chars[id%62]
      id = (id / 62).floor
    end
    short_url.reverse
  end
end
