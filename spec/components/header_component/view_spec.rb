require "rails_helper"

RSpec.describe HeaderComponent::View, type: :component do
  let(:user) do
    build(:user)
  end

  describe "default status" do
    before do
      render_inline(described_class.new(nil))
    end

    it "contains the service name" do
      expect(page).to have_text(I18n.t("header.product_name"))
    end

    it "does not contain the profile link" do
      expect(page).not_to have_link(user.name, href: "http://signon.dev.gov.uk")
    end

    it "does not contain the sign out link" do
      expect(page).not_to have_link(I18n.t("header.sign_out"), href: "/auth/gds/sign_out")
    end
  end

  describe "logged in status" do
    before do
      render_inline(described_class.new(user))
    end

    it "contains the service name" do
      expect(page).to have_text(I18n.t("header.product_name"))
    end

    it "contains the profile link" do
      expect(page).to have_link(user.name, href: "http://signon.dev.gov.uk")
    end

    it "contains the sign out link" do
      expect(page).to have_link(I18n.t("header.sign_out"), href: "/auth/gds/sign_out")
    end
  end

  context "when basic auth is enabled" do
    before do
      basic_auth_double = object_double("basic_auth_double", enabled: true)
      allow(Settings).to receive(:basic_auth).and_return(basic_auth_double)
      render_inline(described_class.new(user))
    end

    it "the user name appears without a link" do
      expect(page).not_to have_link(user.name)
      expect(page).to have_text(user.name)
    end

    it "Signout appears without a link" do
      expect(page).not_to have_link(I18n.t("header.sign_out"))
      expect(page).to have_text(I18n.t("header.sign_out"))
    end
  end
end
