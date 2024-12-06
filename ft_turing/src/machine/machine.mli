(* machine.mli *)

open Parser

(** Type representing the state of the Turing machine. *)
type machine_state = {
  tape : Tape.tape;
  current_state : string;
  transitions : (string * transition list) list;
}

(** [simulate state finals] simulates the Turing machine starting from [state]
    until it reaches a final state in [finals]. *)
val simulate : machine_state -> string list -> unit
