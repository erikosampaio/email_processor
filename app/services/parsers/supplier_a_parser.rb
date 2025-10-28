# app/services/parsers/supplier_a_parser.rb

module Parsers
  class SupplierAParser < BaseParser
    # Parser para e-mails do fornecedor A (loja@fornecedorA.com)
    # Formato estruturado com labels explícitos

    private

    def extract_name
      # Padrão: "Nome: João da Silva" ou "Cliente: Maria Oliveira"
      patterns = [
        /(?:Nome|Cliente|Name):\s*([^\n\r]+)/i,
        /(?:Nome|Cliente|Name)\s*:\s*([^\n\r]+)/i
      ]

      patterns.each do |pattern|
        result = extract_with_regex(email_content, pattern)
        return result if result.present?
      end

      nil
    end

    def extract_email
      # Padrão: "E-mail: joao@example.com" ou "Email: maria@test.com"
      patterns = [
        /(?:E-mail|Email|E-mail|Email):\s*([^\s\n\r]+@[^\s\n\r]+)/i,
        /(?:E-mail|Email|E-mail|Email)\s*:\s*([^\s\n\r]+@[^\s\n\r]+)/i
      ]

      patterns.each do |pattern|
        result = extract_with_regex(email_content, pattern)
        return result if result.present?
      end

      nil
    end

    def extract_phone
      # Padrão: "Telefone: (11) 99999-9999" ou "Phone: +55 11 99999-9999"
      patterns = [
        /(?:Telefone|Phone|Tel):\s*([^\n\r]+)/i,
        /(?:Telefone|Phone|Tel)\s*:\s*([^\n\r]+)/i
      ]

      patterns.each do |pattern|
        result = extract_with_regex(email_content, pattern)
        return result if result.present?
      end

      nil
    end

    def extract_product_code
      # Padrão: "Produto: ABC123" ou "Código: XYZ987" ou "Produto ABC123"
      patterns = [
        /(?:Produto|Código|Product|Code):\s*([A-Z0-9]+)/i,
        /(?:Produto|Código|Product|Code)\s*:\s*([A-Z0-9]+)/i,
        # Padrão no assunto: "Produto ABC123"
        /Produto\s+([A-Z0-9]+)/i,
        # Padrão genérico: qualquer código alfanumérico
        /([A-Z]{2,4}\d{2,4})/i
      ]

      patterns.each do |pattern|
        result = extract_with_regex(email_content, pattern)
        return result if result.present?
      end

      nil
    end

    def extract_subject
      # Para fornecedor A, o assunto geralmente vem do cabeçalho do e-mail
      # Vamos extrair do conteúdo se não estiver disponível no cabeçalho
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
