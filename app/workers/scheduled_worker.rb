class ScheduledWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  def perform(last_occurrence=0, current_occurrence=Time.now.to_f)
    now = Time.now.to_f
    logger.info "now: #{now} last: #{last_occurrence} (#{now-last_occurrence}) current: #{current_occurrence} (#{now-current_occurrence})"
    if current_occurrence < Time.now.to_f - 30
      logger.warn "skipping old job (#{current_occurrence})"
      return false
    else
      return true
    end
  end
end
