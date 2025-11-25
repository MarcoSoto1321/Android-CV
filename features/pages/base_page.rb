# features/pages/base_page.rb
class BasePage
    def initialize(driver)
        @driver = driver
    end

    def esperar_que_exista(segundos)
        wait = Selenium::WebDriver::Wait.new(timeout: segundos)
        wait.until { yield }
    end

    # Espera a que el elemento sea clickeable y le da click
    def esperar_y_click(segundos = 5)
        wait = Selenium::WebDriver::Wait.new(timeout: segundos)
        
        wait.until do
            begin
                # yield ejecuta el código que le pases entre llaves {}
                elemento = yield 
                
                # Verificamos que se vea Y que esté habilitado
                if elemento.displayed? && elemento.enabled?
                    elemento.click # Intentamos click
                    true # Salimos del wait
                else
                    false # Seguimos esperando
                end
            rescue Selenium::WebDriver::Error::StaleElementReferenceError
                # Si la pantalla se refrescó y el elemento cambió de ID, reintentamos
                false
            rescue Selenium::WebDriver::Error::ElementClickInterceptedError
                # Si algo tapó el click, reintentamos
                false
            end
        end
    end

    def scroll_hacia_abajo
        if ENV['PLATFORM'] == 'ios'
            # Para iOS
            @driver.execute_script('mobile: scroll', direction: 'down')
        else
            # Para Android - usando UiScrollable (más confiable)
            @driver.execute_script('mobile: scrollGesture', {
                left: 100,
                top: 800,
                width: 200,
                height: 400,
                direction: 'down',
                percent: 3.0
            })
        end
    rescue => e
        puts "Error en scroll (método principal): #{e.message}"
        # Fallback: intenta con gestos táctiles si lo anterior falla
        begin
            dims = @driver.window_size
            start_x = dims.width / 2
            start_y = (dims.height * 0.8).to_i
            end_y = (dims.height * 0.2).to_i
            
            @driver.action
                .move_to_location(start_x, start_y)
                .pointer_down(:left)
                .pause(duration: 0.1)
                .move_to_location(start_x, end_y, duration: 0.5)
                .release
                .perform
        rescue => e2
            puts "Error en scroll (fallback): #{e2.message}"
            # Último intento con swipe
            begin
                dims = @driver.window_size
                @driver.swipe(
                    start_x: dims.width / 2,
                    start_y: (dims.height * 0.8).to_i,
                    end_x: dims.width / 2,
                    end_y: (dims.height * 0.2).to_i,
                    duration: 500
                )
            rescue => e3
                puts "Error en scroll (último intento): #{e3.message}"
            end
        end
    end
end