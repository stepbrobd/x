- https://github.com/emillon/tree-sitter-dune
- https://dune.readthedocs.io/en/latest/advanced/ocaml-syntax.html
- https://github.com/ocaml/dune/blob/main/plugin/jbuild_plugin.mli

```dune
(* -*- tuareg -*- *)
let names =
  Sys.getcwd ()
  |> Sys.readdir
  |> Array.to_list
  |> List.filter (Sys.is_directory)

let () = Format.asprintf {|
(library
 (name blah)
 (libraries %a))
  |} Format.(pp_print_list ~pp_sep:pp_print_space pp_print_string) names
  |> Jbuild_plugin.V1.send
```
