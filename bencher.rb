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
    @@benchmarks.inspect
  end
  
end