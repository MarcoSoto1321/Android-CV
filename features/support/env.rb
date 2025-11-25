require 'appium_lib'
require 'rspec/expectations'

# Carga automática de todas las Pages
Dir[File.join(File.dirname(__FILE__), '../pages', '*.rb')].each { |file| require file }

# --- Se ejecuta ANTES de cada escenario ---
Before do
    # 1. Configuración por defecto: ANDROID
    # Esta variable 'caps_opts' guardará la configuración elegida.
    caps_opts = {
        platformName: "Android",
        "appium:options": {
            deviceName: "emulator-5554",
            automationName: "UiAutomator2",
            appPackage: "com.mercadolibre",
            appActivity: "com.mercadolibre.splash.SplashActivity",
            appWaitDuration: 30000,
            noReset: true
        }
    }

    # 2. Condicional: ¿El usuario pidió iOS?
    # Si ejecutamos el test definiendo la variable de entorno 'ios',
    if ENV['PLATFORM'] == 'ios'
        caps_opts = {
            platformName: "iOS",
            "appium:options": {
                automationName: "XCUITest",
                platformVersion: "18.5",
                deviceName: "iPhone de Soreck",
                udid: "00008101-001155162660001E",
                # IMPORTANTE: Cambiado a Mercado Libre (com.mercadolibre)
                bundleId: "com.3mosquitos.MercadoLibre", 
                noReset: true,
                # Timeout extra por si el iPhone tarda en verificar la app
                wdaLaunchTimeout: 60000 
            }
        }
    end

    # 3. Estructura final para Appium
    caps = {
        caps: caps_opts,
        appium_lib: {
            server_url: "http://127.0.0.1:4723/wd/hub",
            wait: 30 
        }
    }

    # 4. Inicializar Driver
    @driver = Appium::Driver.new(caps, true)
    @driver.start_driver 

    # Inicializar Page Object
    @meli_page = MeliPage.new(@driver)
end

# --- Se ejecuta DESPUÉS de cada escenario ---
After do
    @driver.driver_quit if @driver
end