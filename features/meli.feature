# features/home.feature
Feature: Búsqueda en Mercado Libre
    Como usuario de la app
    Quiero buscar un producto
    Para ver sus resultados

    Scenario: Realizar una búsqueda de un producto
        Given que estoy en la pantalla de inicio
        When toco la barra de búsqueda
        And escribo "playstation 5"
        And presiono el boton filtros
        And aplico filtros de nuevo
        And aplico filtros de ubicación
        And aplico filtro de precio
        And aplico los filtros
        Then Obtengo el precio y nombre de 5 productos