open Cairo

let plot_complexity () =
  let x = Array.init 100 (fun i -> float_of_int (i + 1)) in

  (* Define complexity functions *)
  let y_constant = Array.map (fun _ -> 1.) x in
  let y_log = Array.map (fun i -> log i) x in
  let y_linear = Array.map (fun i -> i) x in
  let y_nlogn = Array.map (fun i -> i *. log i) x in
  let y_quadratic = Array.map (fun i -> i ** 2.) x in
  let y_exponential = Array.map (fun i -> 2. ** i) x in
  let y_factorial = Array.map (fun i -> 
    float_of_int (List.fold_left ( * ) 1 (List.init (int_of_float i) (fun j -> j + 1)))) x in

  (* Create a new PNG file for output *)
  let surface = Cairo_png.create "complexity_plot.png" 800 600 in
  let context = Cairo.create surface in

  (* Set up the plot style *)
  Cairo.set_line_width context 2.0;
  Cairo.set_source_rgb context 0.0 0.0 0.0; (* Black color for text *)

  (* Title and axis labels *)
  Cairo.move_to context 100.0 30.0;
  Cairo.show_text context "Big-O Complexity";
  
  Cairo.move_to context 100.0 570.0;
  Cairo.show_text context "Input Length";

  Cairo.move_to context 10.0 100.0;
  Cairo.show_text context "Operations";

  (* Draw the complexity functions *)
  let plot_curve color x_data y_data =
    Cairo.set_source_rgb context color.(0) color.(1) color.(2);
    Cairo.move_to context 100.0 500.0;  (* Move to start point *)
    Array.iteri (fun i xi ->
      let yi = y_data.(i) in
      let x_pos = 100.0 +. (float_of_int i *. 7.0) in  (* Scale x-axis *)
      let y_pos = 500.0 -. (yi *. 20.0) in  (* Scale y-axis *)
      if i = 0 then
        Cairo.move_to context x_pos y_pos
      else
        Cairo.line_to context x_pos y_pos
    ) x_data;
    Cairo.stroke context;
  in

  (* Call plot_curve for each complexity function *)
  plot_curve [|1.0; 0.0; 0.0|] x y_constant; (* Red for constant *)
  plot_curve [|0.0; 1.0; 0.0|] x y_log;     (* Green for log *)
  plot_curve [|0.0; 0.0; 1.0|] x y_linear;  (* Blue for linear *)
  plot_curve [|1.0; 0.65; 0.0|] x y_nlogn;  (* Orange for nlogn *)
  plot_curve [|0.5; 0.0; 0.5|] x y_quadratic; (* Purple for quadratic *)
  plot_curve [|1.0; 0.75; 0.8|] x y_exponential; (* Pink for exponential *)
  plot_curve [|0.0; 0.0; 0.0|] x y_factorial; (* Black for factorial *)

  (* Save the plot to a PNG file *)
  Cairo.show_page context;
  Cairo.Surface.finish surface;
  Printf.printf "Plot saved to 'complexity_plot.png'\n"
