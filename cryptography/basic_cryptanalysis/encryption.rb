
def get_config(word)
  config = {}
  i=0
  word.split('').each do |x|
    config[x] = config[x].nil? ? [i] : config[x]+[i]
    i = i+1
  end
  return config
end

def word_with_same_config(dict, config)
  config_count = 0
  map = nil
  dict.each do |x|
    x_config = get_config(x)
    if (x_config.values == config.values)
      config_count = config_count + 1
      map = x_config if (config_count==1)
    end
  end
  if config_count==1
    return map
  end
  return nil
end

def word_with_partial_map(mapping, config, dict)
  return nil if mapping.values.compact.size == 0
  config_count = 0
  map = nil
  dict.each do |x|
    x_config = get_config(x)
    if (x_config.values == config.values)
      flag = true
      config.keys.each do |y|
        if mapping[y]==x_config.keys[config.keys.index(y)]
          flag = flag && true
        elsif !mapping[y].nil? && mapping[y]!=x_config.keys[config.keys.index(y)]
          flag = flag && false
        end
      end
      if flag
        config_count = config_count + 1
        map = x_config if (config_count==1)
      end
    end
  end
  if config_count==1
    return map
  end
  return nil
end

inp = $stdin.read
dict = []
dict_hash = {}
mapping = {}
File.open("dictionary.lst", "r") do |f|
  f.each_line do |line|
    dict << line.strip
    a = line.strip.size()
    dict_hash[a.to_s] = dict_hash[a.to_s].nil? ? [line.chomp.downcase] : (dict_hash[a.to_s] + [line.chomp.downcase])
    line.chomp.split('').each{|x| mapping[x]=nil}
  end
end
words = inp.split(" ").sort_by {|x| x.length}.reverse
words.each do |word|
  len = word.size
  config = get_config(word)
  flag = false
  map1 = word_with_partial_map(mapping,config,dict_hash[len.to_s])
  if map1.nil?
    map2 = word_with_same_config(dict_hash[len.to_s], config)
    unless map2.nil?
      config.keys.each do |i|
        mapping[i] = map2.keys[config.keys.index(i)]
      end
      break if flag
    end
  else
    config.keys.each do |i|
      mapping[i] = map1.keys[config.keys.index(i)]
    end
    break if flag
  end
  unless mapping.values.include? nil
    break
  end
end
puts inp.split(" ").map{|a| a.split('').map{|x| mapping[x] }.join('') }.join(" ")
