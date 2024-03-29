class Forms::WhatHappensNextForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :form, :what_happens_next_text

  validates :what_happens_next_text, presence: true, if: -> { validate_presence }
  validates :what_happens_next_text, length: { maximum: 2000 }

  def submit
    return false if invalid?

    form.what_happens_next_text = what_happens_next_text
    form.save!
  end

  def assign_form_values
    self.what_happens_next_text = form.what_happens_next_text
    self
  end

private

  def validate_presence
    return false if FeatureService.enabled?(:draft_live_versioning)

    form.has_live_version
  end
end
