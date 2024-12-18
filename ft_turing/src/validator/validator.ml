open Parser

let validate_alphabet alphabet =
  if List.exists (fun s -> String.length s <> 1) alphabet then
    failwith "Error: All alphabet characters must be single characters."

let validate_blank blank alphabet =
  if String.length blank <> 1 then
    failwith "Error: Blank character must be a single character.";
  if not (List.mem blank alphabet) then
    failwith "Error: Blank character must be part of the alphabet."    

let validate_initial_state initial states =
  if not (List.mem initial states) then
    failwith "Error: Initial state must be part of the states list."

let validate_finals finals states =
  if not (List.for_all (fun s -> List.mem s states) finals) then
    failwith "Error: All final states must be part of the states list."

let validate_transitions transitions states alphabet =
  List.iter (fun (state, trans_list) ->
      if not (List.mem state states) then
        failwith ("Error: Undefined state in transitions: " ^ state);
      
      let seen_transitions = Hashtbl.create (List.length trans_list) in
      List.iter (fun t ->
          if not (List.mem t.read alphabet) then
            failwith ("Error: Undefined read character in transition: " ^ t.read);
          if not (List.mem t.write alphabet) then
            failwith ("Error: Undefined write character in transition: " ^ t.write);
          if not (List.mem t.to_state states) then
            failwith ("Error: Undefined state in transition: " ^ t.to_state);
          
          let key = (t.read, t.write, t.to_state, t.action) in
          if Hashtbl.mem seen_transitions key then
            failwith ("Error: Duplicate transition detected for state " ^ state ^
                      " with read = " ^ t.read);
          Hashtbl.add seen_transitions key true
        ) trans_list
    ) transitions

let validate_name name =
  if name = "" then
    failwith "Error: Machine name cannot be empty."

let validate_machine (machine : Parser.turing_machine) =
  validate_name machine.name;
  validate_alphabet machine.alphabet;
  validate_blank machine.blank machine.alphabet;
  validate_initial_state machine.initial machine.states;
  validate_finals machine.finals machine.states;
  validate_transitions machine.transitions machine.states machine.alphabet;