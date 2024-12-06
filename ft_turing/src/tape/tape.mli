(* tape.mli *)

(** Type definition for the Turing machine tape. *)
type tape = {
  blank : char;
  data : string;
  left : string;
  right : string;
  head : int;
  size : int;
}

(** [parse_tape input tape_size blank_char] parses the input string into a tape format. *)
val parse_tape : string -> int -> char -> tape

(** [print_tape tape] prints the current content of the tape. *)
val print_tape : tape -> unit

(** [print_tape_small tape] prints the whole tape structure. *)
val print_tape_small : tape -> unit

(** [validate_tape_input input alphabet] checks if all characters in the input string
    are part of the given alphabet. *)
val validate_tape_input : string -> string list -> unit
