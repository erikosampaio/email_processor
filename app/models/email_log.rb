class EmailLog < ApplicationRecord
  validates :filename, presence: true
  validates :status, presence: true, inclusion: { in: %w[success failure] }
  validates :processed_at, presence: true

  scope :successful, -> { where(status: 'success') }
  scope :failed, -> { where(status: 'failure') }
  scope :recent, -> { order(processed_at: :desc) }
end
