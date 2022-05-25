# Roadmap


* [X] Try bloc;
* [X] Try to generate a listview with details taken from cubit state
* [X] Test the state management with a function that spawns fake terminals
* [X] "Precise" navigation to terminals through bottom navigation drawer
* [ ] Side sheet for "quick" navigation
* [X] True terminals
* [X] Menu for adding a new Host
* [X] Store and load hosts from memory
* [X] if override acceptKeyStroke=true, arrow key up is listened by both the terminal and Android, which moves focus away from the terminal. Try to wrap terminal into a Focus (onKey: )
* [ ] Unhandled Exception: SSHStateError(Transport is closed)
* [ ] LateInitializationError: Field '_shell@' has not been initialized. (terminal backend)
* [ ] App might be chosen for opening text files
* [X] In new host page too many unchecked void objects => error message will not be shown because of exceptions
* [X] Scripts overview section
* [X] Scripts execution
* [X] Migrate from hostsState.getList() to dart-specific getter
* [X] move cubit_scripts to top with multiblocprovider, or else, the bloc is destroyed at every page change. Furthermore, bloc is lazy, so you have no reason not to declare it early
* [ ] include features from terminal/readme.md
* [ ] think of a less redundant way to relay execution events
* [X] ssh executor is silly and might get blocked on disconnect. Using a shell resolves this and returns exit codes
* [X] No suck method dispose() in NewHostPage.build.<anonymous closure> (package:sshtm/Hosts/widget_page_new_host.dart:36)
* [ ] In object_terminal_backends and object_job pass a user interaction function to resolve keychain losses or onUserInputRequest from SSHClient
* [ ] LOGS
* [ ] splash screen while waiting for hive