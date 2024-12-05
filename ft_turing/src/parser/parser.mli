type action = Left | Right

type transition = {
  read : string;
  to_state : string;
  write : string;
  action : action;
}

type turing_machine = {
  name : string;
  alphabet : string list;
  blank : string;
  states : string list;
  initial : string;
  finals : string list;
  transitions : (string * transition list) list; (* e.g scanright gets matched to a few transitions *)
}

(** Parse a Turing machine description from a JSON file. 
    @param filename The path to the JSON file.
    @return A [turing_machine] record if parsing is successful. *)
val parse_turing_machine : string -> turing_machine
