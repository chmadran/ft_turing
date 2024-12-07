(** complexity.mli *)

(** Tracks the number of steps taken by the Turing machine.
    Appends the step count to a CSV file. *)
    val track_time : int -> unit

    (** Generates a plot of the logged complexity data.
        Outputs a PNG graph visualizing execution steps over input lengths. *)
    val plot_complexity : unit -> unit
    