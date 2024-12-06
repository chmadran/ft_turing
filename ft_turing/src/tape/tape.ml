(* tape.ml *)

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
let parse_tape input tape_size blank_char =
  if String.length input = 0 then
    failwith "Error: Input string cannot be empty."
  else
    {
      blank = blank_char;  (* The blank character from the machine description *)
      data = input;        (* The input string itself is the data on the tape *)
      left = "";           (* Initially, no part of the tape is to the left of the head *)
      right = String.sub input 1 (String.length input - 1); (* Rest of the string after the head *)
      head = 0;            (* The head starts at the first character *)
      size = tape_size;    (* The size of the tape is the length of the input string *)
    }

(** [print_tape_small tape] prints the current content of the tape in a fixed-width format. *)
let print_tape_small tape =
  (* Define a fixed width for alignment *)
  let tape_width = 5 in

  (* Prepare the string representation of the tape with the head highlighted *)
  let head_char = tape.data.[tape.head] in
  let left = String.sub tape.data 0 tape.head in
  let right =
    if tape.head + 1 < String.length tape.data then
      String.sub tape.data (tape.head + 1) (String.length tape.data - tape.head - 1)
    else
      ""
  in
  let tape_string = Printf.sprintf "[<%c>%s%s]" head_char left right in

  (* Print the tape within the fixed width *)
  Printf.printf "%-*s  " tape_width tape_string


(** [print_tape tape] prints the whole tape structure. *)
let print_tape tape =
  print_endline ("Tape blank : " ^ (String.make 1 tape.blank));
  print_endline ("Tape data : " ^ tape.data);
  print_endline ("Tape left : " ^ tape.left);
  print_endline ("Tape right : " ^ tape.right);
  print_endline ("Tape head : " ^ (String.make 1 tape.data.[tape.head]));
  print_endline ("Tape size : " ^ string_of_int tape.size);
  
  (* Print the full tape with head marked *)
  let left_part = tape.left in
  let right_part = tape.right in
  (* Ensure that the left part does not contain the head symbol and that the head is placed in between *)
  Printf.printf "\nTape: [%s<%c>%s] (size: %d)\n"
    left_part tape.data.[tape.head] right_part tape.size


(** [validate_tape_input input alphabet] checks if all characters in the input string
    are part of the given alphabet. *)
let validate_tape_input input alphabet =
  let is_valid_char c = List.mem (String.make 1 c) alphabet in
  if String.exists (fun c -> not (is_valid_char c)) input then
    failwith "Error: Input string contains invalid characters not in the alphabet."
