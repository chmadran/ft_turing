(* machine.ml *)

open Parser

(** Machine state type *)
type machine_state = {
  tape : Tape.tape;
  current_state : string;
  transitions : (string * transition list) list;
}

(** Print column headers for the simulation *)
let print_column_headers tape_width state_width char_width action_width =
  Printf.printf "%-*s %-*s %-*s %-*s\n"
    tape_width "TAPE"
    state_width "TO_STATE"
    char_width "READ"
    action_width "ACTION"


(** [find_transition transitions state char] retrieves the appropriate transition
    for the given state and character from the list of transitions. *)
let find_transition transitions state char =
  match List.assoc_opt state transitions with
  | None -> None
  | Some state_transitions ->
      List.find_opt (fun t -> t.read = String.make 1 char) state_transitions

(** [apply_transition state transition] applies a transition to the current machine state. *)
let apply_transition (state : machine_state) (transition : transition) =
  let tape = state.tape in
  let new_data = Bytes.of_string tape.data in
  Bytes.set new_data tape.head transition.write.[0];
  let new_head, new_left, new_right =
    match transition.action with
    | Parser.Left ->
        let new_head = max 0 (tape.head - 1) in
        let new_left = if tape.head = 0 then String.make 1 tape.blank ^ tape.left else tape.left in
        let new_right =
          if tape.head < String.length tape.data - 1 then
            String.sub tape.data (tape.head + 1) (String.length tape.data - tape.head - 1)
          else ""
        in
        (new_head, new_left, new_right)
    | Parser.Right ->
        let new_head = min (String.length tape.data - 1) (tape.head + 1) in
        let new_left = String.sub tape.data 0 tape.head in
        let new_right =
          if tape.head + 1 < String.length tape.data then
            String.sub tape.data (tape.head + 1) (String.length tape.data - tape.head - 1)
          else ""
        in
        (new_head, new_left, new_right)
  in
  {
    tape = { tape with data = Bytes.to_string new_data; left = new_left; right = new_right; head = new_head };
    current_state = transition.to_state;
    transitions = state.transitions;
  }

(** [simulate machine_state finals headers_printed] simulates the Turing machine until it reaches a final state. *)
let rec simulate (state : machine_state) (finals : string list) (headers_printed : bool ref) =
  (* Define fixed widths for alignment *)
  let state_width = 10 in
  let char_width = 2 in
  let action_width = 10 in
  let tape_width = String.length state.tape.data + 5 in

  (* Print the column headers only once at the beginning *)
  if not !headers_printed then (
    print_column_headers tape_width (state_width + 3) (char_width + 5) action_width;
    headers_printed := true
  );

  (* Get the character being read as a string for formatting *)
  let current_char = String.make 1 state.tape.data.[state.tape.head] in

  (* Print the current state of the tape and the machine *)
  Tape.print_tape_small state.tape;
  Printf.printf "(%-*s, %*s)\n"
    state_width state.current_state
    char_width current_char;
  if List.mem state.current_state finals then
    (* Machine has reached a final state *)
    Printf.printf "Machine halted in state: %s\n" state.current_state
  else
    match find_transition state.transitions state.current_state state.tape.data.[state.tape.head] with
    | None ->
        Printf.printf "No transition defined for state: %s and character: %s\n"
          state.current_state current_char;
        Printf.printf "Machine halted in an undefined state.\n"
    | Some transition ->
        let new_state = apply_transition state transition in
        simulate new_state finals headers_printed
