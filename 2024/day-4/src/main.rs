use std::collections::HashMap;

const INPUT: &str = include_str!("input");

struct Offset {
    x: i8,
    y: i8,
}

impl Offset {
    fn is_diagonal(&self) -> bool {
        self.x != 0 && self.y != 0
    }
}

const DIRECTIONS: [Offset; 8] = {
    const DEFAULT_OFFSET: Offset = Offset { x: 0, y: 0 };
    let mut result = [DEFAULT_OFFSET; 8];
    let mut index = 0;
    let mut x = -1;
    let mut y = -1;

    while x <= 1 {
        while y <= 1 {
            if !(x == 0 && y == 0) {
                result[index] = Offset { x, y };
                index += 1;
            };
            y += 1;
        }
        x += 1;
        y = -1;
    }

    result
};

#[derive(Clone, Copy, Debug, Hash, Eq, PartialEq)]
struct Position {
    x: usize,
    y: usize,
}

impl Position {
    fn moved_by(&self, offset: &Offset) -> Option<Position> {
        let x = self.x.checked_add_signed(offset.x as isize)?;
        let y = self.y.checked_add_signed(offset.y as isize)?;
        Some(Position { x, y })
    }
}

type Board<'a> = Vec<Vec<char>>;
trait IBoard {
    fn get_positions(&self) -> Vec<Position>;
    fn get_position(&self, position: &Position) -> Option<&char>;
    fn get_string(&self, position: &Position, direction: &Offset, len: usize) -> String;
    fn try_get_word_occurrences(&self, position: Position, word: &str) -> Vec<Match>;
    fn get_word_occurences(&self, word: &str) -> Vec<Match>;
    fn get_num_xmas_crosses(&self) -> usize;
}

impl IBoard for Board<'_> {
    fn get_positions(&self) -> Vec<Position> {
        let mut result = vec![];
        for x in 0..self.len() {
            let vec = self.get(x).unwrap();
            for y in 0..vec.len() {
                result.push(Position { x, y });
            }
        }
        result
    }

    fn get_position(&self, position: &Position) -> Option<&char> {
        self.get(position.x)?.get(position.y)
    }

    fn get_string(&self, position: &Position, direction: &Offset, len: usize) -> String {
        let mut result: String = String::new();
        let mut cur_pos = *position;
        for _ in 0..len {
            match self.get_position(&cur_pos) {
                Some(c) => {
                    result.push(*c);
                }
                _ => return result,
            }

            match cur_pos.moved_by(&direction) {
                Some(new_pos) => cur_pos = new_pos,
                _ => return result,
            }
        }
        result
    }

    fn try_get_word_occurrences(&self, position: Position, word: &str) -> Vec<Match> {
        let mut matches = vec![];
        for direction in DIRECTIONS {
            let found = self.get_string(&position, &direction, word.len());
            if found == word {
                matches.push(Match {
                    position,
                    direction,
                });
            }
        }
        matches
    }

    fn get_word_occurences(&self, word: &str) -> Vec<Match> {
        let mut matches: Vec<Match> = vec![];
        for pos in self.get_positions() {
            let mut occurrences = self.try_get_word_occurrences(pos, word);
            matches.append(occurrences.as_mut());
        }
        matches
    }
    fn get_num_xmas_crosses(&self) -> usize {
        let matches = self.get_word_occurences("MAS");
        let matches: Vec<Match> = matches
            .into_iter()
            .filter(|m| m.direction.is_diagonal())
            .collect();
        let mut map: HashMap<Position, usize> = HashMap::new();

        for m in matches {
            if let Some(a_pos) = m.position.moved_by(&m.direction) {
                match map.get(&a_pos) {
                    Some(count) => map.insert(a_pos, *count + 1),
                    _ => map.insert(a_pos, 1),
                };
            }
        }

        map.iter().filter(|(_, &count)| count > 1).count()
    }
}

struct Match {
    position: Position,
    direction: Offset,
}

fn parse_board(input: &str) -> Board {
    input.lines().map(|line| line.chars().collect()).collect()
}

fn main() {
    let board = parse_board(INPUT);
    println!("Part 1: {}", board.get_word_occurences("XMAS").len());
    println!("Part 2: {}", board.get_num_xmas_crosses());
}

#[cfg(test)]
mod tests {
    use super::*;
    const INPUT: &str = "\
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX";

    #[test]
    fn test_part1() {
        let board: Board = parse_board(INPUT);
        assert_eq!(board.get_word_occurences("XMAS").len(), 18);
    }
    #[test]
    fn test_part2() {
        let board: Board = parse_board(INPUT);
        assert_eq!(board.get_num_xmas_crosses(), 9);
    }
}
