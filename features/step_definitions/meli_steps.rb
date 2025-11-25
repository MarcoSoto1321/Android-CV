Given("que estoy en la pantalla de inicio") do
    puts "App iniciada correctamente."
end

When("toco la barra de búsqueda") do
    @meli_page.tocar_barra_busqueda
end

When("escribo {string}") do |producto|
    @meli_page.escribir_en_barra_busqueda(producto)
end

When("presiono el boton filtros") do
    @meli_page.tocar_boton_filtros
end

When("aplico filtros de nuevo") do
    @meli_page.aplicar_filtros_de_nuevo
end

When("aplico filtros de ubicación") do
    @meli_page.aplicar_filtros_de_ubicacion
end

When ("aplico filtro de precio") do
    @meli_page.aplicar_filtro_de_precio
end

When ("aplico los filtros") do
    @meli_page.confirmar_y_aplicar_filtros
end

Then("Obtengo el precio y nombre de 5 productos") do
    @meli_page.obtener_nombres_y_precios_de_productos()
end