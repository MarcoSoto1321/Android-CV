# features/pages/base_page.rb
class BasePage
    def initialize(driver)
        @driver = driver
    end

    def esperar_que_exista(segundos)
        wait = Selenium::WebDriver::Wait.new(timeout: segundos)
        wait.until { yield }
    end

    def scroll_hacia_abajo
        @driver.execute_script('mobile: scrollGesture', {
            left: 100, 
            top: 400, 
            width: 200, 
            height: 400,
            direction: 'down',
            percent: 1.5
        })
        sleep(0.3)  # Aumentar a 300ms
    end
end