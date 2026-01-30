open! Core
open! Hardcaml
open Eth_mac

let generate_eth_mac_rtl () =
  let module C = Circuit.With_interface (I) (O) in
  let scope = Scope.create ~auto_label_hierarchical_ports:true () in
  let circuit = C.create_exn ~name:"eth_mac" (hierarchical scope) in
  let rtl_circuits =
    Rtl.create ~database:(Scope.circuit_database scope) Verilog [ circuit ]
  in
  let rtl = Rtl.full_hierarchy rtl_circuits |> Rope.to_string in
  print_endline rtl
;;

let () = generate_eth_mac_rtl ()
