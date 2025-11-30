open Yocaml

let () =
  (* config *)
  let www = Path.rel [ "_build"; "www" ] in
  let cache = Path.rel [ "_build"; "cache" ] in
  (* source *)
  let pages = Path.rel [ "pages" ] in
  let assets = Path.rel [ "assets" ] in
  let static = Path.(assets / "static") in
  let layout = Path.(assets / "layout") in
  let style = Path.(assets / "style") in
  (* helper *)
  let with_ext exts path = List.exists (fun ext -> Path.has_extension ext path) exts in
  let track_binary =
    Sys.executable_name |> Yocaml.Path.from_string |> Pipeline.track_file
  in
  (* action *)
  let tailwind =
    Action.exec_cmd
      (fun target ->
         Cmd.make
           "tailwindcss"
           [ Cmd.flag "minify"
           ; Cmd.param "input" (Cmd.w Path.(style / "tailwind.css"))
           ; Cmd.param "output" target
           ])
      Path.(www / "assets" / "style" / "tailwind.css")
  in
  let generate source =
    let page_path =
      match Path.basename source with
      | None -> Path.(www / "index.html")
      | Some basename ->
        let name = Filename.remove_extension basename in
        if name = "home"
        then Path.(www / "index.html")
        else Path.(www / name / "index.html")
    in
    let pipeline =
      let open Task in
      track_binary
      >>> Yocaml_yaml.Pipeline.read_file_with_metadata (module Archetype.Page) source
      >>> Yocaml_markdown.Pipeline.With_metadata.make ()
      >>> Yocaml_liquid.Pipeline.as_template
            (module Archetype.Page)
            Path.(layout / "main.liquid")
      |> Task.map snd
    in
    Action.Static.write_file page_path pipeline
  in
  let generate =
    let where = with_ext [ "md" ] in
    Action.batch ~only:`Files ~where pages generate
  in
  (* entry *)
  Yocaml_unix.run ~level:`Debug (fun () ->
    let open Eff in
    Action.restore_cache cache
    >>= Action.copy_file ~into:www Path.(static / "geofeed.csv")
    >>= Action.copy_file ~into:www Path.(static / "img" / "favicon.ico")
    >>= Action.copy_directory ~into:Path.(www / "assets") static
    >>= tailwind
    >>= generate
    >>= Action.store_cache cache)
;;
