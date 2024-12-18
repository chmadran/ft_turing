
type tape = {
  blank : char;
  data : string;
  left : string;
  right : string;
  head : int;
  size : int;
}

val parse_tape : string -> int -> char -> tape

val print_tape : tape -> unit

val print_tape_small : tape -> unit

val validate_tape_input : string -> string list -> char -> unit
