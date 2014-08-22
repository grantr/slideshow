# class TestWorker
#   include Sidekiq::Worker
#   include Sidetiq::Schedulable
#
#   recurrence backfill: false do
#    secondly(30)
#  end
#
#   def perform(last_occurrence=0, current_occurrence=Time.now.to_f)
    # now = Time.now.to_f
    # logger.info "now: #{now} last: #{last_occurrence} (#{now-last_occurrence}) current: #{current_occurrence} (#{now-current_occurrence})"
#     if last_occurrence < now - 30
#       logger.info "too old"
#     end
#   end
# end
