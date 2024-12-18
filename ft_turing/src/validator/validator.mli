
(** Validate a Turing machine.
    @param machine The Turing machine to validate.
    @return [true] if the machine is valid.
    @raise Failure with an error message if the machine is invalid. *)
val validate_machine : Parser.turing_machine -> unit
