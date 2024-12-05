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

1. Parse the machine
2. Parse the tape 
3. Create the automate
4. Output the machine's states 


## Research 

<details><summary>Turing Machines</summary>


Relevant ressources :    
* [Stanford Article](https://plato.stanford.edu/entries/turing-machine/)
* [Jussieu Article, in french](https://www.liafa.jussieu.fr/~carton/Enseignement/Complexite/MasterInfo/Cours/turing.html)

</details>
