require 'time_entry_model_patch'

Redmine::Plugin.register :redmine_negative_time_log do
  name 'Redmine Negative Time Log plugin'
  author 'Nazar Hussain'
  description 'Redmine Plugin to allow negative time entries'
  version '0.0.1'
  url 'http://github.com/nazarhussain/redmine_negative_time_log'
  author_url 'https://github.com/nazarhussain'

  unless ProjectCustomField.exists?(:name => 'Allow Negative Time Log')
    ProjectCustomField.create(
        :name => 'Allow Negative Time Log',
        :field_format => 'bool',
        :is_required => false,
        :description => 'Custom filed to store option for negative time log'
    )
  end

  # Here I have support for Redmine 1.x by falling back on Rails 2.x implementation.
  if Gem::Version.new("3.0") > Gem::Version.new(Rails.version) then
    Dispatcher.to_prepare do
      # This tells the Redmine version's controller to include the module from the file above.
      TimeEntry.send(:include, NegativeTimeLog::TimeEntryModelPatch)
    end
  else
    # Rails 3.0 implementation.
    Rails.configuration.to_prepare do
      # This tells the Redmine version's controller to include the module from the file above.
      TimeEntry.send(:include, NegativeTimeLog::TimeEntryModelPatch)
    end
  end
end
