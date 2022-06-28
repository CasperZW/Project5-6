# Algemeen/installatie Xcode:

Om de IOS versie van de app te programmeren heb je Xcode nodig. 
Er zit een belangrijk nadeel aan Xcode: Het werkt alleen op MacOS dit is het besturingssysteem op apple laptops en computers. 
Dit zou omzeild kunnen worden door middel van een virtuele machine maar dat kan erg ingewikkeld worden. 
Daarom wordt aangeraden om een apple product te gebruiken. 
Download vervolgens Xcode via de app store en volg de stappen voor de installatie. 
Als Xcode opgestart is kan je het PijnApp-project openen. 
Als je het project geopend hebt kun je een simulator kiezen waarop je de app wilt runnen. 
Dit kan ook een aangesloten iPhone zijn. 
Druk vervolgens op het afspeel icoon om de app te builden en runnen. 



# DataFlow:
Alle data wordt opgeslagen in een struct.
Deze data staat in het Model mapje met als naam DataItem.
1 zo'n DataItem bestaat uit verschillende onderdelen zoals: pijn, stappen en stress.
Een nieuw DataItem wordt aangemaakt in de class NewMeasurement.
Vervolgens wordt het opgeslagen in ContentView, daar staat een variabele 'data' die weer overal gebruikt wordt.
In de class Measurements wordt de data opgehaald uit ContentView en uitgepakt om weer gegeven te worden.
Dit gebeurt ook in de MeasurementGraph maar dan in grafiek vorm.



# Classes:

ContentView
Dit is de 'main' pagina van de app vanaf hier kom je bij alle andere pagina's van de app. 
Hier is een ViewModifier gemaakt, deze modifier wordt op alle knoppen toegepast zodat ze allemaal hetzelfde design hebben. 
Al deze knoppen worden in een 'HStack' en 'VStack' geplaatst, dit zorgt ervoor dat ze mooi naast/onder elkaar staan. 
Als er een knop wordt ingedrukt wordt een NavigationLink geactiveerd die de gebruiker naar de volgende pagina stuurt.

NewMeasurement
Deze pagina komt als 'sheet' naar boven als er op 'nieuwe meting wordt gedrukt.
Alle vragen die aan de gebruiker gesteld worden staan in een 'Form'.
Bovenaan die 'Form' staat een 'Picker' met de vraag "Ochtend of Avond?". 
Gebaseerd op die keuze laat de 'Form' andere vragen zien.
Om het aantal stappen van die dag op te halen wordt er gebruik gemaakt van de class: HealthStore.

HealthStore
Deze class wordt gebruikt voor het ophalen van het aantal gezette stappen.
Hierbij wordt gebruik gemaakt van HealthKit en de code is hierop gebaseerd.
Voor meer informatie over HealthKit: https://developer.apple.com/documentation/healthkit

Measurements
Hier wordt doormiddel van een 'List' alle gegevens weergegeven. 
Er wordt met een ForEach alle items langsgelopen en in duidelijke tekstvorm afgebeeld.
Hier wordt ook de .onDelete modifier toegepast om makkelijk items te verwijderen.
Als er 3 of meer items zijn toegevoegd wordt een knop zichtbaar om naar de grafiek te gaan.

MeasurementsGraph
Hier wordt gebruik gemaakt van de SwiftUICharts package.
Voor meer informatie over deze package kijk op https://github.com/willdale/SwiftUICharts
Er is hier gekozen voor een MultiLineChart.
Deze is weer opgebouwd uit normale LineCharts.
Voor iedere soort informatie is daarvoor een LineChart gemaakt.
Ook is voor iedere soort een knop gemaakt om deze aan of uit te zetten.

Settings
Bestaat uit een 'Form' met daarin:
Een knop om testdate toe te voegen, dit zijn random getallen tussen 0-10 (of 0-12000 voor stappen).
Een knop voor rechte grafieklijnen, dit veranderd de variabele 'lineSetting' die wordt gebruikt in MeasurementGraph.

InformationTab/InformationPage
Dit is een lijst met alle onderwerpen waarover informatie gegeven wordt.
Op ieder onderwerp kan gedrukt worden om naar die pagina te gaan met verdere informatie over dat onderwerp.






