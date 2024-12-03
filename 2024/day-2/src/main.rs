const INPUT: &str = include_str!("input");

fn get_reports(input: &str) -> Vec<Vec<i32>> {
    input
        .lines()
        .map(|line| {
            line.split_whitespace()
                .map(|value| value.parse().unwrap())
                .collect()
        })
        .collect()
}

fn is_safe(report: Vec<i32>) -> bool {
    let mut prev_signum = 0;
    for i in 1..report.len() {
        let prev = report[i - 1];
        let curr = report[i];
        let diff = curr - prev;
        let abs_diff = diff.abs();
        let signum = diff.signum();

        match prev_signum {
            0 => prev_signum = signum,
            _ => {
                if signum != prev_signum {
                    return false;
                }
            }
        }

        if abs_diff < 1 || abs_diff > 3 {
            return false;
        }
    }

    true
}


fn num_safe_reports(reports: Vec<Vec<i32>>) -> usize {
    let mut safe_reports = 0;
    for report in reports {
        if is_safe(report) {
            safe_reports += 1;
        }
    }
    safe_reports
}

fn is_safe_with_dampener(report: Vec<i32>) -> bool {
    if is_safe(report.clone()) { return true; }

    for i in 0..report.len() {
        let mut clone = report.clone();
        clone.remove(i);
        if is_safe(clone) { return true }
    }

    false
}

fn num_safe_reports_with_dampener(reports: Vec<Vec<i32>>) -> usize {
    let mut safe_reports = 0;
    for report in reports {
        if is_safe_with_dampener(report) {
            safe_reports += 1;
        }
    }
    safe_reports
}

fn main() {
    println!(
        "Part 1: safe reports: {}",
        num_safe_reports(get_reports(INPUT))
    );
    println!(
        "Part 2: safe reports: {}",
        num_safe_reports_with_dampener(get_reports(INPUT))
    );
}

#[cfg(test)]
mod tests {
    use crate::{is_safe, is_safe_with_dampener, num_safe_reports, num_safe_reports_with_dampener};

    #[test]
    fn test_is_safe() {
        assert_eq!(is_safe(vec![7, 6, 4, 2, 1]), true);
        assert_eq!(is_safe(vec![1, 2, 7, 8, 9]), false);
        assert_eq!(is_safe(vec![9, 7, 6, 2, 1]), false);
        assert_eq!(is_safe(vec![1, 3, 2, 4, 5]), false);
        assert_eq!(is_safe(vec![8, 6, 4, 4, 1]), false);
        assert_eq!(is_safe(vec![1, 3, 6, 7, 9]), true);
    }

    #[test]
    fn test_part_1() {
        assert_eq!(
            num_safe_reports(vec![
                vec![7, 6, 4, 2, 1],
                vec![1, 2, 7, 8, 9],
                vec![9, 7, 6, 2, 1],
                vec![1, 3, 2, 4, 5],
                vec![8, 6, 4, 4, 1],
                vec![1, 3, 6, 7, 9]
            ]),
            2
        );
    }

    #[test]
    fn test_is_safe_with_dampener() {
        assert_eq!(is_safe_with_dampener(vec![7, 6, 4, 2, 1]), true);
        assert_eq!(is_safe_with_dampener(vec![1, 2, 7, 8, 9]), false);
        assert_eq!(is_safe_with_dampener(vec![9, 7, 6, 2, 1]), false);
        assert_eq!(is_safe_with_dampener(vec![1, 3, 2, 4, 5]), true);
        assert_eq!(is_safe_with_dampener(vec![8, 6, 4, 4, 1]), true);
        assert_eq!(is_safe_with_dampener(vec![1, 3, 6, 7, 9]), true);
    }

    #[test]
    fn test_part_2() {
        assert_eq!(
            num_safe_reports_with_dampener(vec![
                vec![7, 6, 4, 2, 1],
                vec![1, 2, 7, 8, 9],
                vec![9, 7, 6, 2, 1],
                vec![1, 3, 2, 4, 5],
                vec![8, 6, 4, 4, 1],
                vec![1, 3, 6, 7, 9]
            ]),
            4
        );
    }
}
