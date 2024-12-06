# ft_turing

## Project Overview

The goal of this project is to write a program able to simulate a single headed, single
tape Turing machine from a machine description provided in json. This project is to be written in functionnal. We have chosen OCaml. 

![image](https://github.com/user-attachments/assets/368afc2c-aaaa-4acf-bf5b-0209135b4179)


## How to Run 

```make ARG=[machine_file.json]```
```make ARG="--help"``` or ```make ARG="-h"```


## Steps 

Setup and File Input Handling:
Implement file input validation to check if the JSON file and machine input are provided.
Handle cases where either file is missing or incorrect.

Parsing the JSON Description:
Parse the JSON machine description to extract the machine's components (alphabet, states, transitions, etc.).
Handle any malformed or missing fields in the description, ensuring the program doesn't crash and provides relevant error messages.

Simulating the Turing Machine:
Initialize the machine state, including tape, head position, and current state.
Implement the simulation based on the parsed transitions and machine rules.

Machine Execution:
Simulate the Turing machine step by step, updating the tape, head position, and current state according to the transition rules.
Provide output at each step, showing the current tape state and head position.
Handle the HALT state and any potential errors (like getting stuck in an invalid state).

User Interaction and Error Handling:
Display relevant information to the user, including a readable form of the transitions, the initial state, the tape, etc.
Implement appropriate error messages if the machine is in a blocked state (i.e., no valid transition exists).

## Parsing

1. Parse the machine file with the following rules :

* **name:** The name of the described machine. 
* **alphabet:** Both input and work alphabet of the machine merged into a single alphabet
for simplicity’s sake, including the blank character. Each character of the alphabet
must be a string of length strictly equal to 1.
* **blank:** The blank character, must be part of the alphabet, must NOT be part of the
input.
* **states:** The exhaustive list of the machine’s states names.
* **initial:** The initial state of the machine, must be part of the states list.
* **finals:** The exhaustive list of the machine’s final states. This list must be a sub-list of
the states list.
* **transitions:** A dictionnary of the machine’s transitions indexed by state name. Each
transition is a list of dictionnaries, and each dictionnary describes the transition for
a given character under the head of the machine. A transition is defined as follows:
    * **read:** The character of the machine’s alphabet on the tape under the machine’s
    head.
    * **to_state:** The new state of the machine after the transition is done.
    * **write:** The character of the machine’s alphabet to write on the tape before moving
    the head.
    * **action:** Movement of the head for this transition, either LEFT, or RIGHT.


2. Parse the tape :
- is there a string after the json file ?
- validate tape : all characters in the input string must be part of the given alphabet
3. Create the automate
4. Output the machine's states 


## Research 

<details><summary>Turing Machines</summary>


Relevant ressources :    
* [Stanford Article](https://plato.stanford.edu/entries/turing-machine/)
* [Jussieu Article, in french](https://www.liafa.jussieu.fr/~carton/Enseignement/Complexite/MasterInfo/Cours/turing.html)

</details>
