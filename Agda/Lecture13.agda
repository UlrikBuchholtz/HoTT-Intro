{-# OPTIONS --without-K --allow-unsolved-metas #-}

module Lecture13 where

import Lecture12
open Lecture12 public

-- Section 13.1

cocone : {l1 l2 l3 l4 : Level} {S : UU l1} {A : UU l2} {B : UU l3}
  (f : S → A) (g : S → B) → UU l4 → UU _
cocone {A = A} {B = B} f g X =
  Σ (A → X) (λ i → Σ (B → X) (λ j → (i ∘ f) ~ (j ∘ g)))

generating-data-pushout : 
  {l1 l2 l3 l4 l5 : Level} {S : UU l1} {A : UU l2} {B : UU l3}
  (f : S → A) (g : S → B) {X : UU l4} (c : cocone f g X) (P : X → UU l5) →
  UU (l1 ⊔ (l2 ⊔ (l3 ⊔ l5)))
generating-data-pushout {S = S} {A} {B} f g c P =
  Σ ( (a : A) → P (pr1 c a))
    ( λ φ → Σ ( (b : B) → P (pr1 (pr2 c) b))
      ( λ ψ → (s : S) → Id (tr P (pr2 (pr2 c) s) (φ (f s))) (ψ (g s))))

dgen-pushout : {l1 l2 l3 l4 l5 : Level} {S : UU l1} {A : UU l2} {B : UU l3}
  (f : S → A) (g : S → B) {X : UU l4} (c : cocone f g X) {P : X → UU l5} →
  ((x : X) → P x) → generating-data-pushout f g c P
dgen-pushout f g (dpair i (dpair j H)) α =
  dpair
    ( λ a → α (i a))
    ( dpair
      ( λ b → α (j b))
      ( λ s → apd α (H s)))

Ind-pushout : {l1 l2 l3 l4 : Level} {S : UU l1} {A : UU l2} {B : UU l3}
  (f : S → A) (g : S → B) {X : UU l4} (c : cocone f g X) (l5 : Level) → UU _
Ind-pushout f g {X} c l5 = (P : X → UU l5) → sec (dgen-pushout f g c {P})

PUSHOUT : {l1 l2 l3 : Level} {S : UU l1} {A : UU l2} {B : UU l3}
  (f : S → A) (g : S → B) → UU _
PUSHOUT {l1} {l2} {l3} f g =
  Σ ( UU (l1 ⊔ (l2 ⊔ l3)))
    ( λ X → Σ (cocone f g X)
      ( λ c → Ind-pushout f g c (lsuc (l1 ⊔ (l2 ⊔ l3)))))

-- Section 13.3

-- We first give several different conditions that are equivalent to the
-- universal property of pushouts.

cocone-map : {l1 l2 l3 l4 l5 : Level} {S : UU l1} {A : UU l2} {B : UU l3}
  (f : S → A) (g : S → B) {X : UU l4} {Y : UU l5} →
  cocone f g X → (X → Y) → cocone f g Y
cocone-map f g (dpair i (dpair j H)) h =
  dpair (h ∘ i) (dpair (h ∘ j) (h ·l H))

universal-property-pushout : {l1 l2 l3 l4 : Level} {S : UU l1} {A : UU l2}
  {B : UU l3} (f : S → A) (g : S → B) {X : UU l4} →
  cocone f g X → {l5 : Level} (Y : UU l5) → UU _
universal-property-pushout f g c Y = is-equiv (cocone-map f g {Y = Y} c)

cone-pullback-property-pushout : {l1 l2 l3 l4 : Level} {S : UU l1} {A : UU l2}
  {B : UU l3} (f : S → A) (g : S → B) {X : UU l4} (c : cocone f g X) →
  {l : Level} (Y : UU l) →
  cone (λ (h : A → Y) → h ∘ f) (λ (h : B → Y) → h ∘ g) (X → Y)
cone-pullback-property-pushout f g {X} (dpair i (dpair j H)) Y =
  dpair
    ( λ (h : X → Y) → h ∘ i)
    ( dpair
      ( λ (h : X → Y) → h ∘ j)
      ( λ h → eq-htpy (h ·l H)))

pullback-property-pushout : {l1 l2 l3 l4 : Level} {S : UU l1} {A : UU l2}
  {B : UU l3} (f : S → A) (g : S → B) {X : UU l4} (c : cocone f g X) →
  {l : Level} (Y : UU l) → UU (l1 ⊔ (l2 ⊔ (l3 ⊔ (l4 ⊔ l))))
pullback-property-pushout {l1} {l2} {l3} {l4} {S} {A} {B} f g {X} c {l} Y =
  is-pullback
    ( λ (h : A → Y) → h ∘ f)
    ( λ (h : B → Y) → h ∘ g)
    ( cone-pullback-property-pushout f g c Y)

dependent-universal-property-pushout : {l1 l2 l3 l4 : Level}
  {S : UU l1} {A : UU l2} {B : UU l3}
  (f : S → A) (g : S → B) {X : UU l4} (c : cocone f g X)
  (l : Level) → UU _
dependent-universal-property-pushout f g {X} c l =
  (P : X → UU l) → is-equiv (dgen-pushout f g c {P})

dependent-pullback-property-pushout : {l1 l2 l3 l4 : Level}
  {S : UU l1} {A : UU l2} {B : UU l3} (f : S → A) (g : S → B)
  {X : UU l4} (c : cocone f g X) {l : Level} (P : X → UU l) →
  UU (l1 ⊔ (l2 ⊔ (l3 ⊔ (l4 ⊔ l))))
dependent-pullback-property-pushout {l1} {l2} {l3} {l4} {S} {A} {B} f g {X}
  (dpair i (dpair j H)) {l} P =
  is-pullback
    ( λ (h : (a : A) → P (i a)) → λ s → tr P (H s) (h (f s)))
    ( λ (h : (b : B) → P (j b)) → λ s → h (g s))
    ( dpair
      ( λ (h : (x : X) → P x) → λ a → h (i a))
      ( dpair
        ( λ (h : (x : X) → P x) → λ b → h (j b))
        ( λ h → eq-htpy (λ s → apd h (H s)))))

triangle-pullback-property-pushout-universal-property-pushout :
  {l1 l2 l3 l4 : Level} {S : UU l1} {A : UU l2}
  {B : UU l3} (f : S → A) (g : S → B) {X : UU l4} (c : cocone f g X) →
  {l : Level} (Y : UU l) →
  ( cocone-map f g c) ~
  ( ( tot (λ i' → tot (λ j' p → htpy-eq p))) ∘
    ( gap (λ h → h ∘ f) (λ h → h ∘ g) (cone-pullback-property-pushout f g c Y)))
