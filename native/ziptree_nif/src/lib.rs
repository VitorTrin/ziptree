mod supported_term;

use ziptree::ZipTree;
use std::sync::Mutex;
use rustler::resource::ResourceArc;
use rustler::types::tuple::get_tuple;
use rustler::{Atom, Env, Term};
use crate::supported_term::SupportedTerm;

// We need to define our own struct so we can limit what it can accept
// and so we can invoke resource! in it
// It's also a mutex so we can make it mutable
pub struct ZipTreeOfTerms(Mutex<ZipTree<SupportedTerm,SupportedTerm>>);

mod atoms {
    rustler::atoms! {
        ok,
        error,
        lock_fail,
        unsupported_type,
        failed_to_insert,
        nil,
        not_found
    }
}

#[rustler::nif]
fn new() -> (Atom, ResourceArc<ZipTreeOfTerms>){
    let resource = ResourceArc::new(ZipTreeOfTerms(Mutex::new(ZipTree::new())));

    (atoms::ok(), resource)
}

#[rustler::nif]
fn size(resource: ResourceArc<ZipTreeOfTerms>) -> Result<usize, Atom>{
    let ziptree = match resource.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };

    Ok(ziptree.len())
}

#[rustler::nif]
fn put(resource: ResourceArc<ZipTreeOfTerms>, key: Term, value: Term) -> Result<SupportedTerm, Atom> {
    let mut ziptree = match resource.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };

    // We allow any Term, but make sure they are supported
    let valid_key = match convert_to_supported_term(&key) {
        None => return Err(atoms::unsupported_type()),
        Some(term) => term,
    };

    let valid_value = match convert_to_supported_term(&value) {
        None => return Err(atoms::unsupported_type()),
        Some(term) => term,
    };

    match ziptree.insert(valid_key, valid_value){
        // Did not have this key
        None => Ok(SupportedTerm::Atom("nil".to_string())),
        // Already had a key with this value
        Some(term) => Ok(term),
    }
}

#[rustler::nif]
fn delete(resource: ResourceArc<ZipTreeOfTerms>, key: Term) -> Result<SupportedTerm, Atom> {
    let mut ziptree = match resource.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };

    // We allow any Term, but make sure they are supported
    let valid_key = match convert_to_supported_term(&key) {
        None => return Err(atoms::unsupported_type()),
        Some(term) => term,
    };

    match ziptree.remove(&valid_key){
        // Did not have this key
        None => Err(atoms::not_found()),
        // Had the key
        Some(term) => Ok(term),
    }
}

#[rustler::nif]
fn get(resource: ResourceArc<ZipTreeOfTerms>, key: Term) -> Result<SupportedTerm, Atom> {
    let ziptree = match resource.0.try_lock() {
        Err(_) => return Err(atoms::lock_fail()),
        Ok(guard) => guard,
    };

    // We allow any Term, but make sure they are supported
    let valid_key = match convert_to_supported_term(&key) {
        None => return Err(atoms::unsupported_type()),
        Some(term) => term,
    };

    match ziptree.get(&valid_key){
        // Did not have this key
        None => Err(atoms::not_found()),
        // Had the key
        Some(&ref term) => Ok(term.clone()),
    }
}

rustler::init!("Elixir.Ziptree.Nif", [new, size, put, delete, get], load = load);

// Makes the struct be supported by rustler so it can be returned in functions
fn load(env: Env, _info: Term) -> bool {
    rustler::resource!(ZipTreeOfTerms, env);
    true
}

// Also from sorted_set_nif
fn convert_to_supported_term(term: &Term) -> Option<SupportedTerm> {
    if term.is_number() {
        match term.decode() {
            Ok(i) => Some(SupportedTerm::Integer(i)),
            Err(_) => None,
        }
    } else if term.is_atom() {
        match term.atom_to_string() {
            Ok(a) => Some(SupportedTerm::Atom(a)),
            Err(_) => None,
        }
    } else if term.is_tuple() {
        match get_tuple(*term) {
            Ok(t) => {
                let initial_length = t.len();
                let inner_terms: Vec<SupportedTerm> = t
                    .into_iter()
                    .filter_map(|i: Term| convert_to_supported_term(&i))
                    .collect();
                if initial_length == inner_terms.len() {
                    Some(SupportedTerm::Tuple(inner_terms))
                } else {
                    None
                }
            }
            Err(_) => None,
        }
    } else if term.is_list() {
        match term.decode::<Vec<Term>>() {
            Ok(l) => {
                let initial_length = l.len();
                let inner_terms: Vec<SupportedTerm> = l
                    .into_iter()
                    .filter_map(|i: Term| convert_to_supported_term(&i))
                    .collect();
                if initial_length == inner_terms.len() {
                    Some(SupportedTerm::List(inner_terms))
                } else {
                    None
                }
            }
            Err(_) => None,
        }
    } else if term.is_binary() {
        match term.decode() {
            Ok(b) => Some(SupportedTerm::Bitstring(b)),
            Err(_) => None,
        }
    } else {
        None
    }
}