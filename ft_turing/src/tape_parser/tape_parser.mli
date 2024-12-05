(* tape_parser.mli *)

(** Type definition for the Turing machine tape. *)
type tape

(** [parse_tape input] parses the input string into a tape format. *)
val parse_tape : string -> tape

(** [print_tape tape] prints the current content of the tape. *)
val print_tape : tape -> unit
