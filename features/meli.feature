# features/home.feature
Feature: Búsqueda en Mercado Libre
    Como usuario de la app
    Quiero buscar un producto
    Para ver sus resultados

    Scenario: Realizar una búsqueda de un producto
        Given que estoy en la pantalla de inicio
        When toco la barra de búsqueda
        And escribo "playstation 5"
        #No encontre forma para seleccionar los filtros, mas que hacer analisis de imagenes
        #Pero es muy lento. y tarda mucho, en appium no encontre los elementos
        #And presiono el boton filtros
        #And aplico filtros de nuevo y ubicación
        Then Obtengo el precio y nombre de 5 productos