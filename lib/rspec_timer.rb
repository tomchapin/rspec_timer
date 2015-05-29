require 'rspec_timer/version'
require 'singleton'
require 'forwardable'
require 'digest/md5'

class RspecTimer
  include Singleton
  extend SingleForwardable

  def_delegators :instance, :reset_metrics, :start_measurement, :end_measurement, :metrics, :run_and_measure, :save_metrics_to_file

  attr_reader :metrics

  def initialize
    reset_metrics
  end

  def reset_metrics
    @metrics = {}
  end

  def start_measurement(example)
    current_metrics              = metrics_for(example)
    current_metrics[:signature]  = signature_for(example)
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

  def save_metrics_to_file(file_name)
    File.write(file_name, YAML.dump(@metrics))
  end

  private

  def metrics_for(example)
    @metrics[example_path(example)] ||= {
        start_time: nil,
        end_time:   nil,
        total_time: nil,
        signature:  nil
    }
  end

  def signature_for(example)
    Digest::MD5.hexdigest(example.example.instance_variable_get(:@example_block).source.to_s)
  end

  def example_path(example)
    "#{example.metadata[:file_path]}:#{example.metadata[:line_number]}"
  end

end