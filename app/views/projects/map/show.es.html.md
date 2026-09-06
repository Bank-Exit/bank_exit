> [!IMPORTANT]
> El mapa de comercios del **Colectivo Salida del Banco** te permite encontrar establecimientos de todo el mundo que aceptan **Bitcoin**, **Monero** y otras monedas libres y descentralizadas. El proyecto se basa en datos abiertos de OpenStreetMap y sigue creciendo gracias a las contribuciones de la comunidad.

<p class="text-center"><%= link_to t("application.header.access_map"), maps_path, class: "btn btn-primary btn-lg" %></p>

¿Buscas un restaurante, un artesano, un terapeuta, un alojamiento o un comercio que acepte pagos con criptomonedas?

El [mapa](<%= maps_path %>) del Colectivo ha sido creado para conectar a los usuarios de criptomonedas con los comercios que las aceptan. Su objetivo es sencillo: hacer que los pagos con Bitcoin y Monero sean más accesibles en la vida cotidiana.

{{toc}}

[![Mapa imagen](<%= image_path(@record.cover) %>)](<%= maps_path %>)

## ¿Qué ofrece el mapa?

El mapa reúne miles de comercios de todo el mundo e incluye varias herramientas para ayudarte a encontrar rápidamente lo que necesitas.

Puedes:

- buscar comercios por ubicación;
- filtrar los resultados por criptomoneda (Bitcoin, Lightning, Monero, June, etc.);
- buscar por categoría de actividad (restaurantes, hoteles, artesanos, etc.);
- identificar los comercios que ofrecen servicio de entrega;
- consultar qué establecimientos no requieren procedimientos KYC cuando esta información está disponible.

## ¿Cómo utilizar el mapa?

Empezar es muy sencillo:

1. Abre el mapa interactivo.
2. Busca por nombre, dirección o palabras clave.
3. Aplica los filtros que mejor se adapten a tus necesidades.
4. Haz clic en un comercio para consultar su ficha y los métodos de pago que acepta.

Así podrás preparar tus compras o descubrir comercios cercanos que ya aceptan pagos con criptomonedas.

## ¿Conoces un comercio que acepte Bitcoin o Monero?

El mapa es un proyecto colaborativo.

Si conoces un establecimiento que ya acepta estos medios de pago, o has ayudado recientemente a un comerciante a implementarlos, puedes proponer su incorporación mediante el botón <%= link_to "Sugerir un comerciante", new_merchant_proposal_path %>.

Una vez verificada, la información se incorpora a OpenStreetMap y se sincroniza automáticamente con el mapa del Colectivo.

## ¿Eres comerciante?

Incluir tu negocio en el mapa permite que nuevos clientes puedan encontrarte fácilmente.

Para empezar, normalmente basta con:

- aceptar pagos en Bitcoin o Monero mediante una billetera compatible;
- informar a tus clientes de que aceptas estos medios de pago;
- solicitar la inclusión de tu negocio en el mapa.

El Colectivo también pone a disposición tutoriales, folletos y herramientas de contabilidad para acompañar a los profesionales en esta transición.

## Un proyecto abierto y colaborativo

El mapa no es un directorio privado. La información proviene de [OpenStreetMap](https://www.openstreetmap.org), un proyecto cartográfico libre y colaborativo.

Esto significa que cualquier persona puede contribuir mejorando los datos, añadiendo nuevos comercios o solicitando la eliminación de fichas obsoletas cuando sea necesario. Las actualizaciones se sincronizan automáticamente con el mapa del Colectivo varias veces al día.

> [!TIP]
> Cuanto más contribuya la comunidad, más fácil será encontrar comercios que acepten Bitcoin y Monero. Si descubres un nuevo establecimiento, considera proponerlo mediante el [formulario específico](<%= new_merchant_proposal_path %>) para ayudar a los próximos usuarios.

<p class="text-center"><%= link_to t("application.header.access_map"), maps_path, class: "btn btn-primary btn-lg" %></p>
