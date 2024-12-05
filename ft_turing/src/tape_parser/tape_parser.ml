(* tape_parser.ml *)

(** Type definition for the Turing machine tape. *)
type tape = {
  (* left : string;  The part of the tape before the head *)
  right : string; (* The part of the tape after the head *)
  head : char;    (* The current character under the head *)
}

(** [parse_tape input] parses the input string into a tape format. *)
let parse_tape input =
  if String.length input = 0 then
    failwith "Error: Input string cannot be empty."
  else
    {
      (* left = "";  Initially, no left part of the tape *)
      right = String.sub input 1 (String.length input - 1);  (* Rest of the string after the head *)
      head = input.[0];  (* The head starts at the first character *)
    }

(** [print_tape tape] prints the current content of the tape. *)
let print_tape tape =
  Printf.printf "Tape: [<%c>%s]\n" tape.head tape.right

(** [validate_tape_input input alphabet] checks if all characters in the input string
    are part of the given alphabet. *)
let validate_tape_input input alphabet =
  let is_valid_char c = List.mem (String.make 1 c) alphabet in
  if String.exists (fun c -> not (is_valid_char c)) input then
    failwith "Error: Input string contains invalid characters not in the alphabet."
