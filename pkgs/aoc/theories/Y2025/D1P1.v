From Stdlib Require Import Arith.
From Stdlib Require Import Lists.List.

Import IfNotations.
Import ListNotations.


Inductive direction :=
  | L : direction
  | R : direction.

Record rotation := {
  dir  : direction;
  dist : nat
}.

Definition rotate pos rot :=
  match rot.(dir) with
  | L => (pos + 100 - (rot.(dist) mod 100)) mod 100
  | R => (pos + rot.(dist)) mod 100
  end.

Definition solve rotations :=
  let fix apply pos rots :=
    match rots with
    | [] => []
    | r :: rs =>
        let curr := rotate pos r in
        curr :: apply curr rs
    end
  in
  fold_left
    (fun acc pos => if pos =? 0 then acc + 1 else acc)
    (apply 50 rotations)
    0.
