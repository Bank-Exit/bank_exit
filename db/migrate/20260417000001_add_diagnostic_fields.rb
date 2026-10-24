class AddDiagnosticFields < ActiveRecord::Migration[7.0]
  def change
    add_column :rails_pulse_operations, :row_count, :integer unless column_exists?(:rails_pulse_operations, :row_count)
    add_column :rails_pulse_operations, :cache_hit, :boolean, null: false, default: false unless column_exists?(:rails_pulse_operations, :cache_hit)
    add_column :rails_pulse_operations, :repeated_query_group, :text unless column_exists?(:rails_pulse_operations, :repeated_query_group)
    add_column :rails_pulse_operations, :repetition_count, :integer unless column_exists?(:rails_pulse_operations, :repetition_count)
    return if column_exists?(:rails_pulse_requests, :response_size_bytes)

    add_column :rails_pulse_requests, :response_size_bytes, :integer
  end
end