triangle-pullback-property-pushout-universal-property-pushout
  {S = S} {A = A} {B = B} f g (dpair i (dpair j H)) Y h =
    eq-pair
      ( dpair refl (eq-pair (dpair refl (inv (issec-eq-htpy (h ·l H))))))

pullback-property-pushout-universal-property-pushout :
  {l1 l2 l3 l4 : Level} {S : UU l1} {A : UU l2}
  {B : UU l3} (f : S → A) (g : S → B) {X : UU l4} (c : cocone f g X) →
  {l : Level} (Y : UU l) →
  universal-property-pushout f g c Y → pullback-property-pushout f g c Y
pullback-property-pushout-universal-property-pushout
  f g (dpair i (dpair j H)) Y up-c =
  let c = (dpair i (dpair j H)) in
  is-equiv-right-factor
    ( cocone-map f g c)
    ( tot (λ i' → tot (λ j' p → htpy-eq p)))
    ( gap (λ h → h ∘ f) (λ h → h ∘ g) (cone-pullback-property-pushout f g c Y))
    ( triangle-pullback-property-pushout-universal-property-pushout f g c Y)
    ( is-equiv-tot-is-fiberwise-equiv
      ( λ i' → is-equiv-tot-is-fiberwise-equiv
        ( λ j' → funext (i' ∘ f) (j' ∘ g))))
    ( up-c)

universal-property-pushout-pullback-property-pushout :
  {l1 l2 l3 l4 : Level} {S : UU l1} {A : UU l2}
  {B : UU l3} (f : S → A) (g : S → B) {X : UU l4} (c : cocone f g X) →
  {l : Level} (Y : UU l) →
  pullback-property-pushout f g c Y → universal-property-pushout f g c Y
universal-property-pushout-pullback-property-pushout
  f g (dpair i (dpair j H)) Y pb-c =
  let c = (dpair i (dpair j H)) in
  is-equiv-comp
    ( cocone-map f g c)
    ( tot (λ i' → tot (λ j' p → htpy-eq p)))
    ( gap (λ h → h ∘ f) (λ h → h ∘ g) (cone-pullback-property-pushout f g c Y))
    ( triangle-pullback-property-pushout-universal-property-pushout f g c Y)
    ( pb-c)
    ( is-equiv-tot-is-fiberwise-equiv
      ( λ i' → is-equiv-tot-is-fiberwise-equiv
        ( λ j' → funext (i' ∘ f) (j' ∘ g))))

Eq-generating-data-pushout :
  {l1 l2 l3 l4 l5 : Level} {S : UU l1} {A : UU l2} {B : UU l3}
  (f : S → A) (g : S → B) {X : UU l4} (c : cocone f g X) (P : X → UU l5) →
  (s t : generating-data-pushout f g c P) → UU (l1 ⊔ (l2 ⊔ (l3 ⊔ l5)))
Eq-generating-data-pushout {S = S} f g (dpair i (dpair j H)) P
  (dpair hA (dpair hB hS)) (dpair kA (dpair kB kS)) =
  Σ ( hA ~ kA)
    ( λ K →
    Σ ( hB ~ kB)
      ( λ L →
      (s : S) → Id ((hS s) ∙ (L (g s))) ((ap (tr P (H s)) (K (f s))) ∙ (kS s))))

reflexive-Eq-generating-data-pushout :
  {l1 l2 l3 l4 l5 : Level} {S : UU l1} {A : UU l2} {B : UU l3}
  (f : S → A) (g : S → B) {X : UU l4} (c : cocone f g X) (P : X → UU l5) →
  (s : generating-data-pushout f g c P) →
  Eq-generating-data-pushout f g c P s s
reflexive-Eq-generating-data-pushout f g (dpair i (dpair j H)) P
  (dpair hA (dpair hB hS)) =
  dpair
    ( htpy-refl hA)
    ( dpair
      ( htpy-refl hB)
      ( htpy-right-unit hS))

Eq-generating-data-pushout-eq :
  {l1 l2 l3 l4 l5 : Level} {S : UU l1} {A : UU l2} {B : UU l3}
  (f : S → A) (g : S → B) {X : UU l4} (c : cocone f g X) (P : X → UU l5) →
  (s t : generating-data-pushout f g c P) →
  Id s t → Eq-generating-data-pushout f g c P s t
Eq-generating-data-pushout-eq f g c P s .s refl =
  reflexive-Eq-generating-data-pushout f g c P s

dependent-naturality-square : {l1 l2 : Level} {A : UU l1} {B : A → UU l2}
  (f f' : (x : A) → B x)
  {x x' : A} (p : Id x x') (q : Id (f x) (f' x)) (q' : Id (f x') (f' x')) →
  Id ((apd f p) ∙ q') ((ap (tr B p) q) ∙ (apd f' p)) →
  Id (tr (λ y → Id (f y) (f' y)) p q) q' 
dependent-naturality-square f f' refl q q' s =
  inv (s ∙ ((right-unit (ap id q)) ∙ (ap-id q)))

htpy-eq-dgen-pushout :
  {l1 l2 l3 l4 : Level} {S : UU l1} {A : UU l2} {B : UU l3}
  (f : S → A) (g : S → B) {X : UU l4} (c : cocone f g X) →
  ( H : (l : Level) → Ind-pushout f g c l) →
  {l : Level} {P : X → UU l} (h h' : (x : X) → P x) →
  Id (dgen-pushout f g c h) (dgen-pushout f g c h') → h ~ h'
htpy-eq-dgen-pushout f g (dpair i (dpair j H)) I {l} {P} h h' p =
  let c = (dpair i (dpair j H))
      K = pr1 (Eq-generating-data-pushout-eq f g c P _ _ p)
      L = pr1 (pr2 (Eq-generating-data-pushout-eq f g c P _ _ p))
      M = pr2 (pr2 (Eq-generating-data-pushout-eq f g c P _ _ p))
  in
  pr1 (I _ (λ x → Id (h x) (h' x)))
    ( dpair
      ( K)
      ( dpair
        ( L)
        ( λ s →
          dependent-naturality-square h h' (H s) (K (f s)) (L (g s)) (M s))))

dependent-universal-property-pushout-Ind-pushout :
  {l1 l2 l3 l4 : Level} {S : UU l1} {A : UU l2} {B : UU l3}
  (f : S → A) (g : S → B) {X : UU l4} (c : cocone f g X) →
  ((l : Level) → Ind-pushout f g c l) →
  ((l : Level) → dependent-universal-property-pushout f g c l)
dependent-universal-property-pushout-Ind-pushout f g c H l P =
  let ind-pushout  = pr1 (H l P)
      comp-pushout = pr2 (H l P)
  in
  is-equiv-has-inverse
    ( dpair
      ( ind-pushout)
      ( dpair
        ( comp-pushout)
        ( λ h → eq-htpy (htpy-eq-dgen-pushout f g c H
          ( ind-pushout (dgen-pushout f g c h))
          ( h)
          ( pr2 (H l P) (dgen-pushout f g c h))))))