# Enter your code here. Read input from STDIN. Print output to STDOUT
def cipher(key)
  a = key.split(//).uniq
  order_hash = {}
  a.each{|x| order_hash[x] = []}
  alph = ("A".."Z").to_a
  b = (alph - a)
  (0..(b.size - 1)).each do |x|
    order_hash[a[x % a.size]] << b[x]
  end
  c = order_hash.keys.sort
  order = c.map{|x| x + order_hash[x].join("")}.join("")
  alph = alph.join("")
  hash = {}
  (0..25).each{|x| hash[order[x]] =alph[x] }
  return hash
end

def decode(msg,key)
  hash = cipher(key)
  b = []
  msg.each{|x| b << x.split(//).map{|y| hash[y]}.join("")}
  return b.join(" ")
end

inp = $stdin.read
a = inp.split("\n")
n = a[0].to_i
(1..n).each do |x|
  key = a[2*x - 1]
  msg = a[2*x].split(' ')
  puts decode(msg,key)
end