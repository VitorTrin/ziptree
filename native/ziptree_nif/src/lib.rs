mod supported_term;

use ziptree::ZipTree;
use rustler::resource::ResourceArc;
use rustler::{Atom, Env, Term};
use crate::supported_term::SupportedTerm;

pub struct ZipTreeOfTerms(ZipTree<SupportedTerm,SupportedTerm>);

impl ZipTreeOfTerms {
    fn new() -> ZipTreeOfTerms {
        ZipTreeOfTerms(ZipTree::<SupportedTerm,SupportedTerm>::new())
    }
}

type ZipTreeArc = ResourceArc<ZipTreeOfTerms>;

mod atoms {
    rustler::atoms! {
        ok,
        error
    }
}

#[rustler::nif]
fn new() -> (Atom, ZipTreeArc){
    let resource = ResourceArc::new(ZipTreeOfTerms::new());

    (atoms::ok(), resource)
}

rustler::init!("Elixir.ZipTree.Nif", [new], load = load);

fn load(env: Env, _info: Term) -> bool {
    rustler::resource!(ZipTreeOfTerms, env);
    true
}

// use ziptree::ZipTree;
// use rustler::resource::ResourceArc;
// use rustler::{Atom, Env, Term};

// pub struct ZipTreeOfTerms<'lifetime>(ZipTree<Term<'lifetime>,Term<'lifetime>>);

// type ZipTreeArc<'lifetime> = ResourceArc<ZipTreeOfTerms<'lifetime>>;

// mod atoms {
//     rustler::atoms! {
//         ok
//     }
// }

// #[rustler::nif]
// fn new<'lifetime>() -> (Atom, ZipTreeArc<'lifetime>){
//     let resource = ResourceArc::new(ZipTree::new());

//     (atoms::ok, resource)
// }

// rustler::init!("Elixir.ZipTree.Nif", [new], load = load);

// fn load<'lifetime: 'static>(env: Env, _info: Term) -> bool {
//     rustler::resource!(ZipTreeOfTerms<'lifetime>, env);
//     true
// }