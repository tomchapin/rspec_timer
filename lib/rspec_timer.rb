require 'rspec_timer/version'
require 'singleton'
require 'forwardable'
require 'digest/md5'

class RspecTimer
  include Singleton
  extend SingleForwardable

  def_delegators :instance, :reset_metrics, :log_file_path, :log_file_path=, :start_measurement, :end_measurement,
                 :metrics, :run_and_measure, :wipe_stored_metrics, :save_metrics, :signature_for

  attr_reader :metrics
  attr_accessor :log_file_path

  def initialize
    reset_metrics
    @log_file_path ||= 'rspec_metrics.yml'
  end

  def reset_metrics
    @metrics = {}
  end

  def start_measurement(example)
    current_metrics              = metrics_for(example)
    current_metrics[:path]       = example_path(example)
    current_metrics[:start_time] = Time.now
    example
  end

  def end_measurement(example)
    current_metrics              = metrics_for(example)
    current_metrics[:end_time]   = Time.now
    current_metrics[:total_time] = current_metrics[:end_time] - current_metrics[:start_time]
    example
  end

  def run_and_measure(example)
    start_measurement(example)
    example.run
    end_measurement(example)
  end

  def wipe_stored_metrics
    File.write(log_file_path, YAML.dump({}))
  end

  def save_metrics
    updated_metrics = {}
    # Load any existing metrics
    updated_metrics = YAML.load_file(log_file_path) if File.exists? (log_file_path)
    # Merge in the new metrics, updating any existing ones
    @metrics.keys.each { |key| updated_metrics[key] = @metrics[key] }
    # Save metrics to the YAML log file
    File.write(log_file_path, YAML.dump(updated_metrics))
  end

  def signature_for(example)
    Digest::MD5.hexdigest("#{example_path(example)}:#{example.example.instance_variable_get(:@example_block).source.to_s}")
  end

  private

  def metrics_for(example)
    @metrics[signature_for(example)] ||= {
        path:       nil,
        start_time: nil,
        end_time:   nil,
        total_time: nil
    }
  end

  def example_path(example)
    "#{example.metadata[:file_path]}:#{example.metadata[:line_number]}"
  end

end