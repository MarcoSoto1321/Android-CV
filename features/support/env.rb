# features/support/env.rb
require 'appium_lib'
require 'rspec/expectations'

Dir[File.join(File.dirname(__FILE__), '../pages', '*.rb')].each { |file| require file }

# --- Se ejecuta ANTES de cada escenario ---
Before do
    caps = {
        caps: {
        # El único que va fuera es platformName
        platformName: "Android",
        
        # --- FORMATO W3C RECOMENDADO ---
        # Agrupamos todo dentro de "appium:options"
        # Nota: Dentro de "options", ya NO usamos el prefijo "appium:"
        "appium:options": {
            deviceName: "815e0748",
            automationName: "UiAutomator2",
            appPackage: "com.mercadolibre",
            # 1. Le decimos la Activity que el log nos acaba de revelar
            appActivity: "com.mercadolibre.splash.SplashActivity",
            
            # 2. Le damos 30 segundos de paciencia para que esa
            #    actividad cargue antes de rendirse.
            appWaitDuration: 30000,
            #appActivity: ".home.activities.OnboardingActivity",
            noReset: true
        }
        # ----------------------------------
        },
        appium_lib: {
            server_url: "http://127.0.0.1:8200",
            wait: 30 
        }
    }

    @driver = Appium::Driver.new(caps, true)
    
    # Esta es la línea (aprox. 40) que te está fallando
    @driver.start_driver 

    @meli_page = MeliPage.new(@driver)
end

# --- Se ejecuta DESPUÉS de cada escenario ---
After do
    @driver.driver_quit
end