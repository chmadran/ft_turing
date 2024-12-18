let write_machine_to_json machine filename =
  let json_content = 
    let transitions_to_json transitions = 
      String.concat ",\n" (List.map (fun (state, t_list) ->
        Printf.sprintf "\"%s\": [\n%s\n]" state 
          (String.concat ",\n" (List.map (fun t ->
            Printf.sprintf "  { \"read\": \"%s\", \"to_state\": \"%s\", \"write\": \"%s\", \"action\": \"%s\" }"
              t.Parser.read t.Parser.to_state t.Parser.write
              (if t.Parser.action = Parser.Right then "RIGHT" else "LEFT")
          ) t_list))
      ) transitions)
    in
    Printf.sprintf "{\n  \"name\": \"%s\",\n  \"alphabet\": [%s],\n  \"blank\": \"%s\",\n  \"initial\": \"%s\",\n  \"finals\": [%s],\n  \"states\": [%s],\n  \"transitions\": {%s}\n}"
      machine.Parser.name
      (String.concat ", " (List.map (fun s -> Printf.sprintf "\"%s\"" s) machine.Parser.alphabet))
      machine.Parser.blank
      machine.Parser.initial
      (String.concat ", " (List.map (fun s -> Printf.sprintf "\"%s\"" s) machine.Parser.finals))
      (String.concat ", " (List.map (fun s -> Printf.sprintf "\"%s\"" s) machine.Parser.states))
      (transitions_to_json machine.Parser.transitions)
  in
  let oc = open_out filename in
  output_string oc json_content;
  close_out oc



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
    print_endline "entering utm mode";
    print_endline("received args: " ^ (String.concat " " (Array.to_list args)));
    let machine_config_and_inputs = 
      String.concat " " (Array.to_list (Array.sub args 1 (Array.length args - 1))) 
    in
    let parts = String.split_on_char ';' machine_config_and_inputs in
    if List.length parts < 2 then
      (print_endline "Error: Invalid format"; None)
    else
      let machine_config = List.hd parts in
      let input_string_part = List.hd (List.tl parts) in

      print_endline ("Machine configuration part: " ^ machine_config);
      print_endline ("Input string part: " ^ input_string_part);
      let input_string = 
        try
          let input = String.split_on_char '=' input_string_part in
          if List.length input > 1 then 
            String.concat "=" (List.tl input)
          else
            (print_endline "Error: Missing '=' in input string."; "")
        with _ -> 
          (print_endline "Error: Invalid input format."; "")
      in
      let filename = "machines/utm.json" in
      print_endline "Writing machine configuration to file...";
      let machine = Parser.parse_machine_from_string machine_config in
      write_machine_to_json machine filename;
      print_endline ("Machine configuration written to: " ^ filename);
      print_endline ("Input: " ^ input_string);
      Some (filename, input_string)

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
    print_endline "STARTING PARSER...";
    (try
        let machine = Parser.parse_turing_machine filename in
        
        (* Validate the Turing machine *)
        (try
          Validator.validate_machine machine;
          print_endline "Machine validated successfully."
        with Failure msg ->
          Printf.printf "Validation Error: %s\n" msg;
          exit 1);

        print_machine machine;
        Tape.validate_tape_input input machine.alphabet machine.blank.[0];
        let tape_size = String.length input in
        let tape = Tape.parse_tape input tape_size machine.blank.[0] in
        print_endline "STARTING MACHINE...";
        Machine.launch tape machine;
      with Failure msg ->
        Printf.printf "Error: %s\n" msg; exit 1)
| None -> exit 1

