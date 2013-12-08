class TAnalyzer
  require 'json'
  require 'geocoder'

  def initialize(path)
    Geocoder.configure(
      :lookup => :nominatim,
      :http_headers => { "User-Agent" => "TAnalyzer <will@will3942.com>" }
    )

    tweet_index = File.read(path+'tweet_index.js')
    tweet_index = tweet_index.gsub("var tweet_index =  ", "")
    tweet_index = JSON.parse(tweet_index)

    countries = Hash.new
    cities = Hash.new
    replied_to = Hash.new
    user = Hash.new
    tweet_types = Hash["retweets", 0, "tweets", 0, "hashtagged", 0] 
    topics = Hash["weather", Hash.new, "football", Hash.new, "soccer", Hash.new, "rugby", Hash.new, "cricket", Hash.new, "hockey", Hash.new, "mac", Hash.new, "windows", Hash.new, "linux", Hash.new, "google", Hash.new, "microsoft", Hash.new, "starbucks", Hash.new, "wendy", Hash.new, "pret", Hash.new, "dunkin", Hash.new, "coffee", Hash.new, "costa", Hash.new, "iphone", Hash.new, "apple", Hash.new, "android", Hash.new, "blackberry", Hash.new]

    tweet_index.each do |file|
      JSON.parse(File.read(path+file["file_name"].gsub("data/js/", "")).lines.to_a[1..-1].join).each do |tweet|
        if user.empty?
          user["id"] = tweet["user"]["id_str"]
          user["name"] = tweet["user"]["name"]
          user["username"] = tweet["user"]["screen_name"]
          user["profile_image_url"] = tweet["user"]["profile_image_url_https"] 
        end
        unless tweet["retweeted_status"].nil?
          tweet_types["retweets"] = tweet_types["retweets"].to_i + 1
        else
          tweet_types["tweets"] = tweet_types["tweets"].to_i + 1
        end
        unless tweet["entities"]["hashtags"].empty?
          tweet_types["hashtagged"] = tweet_types["hashtagged"].to_i + 1
        end
        unless tweet["in_reply_to_screen_name"].nil?
          if replied_to.has_key?(tweet["in_reply_to_screen_name"])
            replied_to[tweet["in_reply_to_screen_name"]] = replied_to[tweet["in_reply_to_screen_name"]].to_i + 1
          else
            replied_to[tweet["in_reply_to_screen_name"]] = 1
          end
        end
        check_topics(tweet["text"], topics)
        unless tweet["geo"].empty?
          result = Geocoder.search("#{tweet["geo"]["coordinates"][0]},#{tweet["geo"]["coordinates"][1]}").first
          unless result.nil? or result.country.nil? or result.city.nil?
            if countries.has_key?(result.country)
              countries[result.country] = countries[result.country].to_i + 1
            else
              countries[result.country] = 1
            end
            if cities.has_key?(result.city)
              cities[result.city] = cities[result.city].to_i + 1
            else
              cities[result.city] = 1
            end
          end
        end
      end
    end

    cities = cities.sort {|x,y| y[1]<=>x[1]}
    countries = countries.sort {|x,y| y[1]<=>x[1]}
    tweet_types = tweet_types.sort {|x,y| y[1]<=>x[1]}
    replied_to = replied_to.sort {|x,y| y[1]<=>x[1]}

    top_cities = cities[0..4]
    top_countries = countries[0..4]
    top_users = replied_to[0..4]

    json = Hash["user", user, "top_users", Hash[top_users], "top_cities", Hash[top_cities], "top_countries", Hash[top_countries], "tweet_types", Hash[tweet_types], "sentiment_data", topics].to_json 

    @analysis_data = json
  end

  def data
    @analysis_data
  end

  private

  def haystack_search(haystack, needle)
    haystack.each_with_index do |value, index|
      if value.include?(needle)
        return index
      end
    end
    return false
  end

  def find_sentiment(haystack, index)
    good = 0
    bad = 0
    if haystack[index-1] == "at"
      if haystack[index-2] == "i'm" or haystack[index-2] == "im" 
        good += 1
      end
    end
    case haystack[index+1]
    when "&gt;"
      good += 1
    when "&lt;"
      bad += 1
    when "best"
      good += 1
    when "everyday"
      good += 1
    when "soon"
      good += 1
    when "spam"
      bad += 1
    when "hardest"
      bad += 1
    end
    unless haystack[index-1] == "is" or haystack[index-1] == "a" or haystack[index-1] == "some" or haystack[index-1] == "an"
      case haystack[index-1]
      when "hated"
        bad += 1
      when "loved"
        good += 1
      when "cus"
        good += 1
      when "cause"
        good += 1
      when "liked"
        good += 1
      when "hate"
        bad += 1
      when "prefer"
        good += 1
      when "detest"
        bad += 1
      when "loathe"
        bad += 1
      when "h8"
        bad += 1
      when "love"
        good += 1
      when "<3"
        good += 1
      when "luv"
        good += 1
      when "adore"
        good += 1
      when "lov"
        good += 1
      when "loving"
        good += 1
      when "old"
        bad += 1
      when "nice"
        good += 1
      when "amazing"
        good += 1
      when "good"
        good += 1
      when "cool"
        good += 1
      when "sick"
        good += 1
      when "ossum"
        good += 1
      when "wicked"
        good += 1
      when "sweet"
        good += 1
      when "great"
        good += 1
      when "necessary"
        good += 1
      when "amaze"
        good += 1
      when "beautiful"
        good += 1
      when "gorgeous"
        good += 1
      when "required"
        good += 1
      when "healthy"
        good += 1
      when "cute"
        good += 1
      when "rancid"
        bad += 1
      when "horrible"
        bad += 1
      when "horrid"
        bad += 1
      when "horid"
        bad += 1
      when "horible"
        bad += 1
      when "bad"
        bad += 1
      when "terrible"
        bad += 1
      when "wank"
        bad += 1
      when "shit"
        bad += 1
      when "crap"
        bad += 1
      when "awful"
        bad += 1
      when "fucking"
        bad += 1
      end
    else
      case haystack[index-2]
      when "performance"
        good += 1
      when "hate"
        bad += 1
      when "nice"
        good += 1
      when "better"
        good += 1
      when "detest"
        bad += 1
      when "loathe"
        bad += 1
      when "h8"
        bad += 1
      when "love"
        good += 1
      when "<3"
        good += 1
      when "luv"
        good += 1
      when "adore"
        good += 1
      when "lov"
        good += 1
      when "need"
        good += 1
      when "want"
        good += 1
      when "wnt"
        good += 1
      when "desire"
        good += 1
      when "loving"
        good += 1
      when "old"
        bad += 1
      when "nice"
        good += 1
      when "amazing"
        good += 1
      when "good"
        good += 1
      when "cool"
        good += 1
      when "sick"
        good += 1
      when "ossum"
        good += 1
      when "wicked"
        good += 1
      when "sweet"
        good += 1
      when "great"
        good += 1
      when "necessary"
        good += 1
      when "amaze"
        good += 1
      when "beautiful"
        good += 1
      when "gorgeous"
        good += 1
      when "required"
        good += 1
      when "healthy"
        good += 1
      when "cute"
        good += 1
      when "rancid"
        bad += 1
      when "horrible"
        bad += 1
      when "horrid"
        bad += 1
      when "horid"
        bad += 1
      when "horible"
        bad += 1
      when "bad"
        bad += 1
      when "terrible"
        bad += 1
      when "wank"
        bad += 1
      when "shit"
        bad += 1
      when "crap"
        bad += 1
      when "awful"
        bad += 1
      end
    end
    if haystack[index-1] == "over"
      if haystack[index-2] == "meet"
        good += 1
      end
    end
    if haystack[index].include?("lrn2") or haystack[index].include?("lrnto")
      good+= 1
    end
    if haystack[index].include?("&lt;3")
      good += 1
    end
    if haystack[index+1] == "is" or haystack[index+1] == "are" or haystack[index+2] == "r"
      case haystack[index+2]
      when "amazing"
        good += 1
      when "nicer"
        good += 1
      when "better"
        good += 1
      when "best"
        good += 1
      when "good"
        good += 1
      when "cool"
        good += 1
      when "sick"
        good += 1
      when "ossum"
        good += 1
      when "wicked"
        good += 1
      when "sweet"
        good += 1
      when "great"
        good += 1
      when "necessary"
        good += 1
      when "amaze"
        good += 1
      when "beautiful"
        good += 1
      when "gorgeous"
        good += 1
      when "required"
        good += 1
      when "healthy"
        good += 1
      when "cute"
        good += 1
      when "rancid"
        bad += 1
      when "horrible"
        bad += 1
      when "horrid"
        bad += 1
      when "horid"
        bad += 1
      when "horible"
        bad += 1
      when "bad"
        bad += 1
      when "terrible"
        bad += 1
      when "wank"
        bad += 1
      when "shit"
        bad += 1
      when "crap"
        bad += 1
      when "awful"
        bad += 1
      end
      if haystack[index+2] == "so" or haystack[index+2] == "fucking" or haystack[index+2] == "fuking" or haystack[index+2] == "f**king" or haystack[index+2] == "freaking"
        case haystack[index+3]
        when "amazing"
          good += 1
        when "nicer"
          good += 1
        when "better"
          good += 1
        when "best"
          good += 1
        when "good"
          good += 1
        when "cool"
          good += 1
        when "sick"
          good += 1
        when "ossum"
          good += 1
        when "wicked"
          good += 1
        when "sweet"
          good += 1
        when "great"
          good += 1
        when "necessary"
          good += 1
        when "amaze"
          good += 1
        when "beautiful"
          good += 1
        when "gorgeous"
          good += 1
        when "required"
          good += 1
        when "healthy"
          good += 1
        when "cute"
          good += 1
        when "rancid"
          bad += 1
        when "horrible"
          bad += 1
        when "horrid"
          bad += 1
        when "horid"
          bad += 1
        when "horible"
          bad += 1
        when "bad"
          bad += 1
        when "terrible"
          bad += 1
        when "wank"
          bad += 1
        when "shit"
          bad += 1
        when "crap"
          bad += 1
        when "awful"
          bad += 1
        end
      end
    end
    if haystack[index+1] == "fucking" or haystack[index+1] == "fuking" or haystack[index+1] == "f**king" or haystack[index+1] == "freaking"
      case haystack[index+2]
      when "amazing"
        good += 1
      when "good"
        good += 1
      when "cool"
        good += 1
      when "sick"
        good += 1
      when "ossum"
        good += 1
      when "wicked"
        good += 1
      when "sweet"
        good += 1
      when "great"
        good += 1
      when "necessary"
        good += 1
      when "amaze"
        good += 1
      when "beautiful"
        good += 1
      when "gorgeous"
        good += 1
      when "required"
        good += 1
      when "healthy"
        good += 1
      when "cute"
        good += 1
      when "rancid"
        bad += 1
      when "horrible"
        bad += 1
      when "horrid"
        bad += 1
      when "horid"
        bad += 1
      when "horible"
        bad += 1
      when "bad"
        bad += 1
      when "terrible"
        bad += 1
      when "wank"
        bad += 1
      when "shit"
        bad += 1
      when "crap"
        bad += 1
      when "awful"
        bad += 1
      end
    end
    if haystack[index+2] == "the" or haystack[index+2] == "tha"
      case haystack[index+3]
      when "bomb"
        good += 1
      when "shit"
        good += 1
      when "best"
        good += 1
      end
    end
    unless good == 0 and bad == 0
      if good > bad
        return "good"
      else
        return "bad"
      end
    else
      i = index
      while i >= 0
        case haystack[index-i]
        when "prefer"
          good += 1
        when "checked"
          good += 1
        when "check"
          good += 1
        when "free"
          good += 1
        when "best"
          good += 1
        when "shit"
          bad += 1
        when "nom"
          good += 1
        end
        i = i-1
      end
      i = index
      while i <= haystack.length
        case haystack[index+i]
        when "prefer"
          good += 1
        when "checked"
          good += 1
        when "check"
          good += 1
        when "free"
          good += 1
        when "best"
          good += 1
        when "shit"
          bad += 1
        when "nom"
          good += 1
        when "stupid"
          bad += 1
        when "down"
          bad += 1
        when "up"
          good += 1
        when "downhill"
          bad += 1
        end
        i += 1
      end
      unless good == 0 and bad == 0
        if good > bad
          return "good"
        else
          return "bad"
        end
      else
        return "neutral"
      end
    end
  end

  def check_topics(tweet, hash)
    tweet.downcase!
    words = tweet.split
    hash.each_pair do |k,v|
      if v.empty? 
        hash[k]["count"] = 0
        hash[k]["good"] = 0
        hash[k]["bad"] = 0
        hash[k]["pc_good"] = 0
        hash[k]["pc_bad"] = 0
      end
      find = haystack_search(words, k)
      if find
        if find_sentiment(words, find) == "good"
          hash[k]["good"] = hash[k]["good"].to_i + 1
        elsif find_sentiment(words, find) == "bad"
          hash[k]["bad"] = hash[k]["bad"].to_i + 1
        else
          #neutral
        end
        hash[k]["count"] = hash[k]["count"].to_i + 1
      end
    end
    hash.each_pair do |k,v|
      percent_good = hash[k]["good"].to_f / hash[k]["count"].to_f * 100.0
      unless percent_good.nan?
        hash[k]["pc_good"] = percent_good.to_i
      else
        hash[k]["pc_good"] = 0
      end
      percent_bad = hash[k]["bad"].to_f / hash[k]["count"].to_f * 100.0
      unless percent_bad.nan?
        hash[k]["pc_bad"] = percent_bad.to_i
      else
        hash[k]["pc_bad"] = 0
      end
    end
    return hash
  end
end