(******************************)
(*** For debugging purposes ***)
(******************************)

(* print out an integer list *)
let rec print_int_list lst =
  match lst with
  | [] -> ()
  | [x] -> print_int x; print_newline ()
  | x :: xs -> print_int x; print_string "; "; print_int_list xs

(* print out a string list *)
let rec print_string_list lst =
  match lst with
  | [] -> ()
  | [x] -> print_string x; print_newline ()
  | x :: xs -> print_string x; print_string "; "; print_string_list xs


(********************)
(* Problem 1: pow *)
(********************)

let rec pow x p =
  if p = 0 then 1
  else x * pow x (p-1)

(********************)
(* Problem 2: range *)
(********************)

let rec range num1 num2 =
  if num1 > num2 then []
  else num1 :: range (num1 +1) num2

(**********************)
(* Problem 3: flatten *)
(**********************)

let rec flatten l =
  match l with
  | [] -> []
  | x :: xs -> x @ flatten xs

(*****************************)
(* Problem 4: remove_stutter *)
(*****************************)

let rec remove_stutter l =
  match l with 
  | [] -> []
  | [x] -> [x]
  | x :: y :: xs -> if x = y then remove_stutter (y :: xs) else x :: remove_stutter (y :: xs)

(*********************)
(* Problem 5: rotate *)
(*********************)

let rotate l n =
  let len = List.length l in
  let n = if len = 0 then 0 else (n mod len + len) mod len in
  let rec split lst i =
    match lst with
    | [] -> ([], [])
    | x :: xs when i > 0 ->
        let (first, second) = split xs (i - 1) in
        (x :: first, second)
    | _ -> ([], lst)
  in
  let first, second = split l (len - n) in
  second @ first

(*******************)
(* Problem 6: jump *)
(*******************)

let jump lst1 lst2 =
  let rec aux l1 l2 i acc =
    match (l1, l2) with
    | (h1::t1, h2::t2) ->
      if i mod 2 = 0 then aux t1 l2 (i + 1) (h1 :: acc) 
      else aux l1 t2 (i + 1) (h2 :: acc)
    | ([], h2::t2) -> aux [] t2 (i + 1) (h2 :: acc)
    | (h1::t1, []) -> aux t1 [] (i + 1) (h1 :: acc)
    | ([], []) -> List.rev acc
  in aux lst1 lst2 0 []


(******************)
(* Problem 7: nth *)
(******************)

let rec nth l n =
  let rec aux l index =
    match l with
    | [] -> []
    | x :: xs -> if index mod n = 0 then x :: aux xs (index + 1) 
                 else aux xs (index + 1)
  in
  aux l 1

(*****************************************************)
(* Problem 8: Digital Roots and Additive Persistence *)
(*****************************************************)
(* digits : int -> int list
 * we assume n >= 0
 * (digits n) is the list of digits of n in the order in which they appear in n
 * e.g. (digits 31243) is [3,1,2,4,3]
 *)

 let rec digitsOfInt n =
  if n < 0 then []
  else if n < 10 then [n]
  else digitsOfInt (n / 10) @ [n mod 10]


(* From http://mathworld.wolfram.com/AdditivePersistence.html
 * Consider the process of taking a number, adding its digits,
 * then adding the digits of the number derived from it, etc.,
 * until the remaining number has only one digit.
 * The number of additions required to obtain a single digit from a number n
 * is called the additive persistence of n, and the digit obtained is called
 * the digital root of n.
 * For example, the sequence obtained from the starting number 9876 is (9876, 30, 3), so
 * 9876 has an additive persistence of 2 and a digital root of 3.
 *)

 let rec additivePersistence n =
  if n < 10 then 0  
  else
    let rec sum_digits n acc =
      if n = 0 then acc
      else sum_digits (n / 10) (acc + (n mod 10)) 
    in
    1 + additivePersistence (sum_digits n 0)

let rec digitalRoot n =
  if n < 10 then n  
  else
    let rec sum_digits n acc =
      if n = 0 then acc
      else sum_digits (n / 10) (acc + (n mod 10))
    in
    digitalRoot (sum_digits n 0)

