open! Core
open Hardcaml
open Signal

module I = struct
  type 'a t =
    { _clock_50MHz : 'a
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
    }
  [@@deriving hardcaml]
end

let create _scope ({ _clock_50MHz; reset_n; _crs_dv; _rx_d; _rx_err } : _ I.t) : _ O.t =
  { phy_reset_n = reset_n; tx_en = zero 1; tx_d = zero 2 }
;;

let hierarchical scope =
  let module Scoped = Hierarchy.In_scope (I) (O) in
  Scoped.hierarchical ~scope ~name:"eth_mac" create
;;
