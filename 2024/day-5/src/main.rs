use std::collections::HashMap;
use std::fmt::Debug;
use std::ops::ControlFlow;

const INPUT: &str = include_str!("input");

#[derive(Debug)]
struct OrderRule {
    before: PageNum,
    after: PageNum,
}

impl OrderRule {
    fn parse_from_line(line: &str) -> Result<OrderRule, String> {
        let get_err = || "invalid input".to_owned() + line;
        let (before, after) = line.split_once("|").ok_or_else(get_err)?;
        let before = before.trim().parse().map_err(|_| get_err())?;
        let after = after.trim().parse().map_err(|_| get_err())?;
        Ok(OrderRule { before, after })
    }

    fn is_satisfied(&self, update_index: &UpdateIndex) -> bool {
        if let (Some(before), Some(after)) = (
            update_index.get(&self.before),
            update_index.get(&self.after),
        ) {
            before < after
        } else {
            true
        }
    }
}

type Update = Vec<PageNum>;
trait IUpdate {
    fn parse_from_line(line: &str) -> Result<Update, String>;
    fn get_middle_num(&self) -> PageNum;
}
impl IUpdate for Update {
    fn parse_from_line(line: &str) -> Result<Update, String> {
        let get_err = |_| "invalid input".to_owned() + line;
        line.split(",")
            .map(|num_str| num_str.parse().map_err(get_err))
            .collect()
    }

    fn get_middle_num(&self) -> PageNum {
        self[self.len() / 2]
    }
}

type UpdateIndex = HashMap<PageNum, usize>;

fn get_index(list: &Update) -> UpdateIndex {
    let mut index = HashMap::new();
    for i in 0..list.len() {
        index.insert(list[i], i);
    }
    index
}

type PageNum = usize;

fn parse_input(input: &str) -> Result<(Vec<OrderRule>, Vec<Update>), String> {
    let (rules, pages) = input.split_once("\n\n").ok_or("invalid input")?;
    let rules = rules
        .lines()
        .try_fold(
            Vec::new(),
            |mut vec: Vec<OrderRule>, line| match OrderRule::parse_from_line(line) {
                Ok(order_rule) => {
                    vec.push(order_rule);
                    ControlFlow::Continue(vec)
                }
                Err(err) => ControlFlow::Break(err),
            },
        );

    let pages = pages.lines().try_fold(Vec::new(), |mut vec, line| {
        match { Update::parse_from_line(line) } {
            Ok(order_rule) => {
                vec.push(order_rule);
                ControlFlow::Continue(vec)
            }
            Err(err) => ControlFlow::Break(err),
        }
    });

    match (rules, pages) {
        (ControlFlow::Break(e1), ControlFlow::Break(e2)) => Err(e1 + &*e2),
        (ControlFlow::Break(err), _) | (_, ControlFlow::Break(err)) => Err(err),
        (ControlFlow::Continue(rules), ControlFlow::Continue(pages)) => Ok((rules, pages)),
    }
}

fn part1(input: &str) -> PageNum {
    let mut result = 0;
    if let Ok((rules, updates)) = parse_input(input) {
        for update in updates {
            let index = get_index(&update);
            if rules.iter().all(|rule| rule.is_satisfied(&index)) {
                let middle_num = update.get_middle_num();
                result += middle_num;
            }
        }
    }

    result
}
fn part2() {}

fn main() {
    println!("Part 1: {}", part1(INPUT));
    // println!("Part 2: {}", part2());
}

#[cfg(test)]
mod tests {
    use super::*;
    const INPUT: &str = "\
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
";

    #[test]
    fn test_part1() {
        assert_eq!(part1(INPUT), 143);
    }
    #[test]
    fn test_part2() {}
}
