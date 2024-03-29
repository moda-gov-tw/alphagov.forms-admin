require "uri"

class Forms::PrivacyPolicyForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :form, :privacy_policy_url

  validates :privacy_policy_url, presence: true, if: -> { validate_presence }
  validates :privacy_policy_url, url: true, if: -> { privacy_policy_url.present? }

  def submit
    return false if invalid?

    form.privacy_policy_url = privacy_policy_url
    form.save!
  end

  def assign_form_values
    self.privacy_policy_url = form.privacy_policy_url
    self
  end

private

  def validate_presence
    return false if FeatureService.enabled?(:draft_live_versioning)

    form.has_live_version
  end
end
