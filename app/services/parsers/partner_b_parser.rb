# app/services/parsers/partner_b_parser.rb

module Parsers
  class PartnerBParser < BaseParser
    # Parser para e-mails do parceiro B (contato@parceiroB.com)
    # Formato mais direto, às vezes sem labels claros

    private

    def extract_name
      # Padrão mais direto: "Ana Costa" ou "Cliente: Ricardo Almeida"
      patterns = [
        /(?:Cliente|Customer|Nome|Name):\s*([^\n\r]+)/i,
        /(?:Cliente|Customer|Nome|Name)\s*:\s*([^\n\r]+)/i,
        # Padrão sem label - procurar por nomes próprios
        /^([A-Z][a-z]+ [A-Z][a-z]+(?: [A-Z][a-z]+)?)$/m
      ]

      patterns.each do |pattern|
        result = extract_with_regex(email_content, pattern)
        return result if result.present?
      end

      nil
    end

    def extract_email
      # Padrão: "ana@example.com" ou "Email: ricardo@test.com"
      patterns = [
        /(?:Email|E-mail):\s*([^\s\n\r]+@[^\s\n\r]+)/i,
        /(?:Email|E-mail)\s*:\s*([^\s\n\r]+@[^\s\n\r]+)/i,
        # Padrão sem label - procurar por e-mails
        /([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})/
      ]

      patterns.each do |pattern|
        result = extract_with_regex(email_content, pattern)
        # Ignorar o email do remetente do cabeçalho para não causar falsos positivos
        if result.present? && from_email.present? && result.downcase == from_email.downcase
          next
        end
        return result if result.present?
      end

      nil
    end

    def extract_phone
      # Padrão: "(11) 99999-9999" ou "Phone: +55 11 99999-9999"
      patterns = [
        /(?:Telefone|Phone|Tel):\s*([^\n\r]+)/i,
        /(?:Telefone|Phone|Tel)\s*:\s*([^\n\r]+)/i,
        # Padrão sem label - procurar por números de telefone
        /(\(?\d{2}\)?\s?\d{4,5}-?\d{4})/,
        /(\+\d{1,3}\s?\d{2}\s?\d{4,5}-?\d{4})/
      ]

      patterns.each do |pattern|
        result = extract_with_regex(email_content, pattern)
        return result if result.present?
      end

      nil
    end

    def extract_product_code
      # Padrão: "PROD-555" ou "Código: PROD-888"
      patterns = [
        /(?:Produto|Código|Product|Code):\s*([A-Z0-9-]+)/i,
        /(?:Produto|Código|Product|Code)\s*:\s*([A-Z0-9-]+)/i,
        # Padrão sem label - procurar por códigos de produto
        /(PROD-\d{3})/i,
        /([A-Z]{3,4}-\d{3})/i
      ]

      patterns.each do |pattern|
        result = extract_with_regex(email_content, pattern)
        return result if result.present?
      end

      nil
    end

    def extract_subject
      # Para parceiro B, o assunto pode estar em diferentes lugares
      patterns = [
        /(?:Assunto|Subject):\s*([^\n\r]+)/i,
        /(?:Assunto|Subject)\s*:\s*([^\n\r]+)/i
      ]

      patterns.each do |pattern|
        result = extract_with_regex(email_content, pattern)
        return result if result.present?
      end

      # Fallback: procurar por texto que pareça assunto
      lines = email_content.split("\n")
      lines.each do |line|
        if line.match?(/^(?:assunto|subject)/i) && line.length > 10
          return clean_text(line)
        end
      end

      nil
    end
  end
end