(********)
(* Done *)
(********)

let _ = print_string ("Testing your code ...\n")

let main () =
  let error_count = ref 0 in

  (* Testcases for pow *)
  let _ =
    try
      assert (pow 3 1 = 3);
      assert (pow 3 2 = 9);
      assert (pow (-3) 3 = -27)
    with e -> (error_count := !error_count + 1; print_string ((Printexc.to_string e)^"\n")) in

  (* Testcases for range *)
  let _ =
    try
      assert (range 2 5 = [2;3;4;5]);
      assert (range 0 0 = [0])
    with e -> (error_count := !error_count + 1; print_string ((Printexc.to_string e)^"\n")) in

  (* Testcases for flatten *)
  let _ =
    try
      assert (flatten [[1;2];[3;4]] = [1;2;3;4]);
      assert (flatten [[1;2];[];[3;4];[]] = [1;2;3;4])
    with e -> (error_count := !error_count + 1; print_string ((Printexc.to_string e)^"\n")) in

  (* Testcases for remove_stutter *)
  let _ =
    try
      assert (remove_stutter [1;2;2;3;1;1;1;4;4;2;2] = [1; 2; 3; 1; 4; 2]);
      assert (remove_stutter [] = []);
      assert (remove_stutter [1;1;1;1;1] = [1]);
      assert (remove_stutter [1;1;1;1;1;2] = [1;2])
    with e -> (error_count := !error_count + 1; print_string ((Printexc.to_string e)^"\n")) in

  (* Testcases for rotate *)
  let _ =
    try
      assert (rotate ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"] 2 = ["g"; "h"; "a"; "b"; "c"; "d"; "e"; "f"]);
      assert (rotate ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"] 0 = ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"]);
      assert (rotate ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"] 7 = ["b"; "c"; "d"; "e"; "f"; "g"; "h"; "a"])
    with e -> (error_count := !error_count + 1; print_string ((Printexc.to_string e)^"\n")) in

  (* Testcases for jump *)
  let _ =
    try
      assert (jump ["first"; "second"; "third"; "fourth"] ["fifth"; "sixth"; "seventh"; "eighth"] = ["fifth"; "second"; "seventh"; "fourth"]);
      assert (jump [1; 3; 5; 7] [0; 2; 4; 6; 8] = [0; 3; 4; 7]);
      assert (jump ["a"; "b"] ["c"] = ["c"])
    with e -> (error_count := !error_count + 1; print_string ((Printexc.to_string e)^"\n")) in

  (* Testcases for nth *)
  let _ =
    try
      (*print_int_list (nth [1; 2; 3; 4; 5; 6; 7] 1);*)
      assert (nth [1; 2; 3; 4; 5; 6; 7] 1 = [1; 2; 3; 4; 5; 6; 7]);
      assert (nth [1; 2; 3; 4; 5; 6; 7] 2 = [2; 4; 6]);
      assert (nth [1; 2; 3; 4; 5; 6; 7] 3 = [3; 6])
    with e -> (error_count := !error_count + 1; print_string ((Printexc.to_string e)^"\n")) in

  (* Testcases for digitsOfInt *)
  let _ =
    try
      assert (digitsOfInt 3124 = [3;1;2;4]);
      assert (digitsOfInt 352663 = [3;5;2;6;6;3]);
      assert (digitsOfInt 31243 = [3;1;2;4;3]);
      assert (digitsOfInt 23422 = [2;3;4;2;2])
    with e -> (error_count := !error_count + 1; print_string ((Printexc.to_string e)^"\n")) in

  (* Testcases for additivePersistence *)
  let _ =
    try
      assert (additivePersistence 9876 = 2)
    with e -> (error_count := !error_count + 1; print_string ((Printexc.to_string e)^"\n")) in

  (* Testcases for digitalRoot *)
  let _ =
    try
      assert (digitalRoot 9876 = 3)
    with e -> (error_count := !error_count + 1; print_string ((Printexc.to_string e)^"\n")) in

  Printf.printf ("%d out of 10 programming questions are correct.\n") (10 - !error_count)

let _ = main()
