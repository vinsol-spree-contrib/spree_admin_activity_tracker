Spree::Admin::BaseHelper.module_eval do
  def pretty_json(json)
    JSON.pretty_generate(json)
  end
end
