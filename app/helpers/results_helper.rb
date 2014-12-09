module ResultsHelper
  def self.raw_to_model(results, model)
    models = []
    results.each do |r|
      models << hash_to_model(r, model)
    end
    models
  end

  def self.hash_to_model(model_hash, model)
    model = model.constantize.new() 
    attrs = model_hash.reject{|k,v| !model.attributes.keys.member?(k.to_s) }
    model.attributes = attrs
    model
  end
end
