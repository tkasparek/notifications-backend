# frozen_string_literal: true

# Represents an individual Insights-Notifications user
class User < ApplicationRecord
  validates :username, :uniqueness => { :scope => :account_id }, :presence => true

  belongs_to :account

  has_many :filters, :through => :account

  class << self
    def current
      Thread.current[:user]
    end

    def current=(user)
      Thread.current[:user] = user
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def from_x_rh_identity(identity)
      new(
        :account => Account.find_by(
          :account_number => identity['account_number']
        ),
        :redhat_org_id => (identity['internal']['org_id'] if identity['internal']),
        :email => identity['user']['email'],
        :first_name => identity['user']['first_name'],
        :last_name => identity['user']['last_name'],
        :active => identity['user']['is_active'],
        :org_admin => identity['user']['is_org_admin'],
        :locale => identity['user']['locale'],
        :username => identity['user']['username'],
        :internal => identity['user']['is_internal']
      )
    end
    # rubocop:enable Metrics/AbcSize

    # rubocop:enable Metrics/MethodLength
  end
end
