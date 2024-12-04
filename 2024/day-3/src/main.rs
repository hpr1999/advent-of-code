const INPUT: &str = include_str!("input");

fn find_num<'a>(input: &'a str, divider: &str) -> Option<(usize, &'a str)> {
    let index = input.find(divider)?;
    let num = input[..index].parse().ok()?;
    Some((num, &input[index + 1..]))
}

fn eval_mul_params(input: &str) -> Option<(usize, usize, &str)> {
    let (num1, input) = find_num(input, ",")?;
    let (num2, input) = find_num(input, ")")?;
    Some((num1, num2, input))
}

enum Token {
    Mul(usize, usize),
    Do,
    Dont,
}

fn find_next_token(input: &str) -> Option<(Token, &str)> {
    let mut cur_input = input;
    loop {
        if let Some(idx) = cur_input.find("(") {
            if idx >= 2 && &cur_input[idx - 2..idx] == "do" && &cur_input[idx + 1..idx + 2] == ")" {
                return Some((Token::Do, &cur_input[idx + 2..]));
            }
            if idx >= 5
                && &cur_input[idx - 5..idx] == "don't"
                && &cur_input[idx + 1..idx + 2] == ")"
            {
                return Some((Token::Dont, &cur_input[idx + 2..]));
            }
            if idx >= 3 && &cur_input[idx - 3..idx] == "mul" {
                if let Some((num1, num2, new_input)) = eval_mul_params(&cur_input[idx + 1..]) {
                    return Some((Token::Mul(num1, num2), new_input));
                }
            }
            cur_input = &cur_input[idx + 1..];
        } else {
            return None;
        }
    }
}

fn eval_muls(input: &str, use_dont: bool) -> usize {
    let mut sum = 0;
    let mut mul_enabled = true;
    let mut curr_input = input;

    while let Some((tok, input)) = find_next_token(curr_input) {
        curr_input = input;
        match tok {
            Token::Do => mul_enabled = true,
            Token::Dont => mul_enabled = false,
            Token::Mul(num1, num2) => {
                if mul_enabled || !use_dont {
                    sum += num1 * num2;
                }
            }
        }
    }

    sum
}

fn main() {
    println!("Part 1: {}", eval_muls(INPUT, false));
    println!("Part 2: {}", eval_muls(INPUT, true));
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn test_eval_muls() {
        let input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))";
        assert_eq!(eval_muls(input, false), 161)
    }
    #[test]
    fn test_eval_muls_dont() {
        let input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))";
        assert_eq!(eval_muls(input, false), 161)
    }
}
