require "rails_helper"

describe TaskStatusService do
  let(:task_status_service) do
    described_class.new(form:)
  end

  describe "statuses" do
    describe "name status" do
      let(:form) { build(:form, :new_form) }

      it "returns the correct default value" do
        expect(task_status_service.name_status).to eq :completed
      end
    end

    describe "pages status" do
      context "with a new form" do
        let(:form) { build(:form, :new_form) }

        it "returns the correct default value" do
          expect(task_status_service.pages_status).to eq :not_started
        end
      end

      context "with a form which has pages" do
        let(:form) { build(:form, :new_form, :with_pages, question_section_completed: false) }

        it "returns the in progress status" do
          expect(task_status_service.pages_status).to eq :in_progress
        end

        context "and questions marked completed" do
          let(:form) { build(:form, :new_form, :with_pages, question_section_completed: true) }

          it "returns the completed status" do
            expect(task_status_service.pages_status).to eq :completed
          end
        end
      end
    end

    describe "declaration status" do
      context "with a new form" do
        let(:form) { build(:form, :new_form) }

        it "returns the correct default value" do
          expect(task_status_service.declaration_status).to eq :not_started
        end
      end

      context "with a form which has no declaration content and is marked incomplete" do
        let(:form) { build(:form, declaration_section_completed: false) }

        it "returns the not started status" do
          expect(task_status_service.declaration_status).to eq :not_started
        end
      end

      context "with a form which has declaration content and is marked incomplete" do
        let(:form) { build(:form, declaration_text: "I understand the implications", declaration_section_completed: false) }

        it "returns the in progress status" do
          expect(task_status_service.declaration_status).to eq :in_progress
        end
      end

      context "with a form which has a declaration marked complete" do
        let(:form) { build(:form, declaration_section_completed: true) }

        it "returns the completed status" do
          expect(task_status_service.declaration_status).to eq :completed
        end
      end
    end

    describe "what happens next status" do
      context "with a new form" do
        let(:form) { build(:form, :new_form) }

        it "returns the correct default value" do
          expect(task_status_service.what_happens_next_status).to eq :not_started
        end
      end

      context "with a form which has a what happens next section" do
        let(:form) { build(:form, :new_form, what_happens_next_text: "We usually respond to applications within 10 working days.") }

        it "returns the in progress status" do
          expect(task_status_service.what_happens_next_status).to eq :completed
        end
      end
    end

    describe "submission email status" do
      context "with a new form" do
        let(:form) { build(:form, :new_form) }

        it "returns the correct default value" do
          expect(task_status_service.submission_email_status).to eq :not_started
        end
      end

      context "with a form which has an email set" do
        let(:form) { build(:form, :new_form, submission_email: Faker::Internet.email(domain: "example.gov.uk")) }

        it "returns the in progress status" do
          expect(task_status_service.submission_email_status).to eq :completed
        end
      end
    end

    describe "privacy policy status" do
      context "with a new form" do
        let(:form) { build(:form, :new_form) }

        it "returns the correct default value" do
          expect(task_status_service.privacy_policy_status).to eq :not_started
        end
      end

      context "with a form which has a privacy policy section" do
        let(:form) { build(:form, :new_form, privacy_policy_url: Faker::Internet.url(host: "gov.uk")) }

        it "returns the in progress status" do
          expect(task_status_service.privacy_policy_status).to eq :completed
        end
      end
    end

    describe "support contact details status status" do
      context "with a new form" do
        let(:form) { build(:form, :new_form) }

        it "returns the correct default value" do
          expect(task_status_service.support_contact_details_status).to eq :not_started
        end
      end

      context "with a form which has contact details set" do
        let(:form) { build(:form, :new_form, :with_support) }

        it "returns the in progress status" do
          expect(task_status_service.support_contact_details_status).to eq :completed
        end
      end
    end

    describe "make live status" do
      context "with a new form" do
        let(:form) { build(:form, :new_form) }

        it "returns the correct default value" do
          expect(task_status_service.make_live_status).to eq :cannot_start
        end
      end

      context "with a form which is ready to go live" do
        let(:form) { build(:form, :ready_for_live) }

        it "returns the not started status" do
          expect(task_status_service.make_live_status).to eq :not_started
        end
      end

      context "with a live form" do
        let(:form) { build(:form, :live) }

        it "returns the completed status" do
          expect(task_status_service.make_live_status).to be_nil
        end
      end
    end
  end

  describe "#mandatory_tasks_completed" do
    context "when mandatory tasks have not been completed" do
      let(:form) { build(:form, :new_form) }

      it "returns false" do
        expect(task_status_service.mandatory_tasks_completed?).to eq false
      end
    end

    context "when mandatory tasks have been completed" do
      let(:form) { build(:form, :ready_for_live) }

      it "returns true" do
        expect(task_status_service.mandatory_tasks_completed?).to eq true
      end
    end
  end

  describe "#status_counts" do
    let(:form) { build :form }

    it "returns a hash containing total count of completed task and total number of tasks" do
      allow(task_status_service).to receive(:all_task_status).and_return(%i[completed completed something_else])
      expect(task_status_service.status_counts).to eq({ completed: 2, total: 3 })
    end
  end
end
