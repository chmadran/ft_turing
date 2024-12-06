(* machine.ml *)

open Parser

(** Machine state type *)
type machine_state = {
  tape : Tape.tape;
  current_state : string;
  transitions : (string * transition list) list;
}

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

(** [simulate machine_state finals] simulates the Turing machine until it reaches a final state. *)
let rec simulate (state : machine_state) (finals : string list) =
  (* Print the current state of the tape and the machine *)
  Tape.print_tape_small state.tape;
  Printf.printf "(%s, %c)\n" state.current_state state.tape.data.[state.tape.head];

  if List.mem state.current_state finals then
    (* Machine has reached a final state *)
    Printf.printf "Machine halted in state: %s\n" state.current_state
  else
    match find_transition state.transitions state.current_state state.tape.data.[state.tape.head] with
    | None ->
        Printf.printf "No transition defined for state: %s and character: %c\n"
          state.current_state state.tape.data.[state.tape.head]
    | Some transition ->
        let new_state = apply_transition state transition in
        simulate new_state finals
