class EmailLogsController < ApplicationController
  def index
    @email_logs = EmailLog.recent
    @success_count = EmailLog.successful.count
    @failure_count = EmailLog.failed.count
  end

  def show
    @email_log = EmailLog.find(params[:id])
  end
end
