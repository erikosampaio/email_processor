# app/jobs/process_email_job.rb

class ProcessEmailJob < ApplicationJob
  queue_as :default

  def perform(email_file_id)
    email_file = EmailFile.find(email_file_id)

    processor = Services::EmailProcessor.new(email_file)
    result = processor.process

    Rails.logger.info "Processamento de email concluído para #{email_file.filename}: #{result[:status]}"

    result
  rescue => e
    Rails.logger.error "Processamento de email falhou para #{email_file.filename}: #{e.message}"

    EmailLog.create!(
      filename: email_file.filename,
      status: 'failure',
      extracted_data: nil,
      error_message: e.message,
      processed_at: Time.current
    )

    raise e
  end
end
