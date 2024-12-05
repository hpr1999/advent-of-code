const INPUT: &str = include_str!("input");

struct Offset {
    x: i8,
    y: i8,
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

#[derive(Clone, Copy, Debug)]
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
}

struct Match {
    position: Position,
    direction: Offset,
}

fn try_get_word_occurrences(board: &Board, position: Position, word: &str) -> Vec<Match> {
    let mut matches = vec![];
    for direction in DIRECTIONS {
        let found = board.get_string(&position, &direction, word.len());
        if found == word {
            matches.push(Match {
                position,
                direction,
            })
        }
    }
    matches
}

fn get_word_occurences(board: &Board, word: &str) -> Vec<Match> {
    let mut matches: Vec<Match> = vec![];
    for pos in board.get_positions() {
        matches.append(&mut try_get_word_occurrences(&board, pos, word));
    }
    matches
}

fn parse_board(input: &str) -> Board {
    input.lines().map(|line| line.chars().collect()).collect()
}

fn main() {
    let board = parse_board(INPUT);
    println!("Part 1: {}", get_word_occurences(&board, "XMAS").len());
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part1() {
        let input = "\
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
        let board: Board = parse_board(input);
        assert_eq!(get_word_occurences(&board, "XMAS").len(), 18);
    }
}
