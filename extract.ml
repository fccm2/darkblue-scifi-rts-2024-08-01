let imgs = [
  "recieved/Screenshot 2024-07-04 09.42.02.png",
    "masks/Screenshot 2024-07-04 09.42.02.png",
    ["[x:173; y:124; w:54; h:33]"];
]

let crop_area s =
  Scanf.sscanf s "[x:%d; y:%d; w:%d; h:%d]" (fun x y w h -> (x, y, w, h))

let apply_mask img mask =
  Printf.sprintf
    "convert '%s' '%s' -alpha off -compose CopyOpacity -composite output.png"
    img mask

let crop_cmd (x, y, w, h) =
  Printf.sprintf
    "convert output.png -crop %dx%d+%d+%d +repage cropped.png"
    w h x y

let () =
  List.iter (fun (recieved, mask, crops) ->
    print_endline (apply_mask recieved mask);
    List.iter (fun crop ->
      print_endline (crop_cmd (crop_area crop))
    ) crops;
  ) imgs;
;;
