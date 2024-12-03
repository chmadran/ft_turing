
(* [check_file_input args] verifies that 
- the machine file is provided 
- it is accessible and readable
- it has a json extension *)

(* Example: main.ml *)

let check_file_input args =
  match args with
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

let () =
  match check_file_input (Sys.argv) with
  | Some filename -> print_endline ("Parsing machine: " ^ filename)
  | None -> exit 1
