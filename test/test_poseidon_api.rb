require 'protest'
require 'poseidon-api'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassetes'
  c.hook_into :webmock
end


def valid_properties
  { :user => 'lmpetek@gmail.com', :password => '123456', url: 'http://localhost:3000' }
end

def login
  api = Poseidon::API.new(valid_properties)
  api.login
  api
end

def generate_invoice(type)
  invoice = Poseidon::Invoice.new(date: Date.today, sale_point: 1, number: Random.rand(1..9999999))
  if type == :client 
    invoice.client = Poseidon::Client.new(name: 'Los alerces', cuit: 20233119354, iva_condition_id: 1)
  end

  if type == :supplier
    invoice.supplier = Poseidon::Supplier.new(name: 'Los alerces', cuit: 20233119354, iva_condition_id: 1)
  end
  
  [ { amount: 10, unit_price: 15.50, description: 'detalle', iva_rate: 21.0 },
    { amount: 8, unit_price: 35.0, description: 'detalle', iva_rate: 21.0 } ].each do |params|
    invoice.details << Poseidon::Detail.new(params)
  end
  invoice
end

Protest.describe('api') do

  test 'success login' do
    VCR.use_cassette('success_login') do
      api = Poseidon::API.new(valid_properties)
      assert api.login
      assert api.errors.empty?
    end
  end

  test 'failed login' do
    VCR.use_cassette('failed_login') do
      properties = valid_properties.clone
      properties[:password] = ''
      api = Poseidon::API.new(properties)
      assert api.login == false
      assert !api.errors.empty?
    end
  end

  test 'emit invoice for client successful' do
    VCR.use_cassette('valid_client_invoice') do 
      api = Poseidon::API.new(valid_properties)
      result = api.emit_invoice(generate_invoice(:client))
      puts api.errors
      assert result, api.errors  
      assert api.errors.empty?
    end
  end
  
  test 'emit invoice for supplier successful' do
    VCR.use_cassette('valid_supplier_invoice') do 
      api = Poseidon::API.new(valid_properties)
      result = api.emit_invoice(generate_invoice(:supplier))
      assert result   
      assert api.errors.empty?
    end
  end

end
