# ft_turing

## Project Overview

The goal of this project is to write a program able to simulate a single headed, single
tape Turing machine from a machine description provided in json. This project is to be written in functionnal. We have chosen OCaml. 

![image](https://github.com/user-attachments/assets/368afc2c-aaaa-4acf-bf5b-0209135b4179)


## How to Run 

Please note that the blank character, while it must be part of the alphabet, must NOT be part of the input.

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

## Machine


**unary_add**   
Objective : being able to compute a unary addition (one +)
* Go all the way to the end of tape marker (=)
* Amend the end marker to a blank (.) and start heading LEFT
* Change first 1 to = (except if 1+1)
* Head left until you find + and change it to 1

**unary_sub**    
Objective : being able to compute a unary substraction (one -)
* Go all the way to the end of tape marker (=)
* Amend the end marker to a blank (.) and start heading LEFT, mode eraseone
* Change first 1 to =, mode subone
* Skip until find a 1 and change it to '.', else if only encouter '-' then HALT 

**0n1n**   
Objective : Is there the same number of 1 and 0
* Check first character, amend it to '.' to mark the beggining of the tape
* If 1, look for matching 0 | if 0, find matching 1
* Mark match with x (seen)
* Reset head to beggining (.)
* Process till find 1 or 0 and look for match
* Once all characters have been matched (x) and you encounter end of tape marker (=) then go to end it will recheck and mark as true
* If no match is found it will go to false

**02n**   
Objective : Is the input an even number of 0s, write y or n 
* Look for the first 0, once reached we have an odd number (1)
* Look for an even number of 0, once reached we have an even number (2)
* And so on until we reach =
* If we are looking for an odd number, it means current status is even so go to true (opposite if even)

**palindrome**   
Objective : Is the input a palindrome or not, write y or n 
* Check first character, amend it to '.' to mark the beggining of the tape
* Head to the end of the tape (=) 
* From the left/end, look for the matching (same) character 
* Until we only have 1 character left (true)
* Or two different characters left (false)

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
