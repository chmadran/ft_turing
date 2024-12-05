(* tape_parser.mli *)

(** Type definition for the Turing machine tape. *)
type tape = {
  (* left : string;  The part of the tape before the head *)
  right : string; (* The part of the tape after the head *)
  head : char;    (* The current character under the head *)
}

(** [parse_tape input] parses the input string into a tape format. *)
val parse_tape : string -> tape

(** [print_tape tape] prints the current content of the tape. *)
val print_tape : tape -> unit

(** [validate_tape_input input alphabet] checks if all characters in the input string
    are part of the given alphabet. *)
val validate_tape_input : string -> string list -> unit
