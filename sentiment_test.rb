topics = Hash["weather", Hash.new, "football", Hash.new, "soccer", Hash.new, "rugby", Hash.new, "cricket", Hash.new, "hockey", Hash.new, "mac", Hash.new, "windows", Hash.new, "linux", Hash.new, "google", Hash.new, "microsoft", Hash.new, "starbucks", Hash.new, "wendy", Hash.new, "pret", Hash.new, "dunkin", Hash.new, "coffee", Hash.new, "costa", Hash.new, "iphone", Hash.new, "apple", Hash.new, "android", Hash.new, "blackberry", Hash.new]
prohibited_words = ['shit', 'fuck', 'fucking', 'cunt', ':(', '>:(', ":'(", "ffs", "angry", "hate", "fuking", "f**king", "awful", "terrible", "crap", "horrid", "horrible", "wank"]

def find_sentiment(haystack, index, bad_words)
  good = 0
  bad = 0
  if haystack[index-1] == "my" or haystack[index-1] == "mi" or haystack[index-1] == "me"
    case haystack[index-2]
    when "run"
      good += 1
    when "love"
      good += 1
    when "luv"
      good += 1
    when "&lt;3"
      good += 1
    when "<3"
      good += 1
    when "go"
      good += 1
    when "went"
      good += 1
    when "want"
      if haystack[index-3] == "don't" or haystack[index-3] == "dont" or haystack[index-3] == "dnt"
        bad += 1
      else
        good += 1
      end
    when "hate"
      bad += 1
    when "h8"
      bad += 1
    when "need"
      good += 1
    end
  end
  if haystack[index-1] == "to"
    if haystack[index-2] == "go"
      if haystack[index-3] == "to"
        if haystack[index-4] == "love"
          good += 1
        end
        if haystack[index-4] == "want"
          unless haystack[index-5] == "dont" or haystack[index-5] == "don't" or haystack[index-5] == "dnt"
            good += 1
          else
            bad += 1
          end
        end
      elsif haystack[index-3] == "please"
        good += 1
      end
    end
    case haystack[index-2]
    when "run"
      good += 1
    when "love"
      good += 1
    when "luv"
      good += 1
    when "&lt;3"
      good += 1
    when "<3"
      good += 1
    when "go"
      good += 1
    when "went"
      good += 1
    when "want"
      if haystack[index-3] == "don't" or haystack[index-3] == "dont" or haystack[index-3] == "dnt"
        bad += 1
      else
        good += 1
      end
    when "hate"
      bad += 1
    when "h8"
      bad += 1
    when "need"
      good += 1
    end
  elsif haystack[index-1] == "at" or haystack[index-1] == "@"
    if haystack[index-2] == "i'm" or haystack[index-2] == "im" or haystack[index-2] == "am"
      good += 1
    end  
    if haystack[index-2] == "work" or haystack[index-2] == "working" or haystack[index-2] == "woking" or haystack[index-2] == "be"
      case haystack[index-3]
      when "hate"
        bad += 1
      when "h8"
        bad += 1
      when "hating"
        bad += 1
      when "love"
        good += 1
      when "luv"
        good += 1
      when "&lt;3"
        good += 1
      when "<3"
        good += 1
      when "to"
        case haystack[index-4]
        when "hate"
          bad += 1
        when "hating"
          bad += 1
        when "h8"
          bad += 1
        when "love"
          good += 1
        when "luv"
          good += 1
        when "&lt;3"
          good += 1
        when "<3"
          good += 1
        end
      when "be"
        if haystack[index-4] == "to"
          case haystack[index-5]
          when "hate"
            bad += 1
          when "hating"
            bad += 1
          when "h8"
            bad += 1
          when "love"
            good += 1
          when "luv"
            good += 1
          when "&lt;3"
            good += 1
          when "<3"
            good += 1
          end
        end
      end
    elsif haystack[index-2] == "job"
      case haystack[index-3]
      when "want"
        if haystack[index-4] == "don't" or haystack[index-4] == "dont" or haystack[index-4] == "dnt"
          bad += 1
        else
          good += 1
        end
      when "a"
        case haystack[index-4]
        when "want"
          if haystack[index-5] == "don't" or haystack[index-5] == "dont" or haystack[index-5] == "dnt"
            bad += 1
          else
            good += 1
          end
        when "need"
          good += 1
        when "&lt;3"
          good += 1
        when "<3"
          good += 1
        when "hate"
          bad += 1
        when "h8"
          bad += 1
        when "luv"
          good += 1
        when "love"
          good += 1
        when "hating"
          bad += 1
        end
      when "my"
        case haystack[index-4]
        when "want"
          if haystack[index-5] == "don't" or haystack[index-5] == "dont" or haystack[index-5] == "dnt"
            bad += 1
          else
            good += 1
          end
        when "wnt"
          if haystack[index-5] == "don't" or haystack[index-5] == "dont" or haystack[index-5] == "dnt"
            bad += 1
          else
            good += 1
          end
        when "need"
          good += 1
        when "&lt;3"
          good += 1
        when "<3"
          good += 1
        when "hate"
          bad += 1
        when "h8"
          bad += 1
        when "luv"
          good += 1
        when "love"
          good += 1
        when "hating"
          bad += 1
        end
      end
    end
  end
  if haystack[index-1] == "me" or haystack[index-1] == "you"
    case haystack[index-2]
    when "bring"
      good += 1
    when "brings"
      good += 1
    when "buy"
      good += 1
    when "buys"
      good += 1
    when "getting"
      unless haystack[index-3] == "not"
        good += 1
      else
        bad += 1
      end
    when "get"
      good += 1
    when "gets"
      good += 1
    end
  end
  if haystack[index-1] == "want" or haystack[index-1] == "wnt"
    if haystack[index-2] == "don't" or haystack[index-2] == "dont" or haystack[index-2] == "dnt"
      bad += 1
    else
      good += 1
    end
  end
  if haystack[index-1] == "help" or haystack[index-1] == "helping" or haystack[index-1] == "helped"
    good += 1
  end
  if haystack[index-1] == "is"
    case haystack[index-2]
    when "heart"
      good += 1
    when "<3"
      good += 1
    when "&lt;3"
      good += 1
    when "need"
      good += 1
    when "want"
      if haystack[index-3] == "don't" or haystack[index-3] == "dont" or haystack[index-3] == "dnt"
        bad += 1
      else
        good += 1
      end
    when "wnt"
      if haystack[index-3] == "don't" or haystack[index-3] == "dont" or haystack[index-3] == "dnt"
        bad += 1
      else
        good += 1
      end
    when "have"
      if haystack[index-3] == "must"
        good += 1
      elsif haystack[index-3] == "to"
        case haystack[index-4]
        when "need"
          good += 1
        when "want"
          if haystack[index-4] == "don't" or haystack[index-4] == "dont" or haystack[index-4] == "dnt"
            bad += 1
          else
            good += 1
          end
        when "wnt"
          if haystack[index-4] == "don't" or haystack[index-4] == "dont" or haystack[index-4] == "dnt"
            bad += 1
          else
            good += 1
          end
        end
      end
    end
  end
  if haystack[index-1] == "for"
    case haystack[index-2]
    when "time"
      good += 1
    when "go"
      good += 1
    when "going"
      good += 1
    when "desire"
      good += 1
    when "hate"
      bad += 1
    when "h8"
      bad += 1
    when "love"
      good += 1
    when "&lt;3"
      good += 1
    when "<3"
      good += 1
    end
  end
  if haystack[index-1] == "a" or haystack[index-1] == "an" or haystack[index-1] == "some" or haystack[index-1] == "sum"
    case haystack[index-2]
    when "want"
      case haystack[index-3]
      when "really"
        good += 1
      when "rlly"
        good += 1
      when "rely"
        good += 1
      when "realy"
        good += 1
      when "rly"
        good += 1
      when "don't"
        bad += 1
      when "dont"
        bad += 1
      when "dnt"
        bad += 1
      else 
        good += 1
      end
    when "for"
      case haystack[index-3]
      when "time"
        good += 1
      when "go"
        good += 1
      when "going"
        good += 1
      when "desire"
        good += 1
      when "hate"
        bad += 1
      when "h8"
        bad += 1
      when "love"
        good += 1
      when "&lt;3"
        good += 1
      when "<3"
        good += 1
      end
    when "need"
      case haystack[index-3]
      when "really"
        good += 1
      when "rlly"
        good += 1
      when "rely"
        good += 1
      when "realy"
        good += 1
      when "rly"
        good += 1
      when "don't"
        bad += 1
      when "dont"
        bad += 1
      when "dnt"
        bad += 1
      else
        good += 1
      end
    when "wnt"
      case haystack[index-3]
      when "really"
        good += 1
      when "rlly"
        good += 1
      when "rely"
        good += 1
      when "realy"
        good += 1
      when "rly"
        good += 1
      when "don't"
        bad += 1
      when "dont"
        bad += 1
      when "dnt"
        bad += 1
      else 
        good += 1
      end
    end
  end
  if haystack[index+1] == "delivered"
    good += 1
  elsif haystack[index+1] == "gets"
    if haystack[index+2] == "delivered"
      good += 1
    end
  end
  if haystack[index+1] == "run"
    good += 1
  end
  case haystack[index+1]
  when "with"
    good += 1
  when "w"
    good += 1
  when "w/"
    good += 1
  when "please"
    good += 1
  when "pls"
    good += 1
  when "time"
    good += 1
  when "is"
    case haystack[index+2]
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
  end
  if good > bad
    return "good"
  elsif bad > good
    return "bad"
  else
    if good == 0 and bad == 0
      if includes_bad(haystack, bad_words)
        return "bad"
      else
        return "good"
      end
    else
      return "neutral"
    end
  end
