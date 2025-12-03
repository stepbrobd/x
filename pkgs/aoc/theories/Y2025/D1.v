From Stdlib Require Import Lists.List.

Import ListNotations.

Definition sum (input : list nat) : nat :=
  fold_left Nat.add input 0.

Compute sum [1; 2; 3; 4; 5].
