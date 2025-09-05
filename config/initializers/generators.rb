Rails.application.config.generators do |g|
  g.assets false
  g.helper false
  g.jbuilder false
  g.view_specs false
  g.routing_specs false
  g.test_framework nil
  g.system_tests nil
  g.template_engine :slim
end
