open Yojson.Basic.Util

(** Type definitions for the Turing machine *)
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
  transitions : (string * transition list) list;
}

(** Helper to convert string to action type *)
let action_of_string = function
  | "LEFT" -> Left
  | "RIGHT" -> Right
  | s -> failwith ("Invalid action: " ^ s)

(** Parse a single transition *)
let parse_transition json =
  {
    read = json |> member "read" |> to_string;
    to_state = json |> member "to_state" |> to_string;
    write = json |> member "write" |> to_string;
    action = json |> member "action" |> to_string |> action_of_string;
  }

(** Parse transitions for a state *)
let parse_transitions json =
  json
  |> to_assoc
  |> List.map (fun (state, transitions) ->
         let transitions = transitions |> to_list |> List.map parse_transition in
         (state, transitions))

(** Parse the entire Turing machine *)
let parse_turing_machine filename =
  let json = Yojson.Basic.from_file filename in
  {
    name = json |> member "name" |> to_string;
    alphabet = json |> member "alphabet" |> to_list |> List.map to_string;
    blank = json |> member "blank" |> to_string;
    states = json |> member "states" |> to_list |> List.map to_string;
    initial = json |> member "initial" |> to_string;
    finals = json |> member "finals" |> to_list |> List.map to_string;
    transitions = json |> member "transitions" |> parse_transitions;
  }
