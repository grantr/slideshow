class DropboxWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence backfill: false do
    secondly(30)
  end

  def perform(last_occurrence, current_occurrence)
  end
end
