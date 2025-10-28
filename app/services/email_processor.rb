# app/services/email_processor.rb

module Services
  class EmailProcessor
    attr_reader :email_file, :parser, :result

    def initialize(email_file)
      @email_file = email_file
      @parser = nil
      @result = nil
    end

    def process
      begin
        mail = Mail.read_from_string(email_file.content)

        @parser = select_parser(mail.from.first)

        extracted_data = @parser.extract_data

        if @parser.successful?
          create_customer(extracted_data)
          create_success_log(extracted_data)
          @result = { status: :success, data: extracted_data }
        else
          create_failure_log("Falha ao extrair informações de contato necessárias")
          @result = { status: :failure, error: "Falha ao extrair informações de contato necessárias" }
        end

      rescue => e
        create_failure_log(e.message)
        @result = { status: :failure, error: e.message }
      end

      @result
    end

    private

    def select_parser(from_email)
      case from_email
      when /loja@fornecedorA\.com/i
        Parsers::SupplierAParser.new(email_file.content, from_email)
      when /contato@parceiroB\.com/i
        Parsers::PartnerBParser.new(email_file.content, from_email)
      else
        raise "Remetente desconhecido: #{from_email}. Nenhum parser disponível para este endereço de email."
      end
    end

    def create_customer(data)
      Customer.create!(
        name: data[:name],
        email: data[:email],
        phone: data[:phone],
        product_code: data[:product_code],
        subject: data[:subject]
      )
    end

    def create_success_log(data)
      EmailLog.create!(
        filename: email_file.filename,
        status: 'success',
        extracted_data: data.to_json,
        error_message: nil,
        processed_at: Time.current
      )
    end

    def create_failure_log(error_message)
      EmailLog.create!(
        filename: email_file.filename,
        status: 'failure',
        extracted_data: nil,
        error_message: error_message,
        processed_at: Time.current
      )
    end
  end
end
