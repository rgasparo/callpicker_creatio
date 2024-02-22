require 'rest-client'
require 'json'

class LeadController < ApplicationController

  # phone_controller = PhonesController.new
  # @bpm_csrf, @cookies_string = phone_controller.index
  
  def lead_action
    @arrayVentas = []
    @arrayTomas = []
    @obj = {}

      phone_number = params[:phone][:phone]
      url_string = "https://clikauto.creatio.com/0/odata/ClikAutoRepositorio?%24filter=contains(ClikAutoTelefonoMovil%2C%27#{phone_number}%27)&%24orderby=CreatedOn%20desc"

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
            if item['ClikAutoLeadRelatedId'] != "00000000-0000-0000-0000-000000000000"
              if item['ClikAutoNecesidadCliente'].include?("venta")
                @arrayVentas << item['ClikAutoLeadRelatedId'] unless @arrayVentas.include?(item['ClikAutoLeadRelatedId'])
              else
                @arrayTomas << item['ClikAutoLeadRelatedId'] unless @arrayTomas.include?(item['ClikAutoLeadRelatedId'])
              end
            end
          end
        end
      rescue RestClient::ExceptionWithResponse => e
        # Manejar el error si la solicitud falla
        puts "Error: #{e.response.code}, Response body: #{e.response.body}"
      end
    
    return @arrayVentas, @arrayTomas, @obj

  end
end