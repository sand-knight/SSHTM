# sshtm

A new Flutter project for a class assignment. This app aims to manage connections to ssh servers, store scripts, execute rapid actions on defined servers, define event driven tasks, sort execution logs.

Last test-able build: 13  May 2022 01.28
What you can see: list of hosts, list of working terminals updated and saved on navigation, menu to add new Host. List of scripts, read from Android/data/com.example.sshtm/files/Scripts. On tap, can execute script on hosts (android only for now)



https://user-images.githubusercontent.com/79469450/163856892-c35ab039-1d33-461c-bbdc-3c72e9256770.mp4



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

Discovered that bloc is lazy: there is no reason not to create a bloc early in the tree.

### Diary of storage choices

Script are actual files stored inside Android/data/com.example.sshtm/files/Scripts. Their name is their actual filename, their comment is
the commented line starting with ##SSHTM, wich must be the last one (excluding empty lines).

My first idea was to encode them in an exportable json, but discovered that, being able to export that file, means being able to back up on firestore. Ideally, users should choose whether to use cloud capabilites or not, but with limited time, I should focus on one solution first.