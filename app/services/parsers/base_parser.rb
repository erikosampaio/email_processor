# app/services/parsers/base_parser.rb

module Parsers
  class BaseParser
    attr_reader :email_content, :from_email

    def initialize(email_content, from_email)
      @email_content = email_content
      @from_email = from_email
    end

    # Template method - deve ser implementado pelas subclasses
    def parse
      raise NotImplementedError, "Subclasses must implement #parse method"
    end

    # Método comum para extrair dados estruturados
    def extract_data
      {
        name: extract_name,
        email: extract_email,
        phone: extract_phone,
        product_code: extract_product_code,
        subject: extract_subject
      }
    end

    # Método comum para validar se tem informações de contato
    def has_contact_info?
      email = extract_email
      phone = extract_phone
      email.present? || phone.present?
    end

    # Método comum para determinar se o processamento foi bem-sucedido
    def successful?
      data = extract_data
      data[:name].present? && has_contact_info? && data[:product_code].present?
    end

    private

    # Métodos abstratos - devem ser implementados pelas subclasses
    def extract_name
      raise NotImplementedError, "Subclasses must implement #extract_name method"
    end

    def extract_email
      raise NotImplementedError, "Subclasses must implement #extract_email method"
    end

    def extract_phone
      raise NotImplementedError, "Subclasses must implement #extract_phone method"
    end

    def extract_product_code
      raise NotImplementedError, "Subclasses must implement #extract_product_code method"
    end

    def extract_subject
      raise NotImplementedError, "Subclasses must implement #extract_subject method"
    end

    # Métodos auxiliares comuns
    def clean_text(text)
      return nil if text.nil?
      text.strip.gsub(/\s+/, ' ')
    end

    def extract_with_regex(text, pattern)
      return nil if text.nil?
      match = text.match(pattern)
      match ? clean_text(match[1]) : nil
    end
  end
end
