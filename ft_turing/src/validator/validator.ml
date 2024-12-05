open Parser

(** Validate that all characters in the alphabet are of length 1. *)
let validate_alphabet alphabet =
  if List.exists (fun s -> String.length s <> 1) alphabet then
    failwith "Error: All alphabet characters must be single characters."

(** Validate that the blank character is part of the alphabet. *)
let validate_blank blank alphabet =
  if not (List.mem blank alphabet) then
    failwith "Error: Blank character must be part of the alphabet."

(** Validate that the initial state is part of the states list. *)
let validate_initial_state initial states =
  if not (List.mem initial states) then
    failwith "Error: Initial state must be part of the states list."

(** Validate that all final states are part of the states list. *)
let validate_finals finals states =
  if not (List.for_all (fun s -> List.mem s states) finals) then
    failwith "Error: All final states must be part of the states list."

(** Validate the transitions. *)
let validate_transitions transitions states alphabet =
  List.iter (fun (state, trans_list) ->
      if not (List.mem state states) then
        failwith ("Error: Undefined state in transitions: " ^ state);
      List.iter (fun t ->
          if not (List.mem t.read alphabet) then
            failwith ("Error: Undefined read character in transition: " ^ t.read);
          if not (List.mem t.write alphabet) then
            failwith ("Error: Undefined write character in transition: " ^ t.write);
          if not (List.mem t.to_state states) then
            failwith ("Error: Undefined state in transition: " ^ t.to_state)
        ) trans_list
    ) transitions

(** Validate the entire Turing machine. *)
let validate_machine (machine : Parser.turing_machine) =
  validate_alphabet machine.alphabet;
  validate_blank machine.blank machine.alphabet;
  validate_initial_state machine.initial machine.states;
  validate_finals machine.finals machine.states;
  validate_transitions machine.transitions machine.states machine.alphabet;
  true (* Return true if no exceptions were raised *)
