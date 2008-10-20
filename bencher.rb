class Bencher
  
  @@benchmarks = {}
  @@running = {}
  
  def self.bench(key, time)
    @@benchmarks[key] = 0 unless @@benchmarks.has_key?(key)
    @@benchmarks[key] = @@benchmarks[key] + time
  end
  
  def self.start(name)
    @@running[name] = Time.now
  end
  
  def self.stop(name)
    if @@running[name].nil?
      raise "Didn't start '#{name}'"
    end
    bench(name, Time.now - @@running[name])
  end
  
  def self.inspect
    return "" if @@benchmarks.empty?
    
    result = []
    
    max_length = @@benchmarks.max {|a,b| a.first.length <=> b.first.length }.first.length
    
    # Time sort
    #@@benchmarks.sort{|a,b| b.last <=> a.last }.each do |key, value|
    
    # Alphabetical sort
    @@benchmarks.sort.each do |key, value|
      string = key
      0.upto(max_length + 3 - key.length) do
        string = string + " "
      end
      string = string + value.to_s
      
      result << string
    end
    result.join("\n")
  end
  
end