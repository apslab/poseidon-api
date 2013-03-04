# Poseidon::Api

Cliente para interactuar con la API del sistema Poseidon.

## Instalación

Agregar la siguiente linea a su Gemfile:

    gem 'poseidon-api'

Y luego ejecutar:

    $ bundle

O instalar directamente: 

    $ gem install poseidon-api

## Modo de uso

    api = Poseidon::API(url: 'http://poseidon-url.com', user: 'user@test.com', password: '12345')
    invoice = Poseidon::Invoice.new ...
    ...
    emitted = api.emit_invoice(invoice)

Retorna un booleano que indica si pudo o no emitir la factura.

En caso de no emitir la factura se pueden verificar los errores utilizando el método 'errors'


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
