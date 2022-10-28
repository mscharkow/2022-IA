# https://wegweisr.haim.it/R/ep1.r
# Hallo zum R-Skript von Episode I

# Alles hinter dem # in einer Zeile wird als "Kommentar" ignoriert.
# Der erste wirkliche Befehl folgt also erst jetzt:
library(tidyverse)




# Ein Wert
42


# Eine einfache Rechnung
(42*sqrt(2))/13.7603


# Immer alles einzutippen, ist müßig.
# Damit sich der Computer etwas merkt, gibt es in R Variablen.
# Variablen werden über den angedeuteten Pfeil nach links (<-) zugewiesen.
# (Beachte: Nach Ausführung taucht die Variable im RStudio-Environment auf)
halbe_wahrheit <- 21


# Variablennamen sollten zumindest drei Spielregeln folgen:
# - einfach: keine Leerzeichen, Umlaute und Sonderzeichen, außer _ und .
# - selbsterklärend: lieber "summe_likes" statt "test3"
# - konsistent: neben "summe_likes" gibt es "summe_comments", nicht "sumComments"
outlet_name <- 'ZEIT online'
outlet_url <- 'https://zeit.de/'
anzahl_artikel <- 1024
mittelwert_likes_je_artikel <- 74.2


# Statt mit Zahlen kann R natürlich auch mit Variablen umgehen und rechnen.
geschaetzte_summe_likes <- anzahl_artikel*mittelwert_likes_je_artikel


# Um Variablen auf der Konsole auszugeben, kann man sie übrigens einfach eingeben.
geschaetzte_summe_likes


# Aber mal ehrlich, einzelne Zahlen sind Kindergeburtstag.
# R wird erst wirklich brauchbar, wenn wir mit vielen Zahlen arbeiten.
# Dafür nutzt R "Vektoren", die mit einem kleinen "c" generiert werden.
# Hier legen wir eine Reihe mit dem Alter von sechs Personen an.
alter <- c(23, 24, 23, 25, 20, 26)


# What? Reihe? Vektoren? c? Dasgehtmirallesvielzuschnell!!1!
# Keine Sorge: Mit "str" stellt R die STRuktur von Variablen dar.
str(alter)
# Wir sehen also, dass es sich um eine numerische Liste mit Elementen von 1 bis 6 handelt.


# R kann Rechenoperationen jetzt ganz einfach auf alle Einträge der Liste anwenden.
# Und das in atemberaubendem Tempo.
alter_quadriert <- alter^2
str(alter_quadriert)


# Noch nicht beeindruckt?
# Okay, okay, okay. Wir laden ein paar tatsächliche Daten:
tote_in_breaking_bad <- read_csv('https://wegweisr.haim.it/Daten/breaking_bad_deaths.csv')


# Oh, äh, was lief da schief?
# Nichts! Rot heißt in R nicht immer "schlecht" (manchmal aber schon).
# Also: Meldungen in der Konsole lesen!


# Okay, zurück zum Datensatz. Was haben wir hier?
str(tote_in_breaking_bad)


# Ziemlich wilde Datenstruktur. Das Kürzel "tbl" deutet aber auf eine "Tibble"-Tabelle hin.
# Es gibt in R zahlreiche Tabellenformate (z.B. "Dataframes"). Die bequemsten aber heißen "tibble".
# Und das haben wir hier: ein tibble. Das können wir einfach mal ausgeben:
tote_in_breaking_bad


# Und mit unserem "tibble" können wir jetzt recht "selbsterklärend" weiter arbeiten.
# Gelesen von oben nach unten: Nimm die Tabelle und zähle!
tote_in_breaking_bad %>% 
  count()


# Nimm die Tabelle, filtere auf Einträge, in denen der Mörder "Walter White" heißt, und zähle dann!
tote_in_breaking_bad %>% 
  filter(murderer == 'Walter White') %>% 
  count()


# Nimm die Tabelle und fasse zusammen auf die Gesamtzahl (wie count) und die Anzahl einzigartiger Namen!
tote_in_breaking_bad %>% 
  summarise(
    number_of_entries = n(),
    number_of_murderers = n_distinct(murderer)
  )


# Nimm die Tabelle, filtere auf den Mörder "Walter White" und zähle alle Einträge sowie die Mordarten!
tote_in_breaking_bad %>% 
  filter(murderer == 'Walter White') %>% 
  summarise(
    number_of_entries = n(),
    number_of_methods = n_distinct(method)
  )



# Nimm die Tabelle, filtere auf "Walter White", gruppiere nach Mordart und zähle (je Gruppe)!
tote_in_breaking_bad %>% 
  filter(murderer == 'Walter White') %>% 
  group_by(method) %>% 
  count()


# Nimm die Tabelle, filtere auf "Walter White", gruppiere nach Mordart, zähle und sortiere absteigend!
tote_in_breaking_bad %>% 
  filter(murderer == 'Walter White') %>% 
  group_by(method) %>% 
  count() %>% 
  arrange(-n)

