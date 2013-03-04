[![Build Status](http://www.apslabs.com.ar/jenkins/job/poseidon-api/badge/icon)](http://www.apslabs.com.ar/jenkins/job/poseidon-api/)

# Poseidon::Api

Cliente para interactuar con la API del sistema Poseidon.

RDoc: http://rubydoc.info/github/apslab/poseidon-api/master/frames

## Instalación

Agregar la siguiente linea a su Gemfile:

    gem 'poseidon-api'

Y luego ejecutar:

    $ bundle

O instalar directamente: 

    $ gem install poseidon-api

## Modo de uso

    api = Poseidon::API(url: 'http://poseidon-url.com', user: 'user@test.com', password: '12345')
    invoice = Poseidon::Invoice.new(date: Date.today, sale_point: 1, number: 189122)
    invoice.client = Poseidon::Client.new(name: 'Los alamos', cuit: 20243234221, iva_condition_id: 1)
    invoice.details << Poseidon::Detail.new(amount: 10, unit_price: 15.50, description: 'Carpetas oficio', iva_rate: 21.0)
    invoice.details << Poseidon::Detail.new(amount: 4, unit_price: 35.0, description: 'Carpetas plastificada', iva_rate: 21.0)
    emitted = api.emit_invoice(invoice)

Retorna un booleano que indica si pudo o no emitir la factura.

En caso de no emitir la factura se pueden verificar los errores utilizando el método 'errors'

## Links

RDoc: http://rubydoc.info/github/apslab/poseidon-api/master/frames
Source: https://github.com/apslab/poseidon-api

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
