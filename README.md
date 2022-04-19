# sshtm

A new Flutter project for a class assignment. This app aims manage connections to ssh servers, store scripts, execute rapid actions on defined servers, define event driven tasks, sort execution logs.

Last test-able build: 18  Apr 2022 19:00
What you can see: list of hosts, list of working terminals updated and saved on exit



https://user-images.githubusercontent.com/79469450/163856892-c35ab039-1d33-461c-bbdc-3c72e9256770.mp4



### Dettagli logici d'implementazione

Lo scaffold principale conserva lo stato dell'ultima sezione visitata; ognuna è definita da un appmenu ed un body diverso che saranno implementati separatamente cercando di separare il più possibile i vari ambiti, che sono:

1. Hosts : Le macchine conosciute verso la quale si può aprire un terminale. Un host è univocamente identificato da un indirizzo, un utente, una password, un numero di porto. Un terminale può essere aperto verso un host dall'utente. Una collezione di terminali aperti è associata (istanziata) dall'host a cui sono associati. Esiste **un solo speciale host**, i cui terminali sono aperti verso la macchina locale Android.
2. Scripts : Semplici file di testo, importabili o scrivibili. Pianifichiamo che l'app comprenda lo shebang. Facoltativo: uno script esistente può essere eseguito su un subset di hosts definibile in una finestra popup di volta in volta.
3. Actions : Associazioni (script, subset(Host)) per permettere una veloce esecuzione degli script. Facoltativo: eventuali homescreen widget mostreranno azioni.
4. Tasks : Facoltativo: Associazioni (Actions, AndroidEvent) per l'automazione.
5. Logs : stdin,stdout e stderr saranno salvati in file di testo, raggruppati per batch di esecuzione.

### Dettagli sullo stato

Cubit per gestire `<Host< Terminal[] >>[]` (punto 1) è "globale" (padre di Material App) perché ci sono più route che hanno bisogno dello stato degli host: gli sheet associati ad ogni host, il side drawer, i menu per il lancio degli script, la pagina di definizione di una action.
I terminali salvati nello stato hanno una copia della lavagna, così che lo stato sia salvato. La pagina widget è stateless.
