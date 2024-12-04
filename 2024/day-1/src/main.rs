use std::collections::HashMap;

const INPUT: &str = include_str!("input");

fn get_lists(input: &str) -> (Vec<i32>, Vec<i32>) {
    let lines = input.lines();
    let mut first_list = vec![];
    let mut second_list = vec![];

    for line in lines {
        let mut words = line.split_whitespace();
        let num1: i32 = words
            .next()
            .expect("Mismatched input")
            .parse()
            .expect("Expected number");
        let num2: i32 = words
            .next()
            .expect("Mismatched input")
            .parse()
            .expect("Expected number");
        first_list.push(num1);
        second_list.push(num2);
    }

    first_list.sort();
    second_list.sort();

    (first_list, second_list)
}

fn part_1(first_list: &Vec<i32>, second_list: &Vec<i32>) -> i32 {
    let mut distance_sum = 0;

    for i in 0..first_list.len() {
        let distance: i32 = (first_list[i] - second_list[i]).abs();
        distance_sum += distance;
    }

    distance_sum
}

fn part_2(first_list: &Vec<i32>, second_list: &Vec<i32>) -> i32 {
    let mut counts: HashMap<i32, i32> = HashMap::new();

    for i in second_list {
        let count: &i32 = counts.get(i).unwrap_or(&0);
        counts.insert(*i, *count + 1);
    }

    let mut sum = 0;

    for i in first_list {
        sum += i * counts.get(i).unwrap_or(&0);
    }

    sum
}

fn main() {
    let (first_list, second_list) = get_lists(INPUT);

    println!("Part 1: {}", part_1(&first_list, &second_list));
    println!("Part 2: {}", part_2(&first_list, &second_list));
}

#[cfg(test)]
mod tests {
    use crate::INPUT;

    #[test]
    fn it_works() {
        assert!(INPUT.len() > 0);
    }
}
