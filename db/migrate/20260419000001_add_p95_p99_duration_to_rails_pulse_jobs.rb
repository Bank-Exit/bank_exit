# Add P95 and P99 duration columns to rails_pulse_jobs table
class AddP95P99DurationToRailsPulseJobs < ActiveRecord::Migration[7.0]
  def up
    # Add p95_duration column if it doesn't exist
    unless column_exists?(:rails_pulse_jobs, :p95_duration)
      add_column :rails_pulse_jobs, :p95_duration, :decimal, precision: 15, scale: 6,
                                                             comment: '95th percentile duration in milliseconds'
    end

    # Add p99_duration column if it doesn't exist
    return if column_exists?(:rails_pulse_jobs, :p99_duration)

    add_column :rails_pulse_jobs, :p99_duration, :decimal, precision: 15, scale: 6,
                                                           comment: '99th percentile duration in milliseconds'
  end

  def down
    # Remove p95_duration column if it exists
    remove_column :rails_pulse_jobs, :p95_duration if column_exists?(:rails_pulse_jobs, :p95_duration)

    # Remove p99_duration column if it exists
    return unless column_exists?(:rails_pulse_jobs, :p99_duration)

    remove_column :rails_pulse_jobs, :p99_duration
  end
end
