class EmailsController < ApplicationController
  def index ; end

  def create
    if params[:email_file].present?
      email_file = params[:email_file]

      unless email_file.original_filename.end_with?('.eml')
        flash[:error] = 'Por favor, selecione um arquivo .eml válido.'

        redirect_to emails_path
        return
      end

      email_file_record = EmailFile.create!(
        filename: email_file.original_filename,
        content: email_file.read,
        uploaded_at: Time.current
      )

      ProcessEmailJob.perform_later(email_file_record.id)

      flash[:success] = "Arquivo '#{email_file.original_filename}' enviado para processamento!"
      redirect_to emails_path
    else
      flash[:error] = 'Por favor, selecione um arquivo .eml.'
      redirect_to emails_path
    end
  rescue => e
    flash[:error] = "Erro ao processar arquivo: #{e.message}"
    redirect_to emails_path
  end
end
