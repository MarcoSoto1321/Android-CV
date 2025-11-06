# features/pages/home_page.rb

# Hacemos que HomePage "herede" de BasePage
class MeliPage < BasePage

    # --- Métodos de Selectores (Los elementos) ---

    def barra_de_busqueda
        @driver.find_element(:id, 'com.mercadolibre:id/ui_components_toolbar_title_toolbar')
    end

    def campo_de_texto_busqueda
        @driver.find_element(:id, "com.mercadolibre:id/autosuggest_input_search")
    end

    def titulo_resultados
        @driver.find_element(:xpath, "//*[contains(@text, 'Resultados')]")
    end

    def boton_filtros
        @driver.find_element(:xpath, '//android.widget.TextView[@text="Filtros (3)"]')
    end

    def boton_filtro_condicion
        @driver.find_element(:xpath, "//*[contains(@text, 'Condición')]")
    end

    def tocar_barra_busqueda
        esperar_que_exista(10) { barra_de_busqueda.displayed? }
        barra_de_busqueda.click
    end

    def escribir_en_barra_busqueda(texto_producto)
        esperar_que_exista(10) { campo_de_texto_busqueda.displayed? }
        campo_de_texto_busqueda.send_keys(texto_producto)
        
        @driver.press_keycode(66) #enter
    end

    def tocar_boton_filtros
        esperar_que_exista(10) { boton_filtros.displayed? }
        boton_filtros.click
    end

    def aplicar_filtros_de_nuevo_y_ubicacion
        begin
            puts "Intentando hacer clic en 'Condición'..."
            condicion = esperar_que_exista(10) {
            @driver.find_element(:uiautomator, 'new UiSelector().text("Condición")')
            }
            condicion.click
        rescue
            puts "No se pudo hacer clic en 'Condición', continuando..."
        end
    end

    def verificar_resultados(texto_producto)
        # Espera 15 segs. a que el título de resultados aparezca
        esperar_que_exista(15) { titulo_resultados.displayed? }
        
        expect(titulo_resultados.text.downcase).to include(texto_producto.downcase)
    end

    def obtener_nombres_y_precios_de_productos
        resultados = []
        nombres_vistos = Set.new
        
        5.times do |i|
            contenedores = @driver.find_elements(:xpath, "//android.view.View[@resource-id='polycard_component']")
            
            contenedores.each do |tarjeta|
                nombre = tarjeta.find_element(:xpath, ".//android.widget.TextView[1]").text rescue next
                precio = tarjeta.find_element(:xpath, ".//android.widget.TextView[6]").text rescue next
                
                next if nombres_vistos.include?(nombre)
                
                nombres_vistos.add(nombre)
                resultados << { nombre: nombre, precio: precio }
                puts "#{resultados.size}. #{nombre} - #{precio}"
                
                break if resultados.size >= 5
            end
            
            break if resultados.size >= 5
            scroll_hacia_abajo
        end
        
        resultados
    end
end