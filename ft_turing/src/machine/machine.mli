(* machine.mli *)

open Parser

(** Machine state type *)
type machine_state = {
  tape : Tape.tape;
  current_state : string;
  transitions : (string * transition list) list;
}

(** [find_transition transitions state char] retrieves the appropriate transition
    for the given state and character from the list of transitions. *)
val find_transition : (string * transition list) list -> string -> char -> transition option

(** [apply_transition state transition] applies a transition to the current machine state. *)
val apply_transition : machine_state -> transition -> machine_state

(** [simulate machine_state finals headers_printed] simulates the Turing machine until it reaches a final state. *)
val simulate : machine_state -> string list -> bool ref -> unit

(** Print column headers for the simulation *)
val print_column_headers : int -> int -> int -> int -> unit
