require "poseidon-api/version"
require 'json'
require 'curb'

# Cliente para interactuar con la API del sistema poseidon.
#
# Ejemplo:
#
#     api = Poseidon::API(url: 'http://poseidon-url.com', user: 'user@test.com', password: '12345')
#     invoice = Poseidon::Invoice.new ...
#     ...
#     emitted = api.emit_invoice(invoice)
#
# Retorna un booleano que indica si pudo o no emitir la factura.
#
# En caso de no emitir la factura se pueden verificar los errores utilizando el método 'errors'
#
module Poseidon
  class API

    attr_reader :token 

    # Retorna los errores si falló la invocación de alguno de los 
    # métodos.
    attr_reader :errors  

    # El constructor requiere los atributos:
    # 
    # + url: URL de la aplicación Poseidon.
    # + user: Identificador del usuario poseidon que ingresa (email).
    # + password: Contraseña de acceso.
    # + version: Versión de la API a utilizar.
    #
    def initialize(properties)
      @service_url = properties[:url]
      @user = properties[:user]
      @password = properties[:password]
      @errors = []
      @version = properties[:version] || 'v1'
    end

    # Obtiene un token para poder utilizar los servicios
    # 
    # Retorna true o false
    #
    # Si ocurre un error se pueden obtener los detalles a través del método "errors"
    def login
      json = { :email => @user, :password => @password }.to_json
      curl = post(token_uri, json)
      if curl.response_code == 200
        response = JSON.parse(curl.body_str)
        @token = response['token']
        return true
      else
        response = JSON.parse(curl.body_str)
        @errors << response['error']
        return false
      end    
    end

    # Emite una factura a través del sistema Poseidon
    #
    # Retorna true o false
    #
    def emit_invoice(invoice)
      login if @token.nil? 
      curl = post(facturas_uri, invoice.to_json)
      status_code = curl.response_code
      # TODO analizar que sucede si hay un token pero la petición retorna error 401 (unauthorized)
      # Debería volver a pedirse un token y reintentar?
      if curl.response_code == 201 # created
        return true 
      else
        response = JSON.parse(curl.body_str)
        @errors.clear << response['error']
        return false
      end
    end

    private 

    def post(uri, json)
      c = Curl.post(uri, json) do |curl|
        curl.headers['Content-Type'] = 'application/json'
      end
      #c.perform
      c
    end

    def api_uri
      "#{@service_url}/api/#{@version}"
    end

    def token_uri
      "#{api_uri}/tokens"
    end

    def facturas_uri
      "#{api_uri}/facturas.json?auth_token=#{@token}"
    end

  end


  # Información de la factura a emitir
  class Invoice
    attr_accessor :date, :sale_point, :number, :client, :details

    # Atributos para construir:
    #
    # + date
    # + sale_point
    # + number
    # + client: a Poseidon::Client instance
    #
    def initialize(attrs)
      @date = attrs[:date] || Date.now
      @sale_point = attrs[:sale_point]
      @number = attrs[:number]
      @client = attrs[:client]
      @details = []
    end

    def to_hash
      { factura: {
          fecha: @date,
          sale_point: @sale_point,
          numero: @number,
          cliente: @client.to_hash,
          detalles: @details.map { |detail| detail.to_hash } 
        }
      }
    end

    def to_json
      to_hash.to_json
    end
  end

  class Client
    attr_accessor :name, :cuit, :iva_condition_id

    # Atributos necesario para la construcción:
    #
    # + name
    # + cuit
    # + iva_condition_id
    #
    def initialize(attrs)
      @name = attrs[:name]
      @cuit = attrs[:cuit]
      @iva_condition_id = attrs[:iva_condition_id]
    end

    def to_hash
      { razonsocial: @name, cuit_number: @cuit, condicioniva_id: @iva_condition_id }
    end
  end

  class Detail
    attr_accessor :amount, :unit_price, :description, :iva_rate

    # Attributos necesarios para la construcción:
    #
    #   + amount
    #   + unit_price
    #   + description
    #   + iva_rate
    #
    def initialize(attrs)
      @amount = attrs[:amount]
      @unit_price = attrs[:unit_price]
      @description = attrs[:description]
      @iva_rate = attrs[:iva_rate]
    end

    def to_hash
      { cantidad: @amount, preciounitario: @unit_price, descripcion: @description, tasaiva: @iva_rate }
    end
  end

end
