import gleam/io
import gleam/result
import gleam/string
import gleam/int
import gleam/list
import gleam/regex.{type Match}
import simplifile


fn fold_match(content: String, m: Match) {
    string.concat([content, m.content])
}


fn flatten_matches(m: List(Match)) {
    let nums = list.fold(m, "", fold_match)
    let first = string.slice(nums, 0, 1)
    let second = string.slice(nums, -1, 1)

    string.concat([first, second])
    |> int.parse(_)
}


pub fn main() {
    let assert Ok(re) = regex.from_string("\\d+")
    result.unwrap(simplifile.read(from: "src/data.txt"), "")
    |> string.split(_, "\n")
    |> list.map(_, regex.scan(re, _))
    |> list.map(_, flatten_matches)
    |> list.map(_, result.unwrap(_, 0))
    |> list.fold(_, 0, int.add)
    |> io.debug(_)
}