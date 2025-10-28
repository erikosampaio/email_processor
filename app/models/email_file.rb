class EmailFile < ApplicationRecord
  validates :filename, presence: true
  validates :content, presence: true
  validates :uploaded_at, presence: true

  scope :recent, -> { order(uploaded_at: :desc) }
end
