open Tape
open Parser

(** Helper to find the applicable transition for the current state and character *)
let find_transition transitions state char =
  match List.assoc_opt state transitions with
  | None -> None
  | Some trans_list ->
      List.find_opt (fun t -> t.read = String.make 1 char) trans_list

(** Execute a single step of the Turing machine *)
let step tape machine =
  let current_char = tape.data.[tape.head] in
  match find_transition machine.transitions machine.initial current_char with
  | None ->
      Printf.printf "No valid transition found for state: %s and character: %c\n"
        machine.initial current_char;
      None
  | Some transition ->
      (* Print transition details *)
      let left = String.sub tape.data 0 tape.head in
      let right =
        if tape.head + 1 < tape.size then
          String.sub tape.data (tape.head + 1) (tape.size - tape.head - 1)
        else
          ""
      in
      Printf.printf
        "Tape: [%s<%c>%s] (%s, %c) -> (%s, %c, %s)\n"
        left current_char right machine.initial current_char
        transition.to_state transition.write.[0]
        (match transition.action with Left -> "LEFT" | Right -> "RIGHT");

      (* Update the tape *)
      let updated_data = Bytes.of_string tape.data in
      Bytes.set updated_data tape.head transition.write.[0];
      let new_data = Bytes.to_string updated_data in

      (* Update the tape's head and sections *)
      let new_head, new_left, new_right =
        match transition.action with
        | Left ->
            let new_head = max 0 (tape.head - 1) in
            let new_left =
              if new_head > 0 then String.sub new_data 0 new_head else ""
            in
            let new_right =
              String.sub new_data new_head (String.length new_data - new_head)
            in
            (new_head, new_left, new_right)
        | Right ->
            let new_head = min (tape.size - 1) (tape.head + 1) in
            let new_left = String.sub new_data 0 new_head in
            let new_right =
              if new_head + 1 < String.length new_data then
                String.sub new_data (new_head + 1)
                  (String.length new_data - new_head - 1)
              else
                ""
            in
            (new_head, new_left, new_right)
      in

      (* Updated tape and machine state *)
      Some
        ({
           blank = tape.blank;
           data = new_data;
           left = new_left;
           right = new_right;
           head = new_head;
           size = tape.size;
         },
         { machine with initial = transition.to_state })

(** Main Turing machine launcher *)
let launch tape machine =
  let rec loop tape machine =
    if List.mem machine.initial machine.finals then
      Printf.printf "Machine reached a final state: %s\n" machine.initial
    else
      match step tape machine with
      | None ->
          Printf.printf "Machine stopped due to an invalid transition.\n"
      | Some (new_tape, new_machine) -> loop new_tape new_machine
  in
  (* Initial machine info *)
  Printf.printf
    "********************************************************************************\n\
     * *\n\
     * %s *\n\
     * *\n\
     ********************************************************************************\n"
    machine.name;
  Printf.printf "Alphabet: [ %s ]\n" (String.concat ", " machine.alphabet);
  Printf.printf "States: [ %s ]\n" (String.concat ", " machine.states);
  Printf.printf "Initial: %s\n" machine.initial;
  Printf.printf "Finals: [ %s ]\n" (String.concat ", " machine.finals);
  (* Print all transitions *)
  List.iter
    (fun (state, trans_list) ->
      List.iter
        (fun t ->
          Printf.printf "(%s, %s) -> (%s, %s, %s)\n" state t.read t.to_state
            t.write
            (match t.action with Left -> "LEFT" | Right -> "RIGHT"))
        trans_list)
    machine.transitions;
  Printf.printf
    "********************************************************************************\n";

  loop tape machine
