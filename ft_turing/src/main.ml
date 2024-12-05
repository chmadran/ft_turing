(* [check_file_input args] verifies that 
- the machine file is provided 
- it is accessible and readable
- it has a json extension 
- else if it's the help flag *)
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
    | [| _; filename |] when String.length filename >= 5 && String.sub filename (String.length filename - 5) 5 = ".json" ->
      (try
         let ic = open_in filename in
         close_in ic;
         Some filename
       with Sys_error err ->
         print_endline ("Error: " ^ err);
         None)
    | _ ->
      print_endline "Error: Please provide a JSON file as input.";
      None
  
  (* [print_machine machine] prints the parameters of the Turing machine. *)
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
      Printf.printf "  %s:\n" state;
      List.iter (fun t ->
        Printf.printf "    - Read: %s, To State: %s, Write: %s, Action: %s\n"
          t.Parser.read t.Parser.to_state t.Parser.write
          (match t.Parser.action with
           | Parser.Left -> "LEFT"
           | Parser.Right -> "RIGHT")
      ) transitions      
    ) machine.transitions
  
  let () =
    match check_file_input (Sys.argv) with
    | Some filename -> 
      print_endline ("Parsing machine: " ^ filename);
      let machine = Parser.parse_turing_machine filename in
      print_endline ("Successfully parsed machine: " ^ machine.name);
      print_machine machine
    | None -> exit 1
  