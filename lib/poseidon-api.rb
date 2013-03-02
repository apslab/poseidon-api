require "poseidon-api/version"
require 'json'
require 'curb'

module Poseidon
  class API

    attr_reader :token, :errors  

    def initialize(properties)
      @service_url = properties[:url]
      @user_email = properties[:email]
      @user_password = properties[:password]
      @errors = []
      @version = properties[:version] || 'v1'
    end

    def login
      json = { :email => @user_email, :password => @user_password }.to_json
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

    def hello
      'world'
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


  class Invoice
    attr_accessor :date, :sale_point, :number, :client, :details

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