end

def includes_bad(haystack, bad_words)
  haystack.each do |word|
    if bad_words.include?(word)
      return true
    end
  end
  return false
end

def haystack_search(haystack, needle)
  haystack.each_with_index do |value, index|
    if value.include?(needle)
      return index
    end
  end
  return false
end

def check_topics(tweet, hash, bad_words)
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
      sentiment = find_sentiment(words, find, bad_words)
      if sentiment == "good"
        hash[k]["good"] = hash[k]["good"].to_i + 1
      elsif sentiment == "bad"
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

check_topics("I want a job at Starbucks because I’m going to spell everyone’s name wrong so they can’t instagram their cups", topics, prohibited_words)
check_topics("Hate to be at starbucks right now", topics, prohibited_words)
check_topics("hate working at starbucks!", topics, prohibited_words)
check_topics("<3 working at starbucks", topics, prohibited_words)
check_topics("hate to be working at starbucks!", topics, prohibited_words)
check_topics("Love to go to Starbucks right now!", topics, prohibited_words)
check_topics("don't want to starbucks right now!", topics, prohibited_words)
check_topics("really need a starbucks right now!!!", topics, prohibited_words)
check_topics("need a starbucks right now", topics, prohibited_words)
check_topics("The key to my heart is Starbucks", topics, prohibited_words)
check_topics("If he buys you Starbucks, you know he's a keeper. ☕️💕", topics, prohibited_words)
check_topics("So my plans today were to wake up early and run to Starbucks. Instead it rained and I'm searching the net for fat food #PureWhiteGirlBlood", topics, prohibited_words)
check_topics("I just want some Starbucks.", topics, prohibited_words)
check_topics("I want Starbucks", topics, prohibited_words)
check_topics("starbucks😍🎄 http://t.co/lH8PE0yHWi", topics, prohibited_words)
check_topics("I'm at Starbucks Coffee (Mubarak Al-Kabeer) http://t.co/xIFVrqQ1UC", topics, prohibited_words)

p topics

