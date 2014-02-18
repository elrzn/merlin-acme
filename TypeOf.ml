
let state = Merlin.start "/home/bnwr/.opam/system/bin/ocamlmerlin" []
let () = match Merlin.reset ~state (Lib.gfile ()) with
	| None -> exit 2
	| Some () -> ()

let () = match Merlin.tell_string ~state (Lib.get_content ()) with
	| None -> exit 2
	| Some _ -> ()

let () =
	let wid = Lib.new_window () in
	let fname = Lib.gfile () in
	let position = (4, 13) (*TODO: get the dot position!*) in
	let types = Merlin.type_enclosing ~state ("", 0) position in
	match types with
	| None -> ()
	| Some l ->
		List.iter
			(fun (t, ((sl, sc), (el, ec))) ->
				if el = sl then
					Lib.put wid
						(Printf.sprintf "%s:%d:%d-%d: %s\n" fname sl sc ec t )
				else
					() (*TODO: better plumbing rules*)
			)
			l;
		Lib.ctl wid Lib.Clean;
		Lib.ctl wid Lib.Show

