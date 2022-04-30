# Confronting Storage solutions

Where are preferences to be saved?<br>
Of course, users should be able to choose not to connect to any online service, but how is to be achieved multidevice synchronization, if needed?
Username and passwords are extremely sensible data. A free app cannot provide reassurance, so the best way to syncronize hosts, in my opinion, is to let the user manage a json file, and the cloud storage of a reputable service. Passwords, on the other hand, will require a more elegant solution, like an exportable cripted hive and key.

| Firebase | Json |
| --- | --- |
| Opensourcing the code requires user to start a own firebase project as noted [here](https://stackoverflow.com/questions/57236063/firebase-authentication-open-sourcing-android-app) | Scalable and simpler to code for devs; easier for paranoid users |
| Responsability lies both in opensourced code and in backend programming, as Firebase does not block failed login attemps and does not provide default logged device managing | Responsability cannot lie upon open source software when provided as is; user can choose a cloud service from a limited selection or export a preference file |
| Google | From [The Art of Unix Programming](https://en.wikipedia.org/wiki/The_Art_of_Unix_Programming)<br>* Write transparent programs<br>* Build on potential users' expected knowledge<br>* Build modular programs<br>* Write programs which fail in a way that is easy to diagnose |