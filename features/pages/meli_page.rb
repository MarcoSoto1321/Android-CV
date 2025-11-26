class MeliPage < BasePage

    # --- Métodos de Selectores (Los elementos) ---

    def barra_de_busqueda
        if ENV['PLATFORM'] == 'ios'
            @driver.find_element(:name, 'Buscar en Mercado Libre')
        else
            @driver.find_element(:xpath, "//*[@resource-id='com.mercadolibre:id/ui_components_toolbar_search_field']")
        end
    end

    def campo_de_texto_busqueda
        if ENV['PLATFORM'] == 'ios'
            @driver.find_element(:name, "search_core_autosuggest_search_bar_txt_field")
        else
            @driver.find_element(:xpath, "//*[@resource-id='com.mercadolibre:id/autosuggest_input_search']")
        end
    end

    def titulo_resultados
        @driver.find_element(:xpath, "//*[contains(@text, 'Resultados') or contains(@content-desc, 'Resultados')]")
    end

    def boton_filtros
        if ENV['PLATFORM'] == 'ios'
            @driver.find_element(:name, 'SHAPE_FILTER_BUTTON')
        else
            @driver.find_element(:xpath, "//*[@text='Filtros (3)']")
        end
    end

    def boton_filtro_condicion
        if ENV['PLATFORM'] == 'ios'
            condicion = @driver.find_elements(:name, "Condición")
            condicion[3]
        else
            @driver.find_element(:xpath, "//*[@text='Condición' or @content-desc='Condición']")
        end
    end

    def boton_filtro_condicion_nuevo
        if ENV['PLATFORM'] == 'ios'
            @driver.find_element(:name, "Nuevo")
        else
            @driver.find_element(:xpath, "//*[@text='Nuevo' or @content-desc='Nuevo']")
        end
    end

    def boton_filtro_envio_local
        if ENV['PLATFORM'] == 'ios'
            @driver.find_element(:name, "Local")
        else
            @driver.find_element(:xpath, "//*[@text='Local' or @content-desc='Local']")
        end
    end

    def boton_ver_resultados
        if ENV['PLATFORM'] == 'ios'
            @driver.find_element(:xpath, "//*[contains(@name, 'resultados')]")
        else
            @driver.find_element(:xpath, "//*[contains(@text, 'resultado') or contains(@content-desc, 'resultado')]")
        end
    end

    def boton_ordenar_por
        if ENV['PLATFORM'] == 'ios'
            @driver.find_element(:name, "Ordenar por")
        else
            @driver.find_element(:xpath, "//android.widget.TextView[@text='Ordenar por']")
        end
    end

    def boton_filtro_mayor_precio
        if ENV['PLATFORM'] == 'ios'
            @driver.find_element(:name, "Mayor precio")
        else
            @driver.find_element(:xpath, "//*[@text='Mayor precio' or @content-desc='Mayor precio']")
        end
    end

    # --- Métodos de Acciones ---

    def tocar_barra_busqueda
        esperar_que_exista(10) { barra_de_busqueda.displayed? }
        barra_de_busqueda.click
    end

    def escribir_en_barra_busqueda(texto_producto)
        esperar_que_exista(10) { campo_de_texto_busqueda.displayed? }
        campo_de_texto_busqueda.send_keys(texto_producto)
        if ENV['PLATFORM'] == 'ios'
            campo_de_texto_busqueda.send_keys(:return)
        else
            @driver.press_keycode(66) 
        end
    end

    def tocar_boton_filtros
        esperar_que_exista(10) { boton_filtros.displayed? }
        boton_filtros.click
    end

    def aplicar_filtros_de_nuevo
        esperar_y_click(10) { boton_filtro_condicion }
        esperar_y_click(10) { boton_filtro_condicion_nuevo }
        puts "Filtros de 'Nuevo' aplicados."
    end

    def aplicar_filtros_de_ubicacion
        if ENV['PLATFORM'] == 'ios'
            envios = @driver.find_elements(:name, "Envíos")
            envios[3].click
            esperar_y_click(10) { boton_filtro_envio_local }
        else
            # Android: scroll y click en Envíos
            scroll_y_click_en_menu_lateral("Envíos")
            esperar_y_click(10) { boton_filtro_envio_local }
        end
        puts "Filtros de 'Ubicación Local' aplicados."
    end

    def aplicar_filtro_de_precio
        if ENV['PLATFORM'] == 'ios'
            scroll_hacia_abajo
            sleep 1
            precio = @driver.find_elements(:name, "Ordenar por")
            precio[2].click
            esperar_y_click(10) { boton_filtro_mayor_precio }
        else
        # Android: Scroll dentro del ListView de filtros
            begin
                scrollable = 'new UiScrollable(new UiSelector().className("android.widget.ListView")).scrollIntoView(new UiSelector().text("Mayor precio"))'
                @driver.find_element(:uiautomator, scrollable).click
            rescue
                # Fallback: scroll manual
                5.times do
                    begin
                        boton_ordenar_por.click
                        boton_filtro_mayor_precio.click
                        break
                    rescue
                        hacer_scroll_menu_lateral
                        sleep 0.5
                    end
                end
            end
        end
        puts "Filtro de precio aplicado."
    end

    def confirmar_y_aplicar_filtros
        esperar_y_click(10) { boton_ver_resultados }
        puts "Filtros confirmados y aplicados."
    end

    def verificar_resultados(texto_producto)
        esperar_que_exista(15) { titulo_resultados.displayed? }
        expect(titulo_resultados.text.downcase).to include(texto_producto.downcase)
    end

    def obtener_nombres_y_precios_de_productos
        resultados = []
        nombres_vistos = Set.new
        intentos_sin_nuevos = 0
        
        while resultados.size < 5 && intentos_sin_nuevos < 3
            size_antes = resultados.size
            
            if ENV['PLATFORM'] == 'ios'
                contenedores = @driver.find_elements(:xpath, "//XCUIElementTypeOther[@name='polycard_core_component_general_content']")
            else
                contenedores = @driver.find_elements(:xpath, "//*[@resource-id='polycard_component']")
            end
            
            contenedores.each do |tarjeta|
                break if resultados.size >= 5
                
                begin
                    if ENV['PLATFORM'] == 'ios'
                        texto_completo = tarjeta.attribute('label')
                        next if texto_completo.nil? || texto_completo.empty?
                        
                        if texto_completo.include?('Agregar uno a tu carrito,')
                            nombre = texto_completo.split('Agregar uno a tu carrito,')[1].split(',')[0].strip
                        else
                            nombre = texto_completo.split(',')[0].strip
                        end
                        
                        precio_match = texto_completo.match(/(\d{5,6}\.\d)/)
                        precio = precio_match ? "$#{precio_match[1]}" : next
                    else
                        # Android: índice [0] = nombre, resource-id='current amount' = precio
                        nombre = tarjeta.find_element(:xpath, ".//android.widget.TextView[1]").attribute('text')
                        precio = tarjeta.find_element(:xpath, ".//*[@resource-id='current amount']").attribute('text')
                    end
                    
                    next if nombres_vistos.include?(nombre)
                    
                    nombres_vistos.add(nombre)
                    resultados << { nombre: nombre, precio: precio }
                    puts "#{resultados.size}. #{nombre} - #{precio}"
                rescue => e
                    next
                end
            end
            
            intentos_sin_nuevos = (size_antes == resultados.size) ? intentos_sin_nuevos + 1 : 0
            
            break if resultados.size >= 5
            
            if intentos_sin_nuevos < 3
                scroll_hacia_abajo
                sleep 2
            end
        end
        
        resultados
    end
end