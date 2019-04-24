{-# OPTIONS --without-K #-}

module 05-identity-types where

import 04-relations
open 04-relations public

data Id {i : Level} {A : UU i} (x : A) : A → UU i where
  refl : Id x x

ind-Id :
  {i j : Level} {A : UU i} (x : A) (B : (y : A) (p : Id x y) → UU j) →
  (B x refl) → (y : A) (p : Id x y) → B y p
ind-Id x B b y refl = b

inv :
  {i : Level} {A : UU i} {x y : A} → Id x y → Id y x
inv refl = refl

concat :
  {i : Level} {A : UU i} {x : A} (y : A) {z : A} →
  Id x y → Id y z → Id x z
concat x refl q = q

_∙_ :
  {i : Level} {A : UU i} {x y z : A} → Id x y → Id y z → Id x z
_∙_ {y = y} = concat y

{- This goes in the wrong direction! -}
assoc :
  {i : Level} {A : UU i} {x y z w : A} (p : Id x y) (q : Id y z)
  (r : Id z w) → Id (p ∙ (q ∙ r)) ((p ∙ q) ∙ r)
assoc refl q r = refl

left-unit :
  {i : Level} {A : UU i} {x y : A} (p : Id x y) → Id (refl ∙ p) p
left-unit p = refl

right-unit :
  {i : Level} {A : UU i} {x y : A} (p : Id x y) → Id (p ∙ refl) p
right-unit refl = refl

left-inv :
  {i : Level} {A : UU i} {x y : A} (p : Id x y) →
  Id ((inv p) ∙ p) refl
left-inv refl = refl

right-inv :
  {i : Level} {A : UU i} {x y : A} (p : Id x y) →
  Id (p ∙ (inv p)) refl
right-inv refl = refl

ap :
  {i j : Level} {A : UU i} {B : UU j} (f : A → B) {x y : A} (p : Id x y) →
  Id (f x) (f y)
ap f refl = refl

ap-id :
  {i : Level} {A : UU i} {x y : A} (p : Id x y) → Id (ap id p) p
ap-id refl = refl

ap-comp :
  {i j k : Level} {A : UU i} {B : UU j} {C : UU k} (g : B → C)
  (f : A → B) {x y : A} (p : Id x y) → Id (ap (g ∘ f) p) (ap g (ap f p))
ap-comp g f refl = refl

ap-refl :
  {i j : Level} {A : UU i} {B : UU j} (f : A → B) (x : A) →
  Id (ap f (refl {_} {_} {x})) refl
ap-refl f x = refl

ap-concat :
  {i j : Level} {A : UU i} {B : UU j} (f : A → B) {x y z : A}
  (p : Id x y) (q : Id y z) → Id (ap f (p ∙ q)) ((ap f p) ∙ (ap f q))
ap-concat f refl q = refl

ap-inv :
  {i j : Level} {A : UU i} {B : UU j} (f : A → B) {x y : A}
  (p : Id x y) → Id (ap f (inv p)) (inv (ap f p))
ap-inv f refl = refl

tr :
  {i j : Level} {A : UU i} (B : A → UU j) {x y : A} (p : Id x y) → B x → B y
tr B refl b = b

apd :
  {i j : Level} {A : UU i} {B : A → UU j} (f : (x : A) → B x) {x y : A}
  (p : Id x y) → Id (tr B p (f x)) (f y)
apd f refl = refl

path-over :
  {i j : Level} {A :  UU i} (B : A → UU j) {x x' : A} (p : Id x x') →
  B x → B x' → UU j
path-over B p y y' = Id (tr B p y) y'

reflexive-path-over :
  {i j : Level} {A : UU i} (B : A → UU j) (x : A) (y : B x) →
  path-over B refl y y
reflexive-path-over B x y = refl

-- Exercises

-- Exercise 4.1
tr-concat :
  {i j : Level} {A : UU i} {B : A → UU j} {x y : A} (p : Id x y)
  {z : A} (q : Id y z) (b : B x) → Id (tr B q (tr B p b)) (tr B (p ∙ q) b)
tr-concat refl q b = refl

-- Exercise 4.2
inv-assoc :
  {i : Level} {A : UU i} {x y : A} (p : Id x y) {z : A}
  (q : Id y z) → Id (inv (p ∙ q)) ((inv q) ∙ (inv p))
inv-assoc refl refl = refl

-- Exercise 4.3
tr-triv :
  {i j : Level} {A : UU i} {B : UU j} {x y : A} (p : Id x y) (b : B) →
  Id (tr (λ (a : A) → B) p b) b
tr-triv refl b = refl

apd-triv :
  {i j : Level} {A : UU i} {B : UU j} (f : A → B) {x y : A}
  (p : Id x y) → Id (apd f p) ((tr-triv p (f x)) ∙ (ap f p))
apd-triv f refl = refl

-- Exercise 4.4
tr-id-left-subst :
  {i j : Level} {A : UU i} {B : UU j} {f : A → B} {x y : A}
  (p : Id x y) (b : B) → (q : Id (f x) b) →
  Id (tr (λ (a : A) → Id (f a) b) p q) ((inv (ap f p)) ∙ q)
tr-id-left-subst refl b q = refl

tr-id-right-subst :
  {i j : Level} {A : UU i} {B : UU j} {f : A → B} {x y : A}
  (p : Id x y) (b : B) → (q : Id b (f x)) →
  Id (tr (λ (a : A) → Id b (f a)) p q) (q ∙ (ap f p))
tr-id-right-subst refl b q = inv (right-unit q)

-- Exercise 4.5
inv-con :
  {i : Level} {A : UU i} {x y : A} (p : Id x y) {z : A} (q : Id y z)
  (r : Id x z) → (Id (p ∙ q) r) → Id q ((inv p) ∙ r)
inv-con refl q r = id 

con-inv :
  {i : Level} {A : UU i} {x y : A} (p : Id x y) {z : A} (q : Id y z)
  (r : Id x z) → (Id (p ∙ q) r) → Id p (r ∙ (inv q))
con-inv p refl r =
  ( λ α → α ∙ (inv (right-unit r))) ∘ (concat (p ∙ refl) (inv (right-unit p)))

-- Exercise 4.6
lift :
  {i j : Level} {A : UU i} {B : A → UU j} {x y : A} (p : Id x y)
  (b : B x) → Id (pair x b) (pair y (tr B p b))
lift refl b = refl

-- Exercise 4.7
pentagon :
  {i : Level} {A : UU i} {a b c d e : A}
  (p : Id a b) (q : Id b c) (r : Id c d) (s : Id d e) →
  let α₁ = inv (ap (λ t → t ∙ s) (assoc p q r))
      α₂ = inv (assoc p (q ∙ r) s)
      α₃ = inv (ap (λ t → p ∙ t) (assoc q r s))
      α₄ = inv (assoc (p ∙ q) r s)
      α₅ = inv (assoc p q (r ∙ s))
  in
  Id ((α₁ ∙ α₂) ∙ α₃) (α₄ ∙ α₅)
pentagon refl refl refl refl = refl

-- Exercise 4.8

abstract
  associative-add-ℕ :
    (x y z : ℕ) → Id (add-ℕ (add-ℕ x y) z) (add-ℕ x (add-ℕ y z))
  associative-add-ℕ zero-ℕ y z = refl 
  associative-add-ℕ (succ-ℕ x) y z = ap succ-ℕ (associative-add-ℕ x y z)

abstract
  right-unit-law-add-ℕ :
    (x : ℕ) → Id (add-ℕ x zero-ℕ) x
  right-unit-law-add-ℕ zero-ℕ = refl
  right-unit-law-add-ℕ (succ-ℕ x) = ap succ-ℕ (right-unit-law-add-ℕ x)
  
  left-unit-law-add-ℕ :
    (x : ℕ) → Id (add-ℕ zero-ℕ x) x
  left-unit-law-add-ℕ x = refl
  
  left-successor-law-add-ℕ :
    (x y : ℕ) → Id (add-ℕ (succ-ℕ x) y) (succ-ℕ (add-ℕ x y))
  left-successor-law-add-ℕ x y = refl
  
  right-successor-law-add-ℕ :
    (x y : ℕ) → Id (add-ℕ x (succ-ℕ y)) (succ-ℕ (add-ℕ x y))
  right-successor-law-add-ℕ zero-ℕ y = refl
  right-successor-law-add-ℕ (succ-ℕ x) y =
    ap succ-ℕ (right-successor-law-add-ℕ x y)

abstract
  commutative-add-ℕ :
    (x y : ℕ) → Id (add-ℕ x y) (add-ℕ y x)
  commutative-add-ℕ zero-ℕ y = inv (right-unit-law-add-ℕ y)
  commutative-add-ℕ (succ-ℕ x) y =
    (ap succ-ℕ (commutative-add-ℕ x y)) ∙ (inv (right-successor-law-add-ℕ y x))

abstract
  right-unit-law-mul-ℕ :
    (x : ℕ) → Id (mul-ℕ x one-ℕ) x
  right-unit-law-mul-ℕ zero-ℕ = refl
  right-unit-law-mul-ℕ (succ-ℕ x) =
    concat _
      ( right-successor-law-add-ℕ (mul-ℕ x one-ℕ) zero-ℕ)
      ( ap succ-ℕ (concat _ (right-unit-law-add-ℕ _) (right-unit-law-mul-ℕ x)))
  
  left-unit-law-mul-ℕ :
    (x : ℕ) → Id (mul-ℕ one-ℕ x) x
  left-unit-law-mul-ℕ x = refl

abstract
  left-successor-law-mul-ℕ :
    (x y : ℕ) → Id (mul-ℕ (succ-ℕ x) y) (add-ℕ (mul-ℕ x y) y)
  left-successor-law-mul-ℕ x y = refl

abstract
  right-successor-law-mul-ℕ :
    (x y : ℕ) → Id (mul-ℕ x (succ-ℕ y)) (add-ℕ x (mul-ℕ x y))
  right-successor-law-mul-ℕ zero-ℕ y = refl
  right-successor-law-mul-ℕ (succ-ℕ x) y =
    concat (succ-ℕ (add-ℕ (mul-ℕ x (succ-ℕ y)) y))
      ( right-successor-law-add-ℕ (mul-ℕ x (succ-ℕ y)) y)
      ( concat (succ-ℕ (add-ℕ (add-ℕ x (mul-ℕ x y)) y))
        ( ap (λ t → succ-ℕ (add-ℕ t y)) (right-successor-law-mul-ℕ x y))
        ( ap succ-ℕ (associative-add-ℕ x (mul-ℕ x y) y)))

abstract
  left-distributive-mul-add-ℕ :
    (x y z : ℕ) → Id (mul-ℕ x (add-ℕ y z)) (add-ℕ (mul-ℕ x y) (mul-ℕ x z))
  left-distributive-mul-add-ℕ zero-ℕ y z = refl
  left-distributive-mul-add-ℕ (succ-ℕ x) y z =
    concat _
      ( left-successor-law-mul-ℕ x (add-ℕ y z))
      ( concat _
        ( ap (λ t → add-ℕ t (add-ℕ y z)) (left-distributive-mul-add-ℕ x y z))
        ( concat (add-ℕ (mul-ℕ x y) (add-ℕ (mul-ℕ x z) (add-ℕ y z)))
          ( associative-add-ℕ (mul-ℕ x y) (mul-ℕ x z) (add-ℕ y z))
          ( concat _
            ( ap (add-ℕ (mul-ℕ x y)) (concat _
              ( inv (associative-add-ℕ (mul-ℕ x z) y z))
              ( concat _
                ( ap (λ t → add-ℕ t z) (commutative-add-ℕ (mul-ℕ x z) y))
                ( associative-add-ℕ y (mul-ℕ x z) z))))
            ( inv (associative-add-ℕ (mul-ℕ x y) y (add-ℕ (mul-ℕ x z) z))))))

abstract
  left-zero-law-mul-ℕ :
    (x : ℕ) → Id (mul-ℕ zero-ℕ x) zero-ℕ
  left-zero-law-mul-ℕ x = refl

abstract
  right-zero-law-mul-ℕ :
    (x : ℕ) → Id (mul-ℕ x zero-ℕ) zero-ℕ
  right-zero-law-mul-ℕ zero-ℕ = refl
  right-zero-law-mul-ℕ (succ-ℕ x) =
    ( right-unit-law-add-ℕ (mul-ℕ x zero-ℕ)) ∙ (right-zero-law-mul-ℕ x)

abstract
  commutative-mul-ℕ :
    (x y : ℕ) → Id (mul-ℕ x y) (mul-ℕ y x)
  commutative-mul-ℕ zero-ℕ y = inv (right-zero-law-mul-ℕ y)
  commutative-mul-ℕ (succ-ℕ x) y =
    concat _
      ( commutative-add-ℕ (mul-ℕ x y) y)
      ( concat _
        ( ap (add-ℕ y) (commutative-mul-ℕ x y))
        ( inv (right-successor-law-mul-ℕ y x)))

abstract
  right-distributive-mul-add-ℕ :
    (x y z : ℕ) → Id (mul-ℕ (add-ℕ x y) z) (add-ℕ (mul-ℕ x z) (mul-ℕ y z))
  right-distributive-mul-add-ℕ x y z =
    concat _
      ( commutative-mul-ℕ (add-ℕ x y) z)
      ( concat _
        ( left-distributive-mul-add-ℕ z x y)
        ( concat _
          ( ap (λ t → add-ℕ t (mul-ℕ z y)) (commutative-mul-ℕ z x))
          ( ap (λ t → add-ℕ (mul-ℕ x z) t) (commutative-mul-ℕ z y))))

abstract
  associative-mul-ℕ :
    (x y z : ℕ) → Id (mul-ℕ (mul-ℕ x y) z) (mul-ℕ x (mul-ℕ y z))
  associative-mul-ℕ zero-ℕ y z = refl
  associative-mul-ℕ (succ-ℕ x) y z =
    concat _
      ( right-distributive-mul-add-ℕ (mul-ℕ x y) y z)
      ( ap (λ t → add-ℕ t (mul-ℕ y z)) (associative-mul-ℕ x y z))

-- Exercise 4.9

two-ℕ : ℕ
two-ℕ = succ-ℕ one-ℕ

is-even-ℕ : ℕ → UU lzero
is-even-ℕ n = Σ ℕ (λ m → Id (mul-ℕ two-ℕ m) n)

div-ℕ : ℕ → ℕ → UU lzero
div-ℕ m n = Σ ℕ (λ k → Id (mul-ℕ k m) n)

is-prime : ℕ → UU lzero
is-prime n = (one-ℕ < n) × ((m : ℕ) → (one-ℕ < m) → (div-ℕ m n) → Id m n)

Goldbach-conjecture : UU lzero
Goldbach-conjecture =
  ( n : ℕ) → (two-ℕ < n) → (is-even-ℕ n) →
    Σ ℕ (λ p → (is-prime p) × (Σ ℕ (λ q → (is-prime q) × Id (add-ℕ p q) n)))