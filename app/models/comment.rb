class Comment < ApplicationRecord
  include WithCaptcha

  enum :flag_reason, spam: 0, violent: 1, sexual: 2,
                     hate: 3, harassment: 4, terrorism: 5,
                     child_abuse: 6, illegal: 7, other: 8

  attribute :affidavit, :boolean
  captcha :nickname

  belongs_to :commentable, polymorphic: true, counter_cache: true

  default_scope -> { order(updated_at: :desc) }

  scope :flagged, -> { where.not(flag_reason: nil) }
  scope :available, -> { where(flag_reason: nil) }

  validates :flag_reason, allow_nil: true, inclusion: { in: flag_reasons.keys }
  validates :content, presence: true
  validates :rating, presence: true, inclusion: { in: (0..5) }
  validates :language, presence: true
  validates :affidavit, presence: true, acceptance: true, on: :create
end

# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text             not null
#  rating           :integer          default(0), not null
#  language         :string           not null
#  pseudonym        :string
#  commentable_type :string           not null
#  commentable_id   :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  flag_reason      :integer
#
# Indexes
#
#  index_comments_on_commentable  (commentable_type,commentable_id)
#
