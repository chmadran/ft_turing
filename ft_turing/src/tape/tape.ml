
type tape = {
  blank : char;
  data : string;
  left : string;
  right : string;
  head : int;
  size : int;
}

let parse_tape input tape_size blank_char =
  if String.length input = 0 then
    failwith "Error: Input string cannot be empty."
  else
    {
      blank = blank_char;  
      data = input;        
      left = "";           
      right = String.sub input 1 (String.length input - 1);
      head = 0;            
      size = tape_size;
    }

let print_tape_small tape =
  let tape_width = 5 in

  let head_char = tape.data.[tape.head] in
  let left = String.sub tape.data 0 tape.head in
  let right =
    if tape.head + 1 < String.length tape.data then
      String.sub tape.data (tape.head + 1) (String.length tape.data - tape.head - 1)
    else
      ""
  in
  let tape_string = Printf.sprintf "[<%c>%s%s]" head_char left right in

  Printf.printf "%-*s  " tape_width tape_string


let print_tape tape =
  print_endline ("Tape blank : " ^ (String.make 1 tape.blank));
  print_endline ("Tape data : " ^ tape.data);
  print_endline ("Tape left : " ^ tape.left);
  print_endline ("Tape right : " ^ tape.right);
  print_endline ("Tape head : " ^ (String.make 1 tape.data.[tape.head]));
  print_endline ("Tape size : " ^ string_of_int tape.size);
  
  let left_part = tape.left in
  let right_part = tape.right in
  Printf.printf "\nTape: [%s<%c>%s] (size: %d)\n"
    left_part tape.data.[tape.head] right_part tape.size


let validate_tape_input input alphabet blank_char =
  let is_valid_char c = 
    List.mem (String.make 1 c) alphabet && c <> blank_char
  in
  if String.exists (fun c -> not (is_valid_char c)) input then
    failwith "Error: Input string contains invalid characters, like blank or one that is not in the alphabet."
