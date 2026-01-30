open! Core
open Hardcaml
open Signal

module I = struct
  type 'a t =
    { clock : 'a
    ; reset_n : 'a
    ; _crs_dv : 'a
    ; _rx_d : 'a [@bits 2]
    ; _rx_err : 'a
    }
  [@@deriving hardcaml]
end

module O = struct
  type 'a t =
    { phy_reset_n : 'a
    ; tx_en : 'a
    ; tx_d : 'a [@bits 2]
    ; clock_50MHz : 'a
    }
  [@@deriving hardcaml]
end

let create _scope ({ clock; reset_n; _crs_dv; _rx_d; _rx_err } : _ I.t) : _ O.t =
  let clocking_wizard_50MHz =
    Instantiation.create
      ~name:"clocking_wizard_50MHz"
      ~inputs:[ "clock_in", clock; "resetn", reset_n ]
      ~outputs:[ "clock_50MHz", 1 ]
      ()
  in
  let clock_50MHz = Instantiation.output clocking_wizard_50MHz "clock_50MHz" in
  { phy_reset_n = reset_n; tx_en = zero 1; tx_d = zero 2; clock_50MHz }
;;

let hierarchical scope =
  let module Scoped = Hierarchy.In_scope (I) (O) in
  Scoped.hierarchical ~scope ~name:"eth_mac_top" create
;;
