
(* [check_file_input args] verifies that 
- the machine file is provided 
- it is accessible and readable
- it has a json extension *)

let check_file_input args =
  match args with
  | [| _; filename ; _machine_input|] ->
    if String.length filename >= 5 && String.sub filename (String.length filename - 5) 5 = ".json" then
      try
        let ic = open_in filename in
        close_in ic;
        Some filename
      with
      | Sys_error err ->
        print_endline ("Error: " ^ err);
        None
    else
      (print_endline "Error: The file must have a .json extension.";
       None)
  | _ ->
    print_endline "Error: Please provide one machine file and a machine input.";
    None

let () =
  match check_file_input (Sys.argv) with
  | Some filename ->
    print_endline ("Parsing machine '" ^ filename ^ "'...")
    let key_mappings, move_sequences = Parser.process_grammar_file filename in


    (* Machine.machine_loop machine_input *)

  | None -> exit 1
