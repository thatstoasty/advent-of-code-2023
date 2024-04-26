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

fn parse_and_sum(data: String) {
    let assert Ok(re) = regex.from_string("\\d+")
    string.split(data, "\n")
    |> list.map(_, regex.scan(re, _))
    |> list.map(_, flatten_matches)
    |> list.map(_, result.unwrap(_, 0))
    |> list.fold(_, 0, int.add)
    |> io.debug(_)
}

const substitutions = [
    #("one", "o1e"),
    #("two", "t2o"),
    #("three", "t3e"),
    #("four", "4"),
    #("five", "5e"),
    #("six", "6"),
    #("seven", "7n"),
    #("eight", "e8t"),
    #("nine", "n9e"),
]


pub fn solve_part_one() {
    result.unwrap(simplifile.read(from: "src/data/one.txt"), "")
    |> parse_and_sum(_)
}

pub fn solve_part_two() {
    result.unwrap(simplifile.read(from: "src/data/one.txt"), "")
    |> list.fold(over: substitutions, from: _, with: fn (acc, sub) {
        let #(from, to) = sub
        string.replace(in: acc, each: from, with: to)
    })
    |> parse_and_sum(_)
}
