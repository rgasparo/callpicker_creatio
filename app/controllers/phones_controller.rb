require 'rest-client'
require 'json'

class PhonesController < ApplicationController

  def index
      url = "https://clikauto.creatio.com/ServiceModel/AuthService.svc/Login"
      headers = { 'Content-Type' => 'application/json; charset=utf-8', 'ForceUseSession' => 'true' }
      body = { "UserName": 'ClikAutoITConnector', "UserPassword": 'ISb3XoiAKCo' }

      @obj = params[:obj]

      begin
        response = RestClient.post(url, body.to_json, headers)

        # Extraer cookies de la respuesta
        cookies = {}
        response.headers[:set_cookie]&.each do |cookie|
          cookie_parts = cookie.split(';').first.split('=')
          cookies[cookie_parts.first] = cookie_parts.last
        end

        # Construir BPMCSRF y la cadena de cookies
        @bpm_csrf = cookies["BPMCSRF"]
        @cookies_string = cookies.map { |name, value| "#{name}=#{value}" }.join('; ')
        
        # Modificar los headers para incluir las cookies y BPMCSRF
        headers["BPMCSRF"] = @bpm_csrf
        headers["Cookie"] = @cookies_string

      rescue RestClient::ExceptionWithResponse => e
        @error_message = "Error: #{e.response.code}, Response body: #{e.response.body}"
      end

      @arrayVentas = []
      @arrayTomas = []
      @arrayLeadName = []
      @obj = {}
  
        @phone_number = params[:phone]
        url_string = "https://clikauto.creatio.com/0/odata/Lead?$count=true&$filter=MobilePhone%20eq%20%27#{@phone_number}%27"
  
        headers = {
          'Cookie' => @cookies_string,
          'BPMCSRF' => @bpm_csrf
        }
  
        begin
          response = RestClient.get(url_string, headers)
          @obj = JSON.parse(response.body)
  
          count_results = @obj['value'].count
  
          if count_results > 0
            @obj['value'].each do |item|
              if item['Id'] != "00000000-0000-0000-0000-000000000000"
                @arrayVentas << item['Id'] unless @arrayVentas.include?(item['Id'])
                @arrayLeadName << item['LeadName'] unless @arrayVentas.include?(item['LeadName'])
                # if item['LeadName'].include?('Venta')
                #   @arrayVentas << item['Id'] unless @arrayVentas.include?(item['Id'])
                # else
                #   @arrayTomas << item['Id'] unless @arrayTomas.include?(item['Id'])
                # end
              end
            end
          end
        rescue RestClient::ExceptionWithResponse => e
          # Manejar el error si la solicitud falla
          puts "Error: #{e.response.code}, Response body: #{e.response.body}"
        end

      return @bpm_csrf, @cookies_string   

  end

end
