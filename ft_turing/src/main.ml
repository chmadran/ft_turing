(* main.ml *)

let check_file_input args =
  match args with
  | [| _; "--help" |] | [| _; "-h" |] ->
    print_endline "usage: ft_turing [-h] jsonfile input\n";
    print_endline "positional arguments:";
    print_endline "  jsonfile     json description of the machine\n";
    print_endline "  input        input of the machine\n";
    print_endline "optional arguments:";
    print_endline "  -h, --help  show this help message and exit";
    exit 0
  | [| _; filename; input |] when String.length filename >= 5 && String.sub filename (String.length filename - 5) 5 = ".json" ->
    (try
       let ic = open_in filename in
       close_in ic;
       Some (filename, input)
     with Sys_error err ->
       print_endline ("Error: " ^ err);
       None)
  | _ ->
    print_endline "Error: Please provide a JSON file and an input string.";
    None

let print_machine (machine : Parser.turing_machine) =
  let print_list label lst =
    print_endline (label ^ ": [" ^ (String.concat ", " lst) ^ "]")
  in
  print_endline ("Machine Name: " ^ machine.name);
  print_list "Alphabet" machine.alphabet;
  print_endline ("Blank Symbol: " ^ machine.blank);
  print_list "States" machine.states;
  print_endline ("Initial State: " ^ machine.initial);
  print_list "Final States" machine.finals;
  print_endline "Transitions:";
  List.iter (fun (state, transitions) ->
    print_endline ("  " ^ state ^ ":");
    List.iter (fun t ->
      print_endline ("   [- Read: " ^ t.Parser.read);
      print_endline ("    - To State: " ^ t.Parser.to_state);
      print_endline ("    - Write: " ^ t.Parser.write);
      print_endline ("    - Action: " ^
        (match t.Parser.action with
         | Parser.Left -> "LEFT]\n"
         | Parser.Right -> "RIGHT]\n"));
    ) transitions      
  ) machine.transitions    


let () =
  match check_file_input (Sys.argv) with
  | Some (filename, input) -> 
    print_endline ("Parsing machine: " ^ filename);
    (try
       let machine = Parser.parse_turing_machine filename in
       if Validator.validate_machine machine then
         print_endline ("Machine validated successfully: " ^ machine.name);
         print_machine machine;
         (* Validate the tape input against the machine's alphabet *)
         Tape.validate_tape_input input machine.alphabet;
         (* Calculate tape size based on the input string length *)
         let tape_size = String.length input in
         (* Parse and print the tape input with calculated size *)
         let tape = Tape.parse_tape input tape_size machine.blank.[0] in
         Tape.print_tape tape
     with
     | Failure msg ->
         print_endline ("Validation error: " ^ msg);
         exit 1
     | Sys_error err ->
         print_endline ("File error: " ^ err);
         exit 1)
  | None -> exit 1
