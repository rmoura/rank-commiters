require 'json'

module RankCommiters

  def self.Parser(results)
    hsh             = {}
    hsh[:commiters] = {}

    results.each do |result|
      message = case result.class.to_s
      when 'Net::HTTPOK'           then 'Sucesso'
      when 'Net::HTTPNotFound'     then 'Repositório Não Encontrado'
      when 'Net::HTTPUnauthorized' then 'Acesso Não Autorizado'
      when 'Net::HTTPForbidden'    then 'Limite de Acessos Excedido'
      when 'Net::HTTPConflict'     then 'Repositório Vázio (Sem Commits)'
      end

      hsh[:status] ||= message

      if result.is_a? Net::HTTPOK
        array = JSON.parse(result.body, symbolize_names: true)
        array.each do |item|
          author = item[:commit][:author]

          if item[:author] or item[:commiter]
            author.merge!(item[:author] ? item[:author] : item[:commiter])
          end

          unless hsh[:commiters][author[:login]]
            hsh[:commiters][author[:login]] = {
              name:          author[:name],
              email:         author[:email],
              login:         author[:login],
              avatar_url:    author[:avatar_url],
              commits_count: 1
            }
          else
            hsh[:commiters][author[:login]][:commits_count] += 1
          end

          # Removendo commiters que não foram especificados login
          hsh[:commiters].delete_if { |login, _| login.nil? }

          # Ordenando commiters por quantidade de commits
          hsh[:commiters] = hsh[:commiters].sort_by do |login, hsh|
            hsh[:commits_count]
          end.reverse.to_h
        end
      end
    end

    hsh
  end

end
