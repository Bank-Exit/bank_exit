SimpleCov.configure do
  load_profile 'rails'
  cover_views

  group 'Policies', 'app/policies'
  group 'Services', 'app/services'
  group 'Serializers', %w[app/serializers app/blueprints]
  group 'Decorators', 'app/decorators'
  group 'Presenters', 'app/presenters'

  skip 'app/controllers/concerns/http_auth_concern.rb'
  skip 'app/jobs/rake_task_job.rb'
  skip 'lib/tasks/annotate_rb.rake'
  skip 'app/channels'
  skip 'app/views/pwa'
  skip 'app/views/rswag'
end
