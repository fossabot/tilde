# == Schema Information
#
# Table name: invitations
#
#  code_of_conduct      :boolean          default(FALSE)
#  created_at           :datetime         not null
#  delivered            :boolean          default(FALSE)
#  id                   :integer          not null, primary key
#  invitee_company      :string
#  invitee_email        :string
#  invitee_introduction :text
#  invitee_location     :string
#  invitee_name         :string
#  invitee_title        :string
#  member_application   :boolean          default(FALSE)
#  registered           :boolean          default(FALSE)
#  updated_at           :datetime         not null
#  user_id              :integer
#
# Indexes
#
#  index_invitations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_7eae413fe6  (user_id => users.id)
#

class CodeOfConductValidator < ActiveModel::Validator
  def validate(record)
    if record.code_of_conduct == false
      record.errors[:base] << "Please accept our Code of Conduct to proceed"
    end
  end
end

class Invitation < ApplicationRecord
  belongs_to :user

  after_create :notify_administrators

  validates :invitee_email, presence: true, unless: Proc.new { |member| member.member_application == true }
  validates :invitee_email, uniqueness: true, unless: Proc.new { |member| member.member_application == true }
  validates :invitee_name, presence: true, unless: Proc.new { |member| member.member_application == true }
  validates_with CodeOfConductValidator

  private
    def notify_administrators

    end
end
