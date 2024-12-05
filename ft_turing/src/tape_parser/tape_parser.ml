(** Type definition for the Turing machine tape. *)
type tape = {
  (* left : string;  before the head *)
  right : string; (* after the head *)
  head : char;    (* current character under the head *)
}

(** [parse_tape input] parses the input string into a tape format. *)
let parse_tape input =
  if String.length input = 0 then
    failwith "Error: Input string cannot be empty."
  else
    {
      (* left = "";   *)
      right = String.sub input 1 (String.length input - 1);  (* Rest of the string after the head *)
      head = input.[0];  (* head starts at the first character *)
    }

(** [print_tape tape] prints the current content of the tape. *)
let print_tape tape =
  (* Print the tape as [<h>ello] where <h> is the head under the tape's head *)
  Printf.printf "[<%c>%s]\n" tape.head tape.right
