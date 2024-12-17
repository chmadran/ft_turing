# ft_turing


## TODO list

* utm : make ARG="alphabet: [1, ., +, = ]\|blank:.\|initial:A\|states:[replaceone, addone, end, HALT ]\|finals:[HALT]\|transitions:{ scanright: [{ read: ., to_state: scanright, write: ., action: RIGHT}]\|input:111+11="

* utm : 

make ARG='{ \"name\": \"utm_unary_add\", \"alphabet\": [\"1\", \".\", \"+\", \"=\"], \"blank\": \".\", \"states\": [\"replaceone\", \"addone\", \"end\", \"HALT\"], \"initial\": \"scanright\", \"finals\": [\"HALT\"], \"transitions\": { \"scanright\": [ { \"read\": \".\", \"to_state\": \"scanright\", \"write\": \".\", \"action\": \"RIGHT\" }, { \"read\": \"1\", \"to_state\": \"scanright\", \"write\": \"1\", \"action\": \"RIGHT\" }, { \"read\": \"+\", \"to_state\": \"scanright\", \"write\": \"+\", \"action\": \"RIGHT\" }, { \"read\": \"=\", \"to_state\": \"addone\", \"write\": \".\", \"action\": \"LEFT\" } ], \"replaceone\": [ { \"read\": \"1\", \"to_state\": \"replaceone\", \"write\": \"1\", \"action\": \"LEFT\" }, { \"read\": \"+\", \"to_state\": \"end\", \"write\": \"1\", \"action\": \"RIGHT\" } ], \"addone\": [ { \"read\": \"1\", \"to_state\": \"replaceone\", \"write\": \"=\", \"action\": \"LEFT\" }, { \"read\": \"+\", \"to_state\": \"HALT\", \"write\": \"1\", \"action\": \"LEFT\" } ], \"end\": [ { \"read\": \"1\", \"to_state\": \"end\", \"write\": \"1\", \"action\": \"RIGHT\" }, { \"read\": \"=\", \"to_state\": \"HALT\", \"write\": \".\", \"action\": \"RIGHT\" } ] } }\;input=111+1='


* The blank character, must be part of the alphabet, must NOT be part of the
input.


## Project Overview

The goal of this project is to write a program able to simulate a single headed, single
tape Turing machine from a machine description provided in json. This project is to be written in functionnal. We have chosen OCaml. 

![image](https://github.com/user-attachments/assets/368afc2c-aaaa-4acf-bf5b-0209135b4179)


## How to Run 

There are two ways to start this machine : 

```make ARG="--help"``` or ```make ARG="-h"```

1. The first way is by passing two arguments : 
* a json file with the machine configuration ; and 
* an input string 

```make ARG="[machine_file.json] [input string=]"```

2. The second way is by passing a string that contains the machine : 
* a string with the config and the input, for example : 

```
JSON_CONFIG;input=INPUT_STRING
```

Whereby the string gets split between : 
* the machine : a json file is created with the configuration 
* the input string

Who then gets sent to the programme as the json file and the input string for parsing and validation before launching the machine. 


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

## The machines 

1. **UNARY ADD**
A machine able to compute an unary addition.

Working input : 11+11=
Not working input : 1..1

2. **PALINDROME**
A machine able to decide whether its input is a palindrome or not (whether it is the same forwards and backwards). If it is a palindrome, it will write y on the tape at the end. If it is not a palindrome, it will write n.

Working input : 1111, 11011
Not working input : 10111

3. **0^n1^n**
A machine able to decide if the input is a word of the language 0^n1^n, for instance the words 000111 or 0000011111. Before halting, write the result on the tape as a ’n’ or a ’y’ at the right of the rightmost character of the tape.

Working input : 000111
Not working input : 0001111

4. **0^2n**
A machine able to decide if the input is a word of the language 0^2n, for instance
the words 00 or 0000, but not the words 000 or 00000. Before halting, write the
result on the tape as a ’n’ or a ’y’ at the right of the rightmost character of the
tape.

Working input : 00, 0000
Not working input : 000

5. **Machine of machine**
A machine able to run the first machine of this list, the one computing an unary
addition. The machine alphabet, states, transitions and input ARE the input of
the machine you are writing, encoded as you see fit.

## Research 

<details><summary>Turing Machines</summary>


Relevant ressources :    
* [Stanford Article](https://plato.stanford.edu/entries/turing-machine/)
* [Jussieu Article, in french](https://www.liafa.jussieu.fr/~carton/Enseignement/Complexite/MasterInfo/Cours/turing.html)

</details>
