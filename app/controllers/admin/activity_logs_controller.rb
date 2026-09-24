module Admin
  class ActivityLogsController < ApplicationController
    before_action :require_login

    def index
      authorize ActivityLog
      @activity_logs = policy_scope(ActivityLog)
        .includes(:user)
        .order(created_at: :desc)
    end
  end
end
