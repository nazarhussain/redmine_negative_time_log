module NegativeTimeLog
  module TimeEntryModelPatch
    def self.included(base)
      base.class_eval do
        validate :validate_negative_time_entry

        def validate_negative_time_entry
          self.project.custom_field_values.each do |field|
            if field.custom_field.name == 'Allow Negative Time Log' and field.value.to_i == 1
              errors.delete :hours if hours and hours < 0
            end
          end
        end
      end
    end
  end
end
