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

(** Custom exception for missing JSON fields *)
exception Missing_field of string

(** Helper to safely retrieve a JSON field and provide a detailed error if it's missing *)
let get_field json field to_type =
  try to_type (json |> member field)
  with Type_error _ -> raise (Missing_field field)

(** Helper to convert string to action type *)
let action_of_string = function
  | "LEFT" -> Left
  | "RIGHT" -> Right
  | s -> failwith ("Invalid action: " ^ s)

(** Parse a single transition *)
let parse_transition json =
  {
    read = get_field json "read" to_string;
    to_state = get_field json "to_state" to_string;
    write = get_field json "write" to_string;
    action = get_field json "action" to_string |> action_of_string;
  }

(** Parse transitions for a state and check for duplicate keys or empty transitions *)
let parse_transitions json =
  let transition_assoc = json |> to_assoc in
  if transition_assoc = [] then
    failwith "Error: No transitions defined in the machine.";
  
  let seen_states = Hashtbl.create (List.length transition_assoc) in
  List.map (fun (state, transitions) ->
      if Hashtbl.mem seen_states state then
        failwith ("Error: Duplicate state key in transitions: " ^ state);
      Hashtbl.add seen_states state true;
      let transitions = transitions |> to_list |> List.map parse_transition in
      (state, transitions)
    ) transition_assoc

(** Parse the entire Turing machine from a JSON string *)
let parse_machine_from_string machine_config =

  let json = Yojson.Basic.from_string machine_config in
  try
    let name = get_field json "name" to_string in
    let alphabet = get_field json "alphabet" (fun j -> j |> to_list |> List.map to_string) in
    let blank = get_field json "blank" to_string in
    let states = get_field json "states" (fun j -> j |> to_list |> List.map to_string) in
    let initial = get_field json "initial" to_string in
    let finals = get_field json "finals" (fun j -> j |> to_list |> List.map to_string) in
    let transitions = get_field json "transitions" parse_transitions in

    { name; alphabet; blank; states; initial; finals; transitions }
  with Missing_field field ->
    failwith ("Error: Missing required field in JSON: " ^ field)


(** Parse the entire Turing machine from a file *)
let parse_turing_machine filename =
  let json = Yojson.Basic.from_file filename in
  try
    {
      name = get_field json "name" to_string;
      alphabet = get_field json "alphabet" (fun j -> j |> to_list |> List.map to_string);
      blank = get_field json "blank" to_string;
      states = get_field json "states" (fun j -> j |> to_list |> List.map to_string);
      initial = get_field json "initial" to_string;
      finals = get_field json "finals" (fun j -> j |> to_list |> List.map to_string);
      transitions = get_field json "transitions" parse_transitions;
    }
  with Missing_field field ->
    failwith ("Error: Missing required field in JSON: " ^ field)
