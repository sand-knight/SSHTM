# sshtm

A new Flutter project for a class assignment. This app aims to manage connections to ssh servers, store scripts, execute rapid actions on defined servers, define event driven tasks, sort execution logs.

Last test-able build: 28  May 2022 16:45
What you can do: add hosts, open terminals, execute scripts on selected hosts, visualize logs, open logs folder with external file manager. Everything is in Android/data/[app]/.



https://user-images.githubusercontent.com/79469450/170831504-666c4c84-adb0-4e09-a9b4-0a055d724b7f.mp4




### Implementation idea


The state of the main scaffold is the last visited section; every section has a different appmenu and body, which will be implemented trying to separate the code of the following areas:

1. Hosts : Known machines, towards which terminals can be opened. Each host is uniquely identified by address, username and port, and is associated with (instances) the collection of terminals opened towards it. When starting the app, every terminal collection will be empty. There is **one special** host, which represent the local Android shell.
2. Scripts : Simple text files, which can be imported or written in-app. Maybe the app will understand the shebang? On tap, the user can select a subset of the hosts on which the tapped script will be executed.
3. Actions : (script, subset(Host)) associations, for a quick script execution. Maybe a homescreen widget can make use of actions?
4. Tasks : (Actions, AndroidEvent) associations, for automation.
5. Logs : stdin,stdout e stderr will be saved in text files, grouped by their execution batch of origin.

### Diary of state management

Cubit to manage `<Host< Terminal[] >>[]` (1) is "global" (wraps Material App) because many routes are going need the state of the hosts.
Terminals are saved from route change by holding a reference to the terminal view. The terminal page is stateless.

Discovered that it is necessary to have an unloaded state to emulate futurebuilder with bloc.

Another Cubit is responsible for fetching scripts.

A bloc exposes the queue of running scripts and relays running events, for toasts and notifications to listen.

The above are children of a settings cubit which loads data needed by both UI, data structures and logics.


### Diary of storage choices

Script are actual files stored inside Android/data/com.example.sshtm/files/Scripts. Their name is their actual filename, their comment is
the commented line starting with ##SSHTM, wich must be the last one (excluding empty lines).

The list of hosts is encoded in an exportable json. Being able to export that file, might mean being able to back up on firestore. Ideally, users should choose whether to use cloud capabilites or not, but with limited time, I should focus on one solution first.

Scripts and logs are text files accessible easily with a file manager.
