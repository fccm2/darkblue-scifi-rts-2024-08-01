
let check_exists fn =
  if not (Sys.file_exists fn) then
    Printf.ksprintf failwith "file %s doesn't exist" fn;
;;

let imgs =
  let d = Sys.readdir "masks" in
  let sep = Filename.dir_sep in
  Array.fold_left (fun acc fn ->
    if Filename.check_suffix fn ".png"
    then begin
      let name = Filename.chop_suffix fn ".png" in
      let fn1 = Printf.sprintf "recieved%s%s.png" sep name in
      let fn2 = Printf.sprintf "masks%s%s.png" sep name in
      let fn3 = Printf.sprintf "masks%s%s.crops" sep name in
      let fn4 = Printf.sprintf "extracted%s%s" sep name in
      List.iter check_exists [fn1; fn2; fn3];
      (fn1, fn2, fn3, fn4) :: acc
    end
    else (acc)
  ) [] d
;;

let input_line_opt ic =
  try Some (input_line ic)
  with End_of_file -> close_in ic; None

let read_lines fn =
  let ic = open_in fn in
  let rec aux acc =
    match input_line_opt ic with
    | Some line -> aux (line::acc)
    | None -> (List.rev acc)
  in
  aux []

let suff i =
  char_of_int ((int_of_char 'b') + i)

let crop_area s =
  Scanf.sscanf s "[x:%d; y:%d; w:%d; h:%d]" (fun x y w h -> (x, y, w, h))

let apply_mask img mask =
  Printf.sprintf
    "convert '%s' '%s' -alpha off -compose CopyOpacity -composite output.png"
    img mask

let crop_cmd (x, y, w, h) fn i =
  Printf.sprintf
    "convert output.png -crop %dx%d+%d+%d +repage '%s%c.png'"
    w h x y fn (suff i)

let () =
  List.iter (fun (recieved, mask, crops, crop_f) ->
    print_endline (apply_mask recieved mask);
    List.iteri (fun i crop ->
      print_endline (crop_cmd (crop_area crop) crop_f i)
    ) (read_lines crops);
  ) imgs;
;;
