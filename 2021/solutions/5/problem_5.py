from typing import NamedTuple
import doctest
import unittest
import itertools


class Point2D(NamedTuple):
    x: int
    y: int

    def __str__(self):
        return f'P({self.x},{self.y})'

    def __repr__(self) -> str:
        return self.__str__()


class LineSegment(NamedTuple):
    origin: Point2D
    destination: Point2D

    def __repr__(self) -> str:
        return self.__str__()

    def __str__(self):
        return f'L({str(self.origin)}->{str(self.destination)})'


sample_path = '../../inputs/5/sample.txt'
input_path = '../../inputs/5/vent-lines.txt'


def read_segments(file_path: str) -> 'list[LineSegment]':
    """
    Reads the specified file path in specification with the format described in the challenge.
    """
    with open(file_path) as f:
        lines = f.readlines()
        lines_segments = [
            LineSegment(*[
                Point2D(*(int(val) for val in point.strip().split(sep=',')))
                for point in line.split(sep='->')
            ]) for line in lines
        ]
        return lines_segments


def is_vertical(l: LineSegment) -> bool:
    """
    Determines whether a line segment is a straight vertical line.
    >>> is_vertical(LineSegment(Point2D(1,2),Point2D(1,3)))
    True
    >>> is_vertical(LineSegment(Point2D(-3,2),Point2D(-3,2134)))
    True
    >>> is_vertical(LineSegment(Point2D(0,1),Point2D(1,0)))
    False
    >>> is_vertical(LineSegment(Point2D(2,3),Point2D(1,3)))
    False
    """
    return l.origin.x == l.destination.x


def is_horizontal(l: LineSegment) -> bool:
    """
    Determines whether a line segment is a straight horizontal line.
    >>> is_horizontal(LineSegment(Point2D(2,3),Point2D(1,3)))
    True
    >>> is_horizontal(LineSegment(Point2D(1,2),Point2D(1,3)))
    False
    >>> is_horizontal(LineSegment(Point2D(-1,32),Point2D(100,32)))
    True
    >>> is_horizontal(LineSegment(Point2D(0,1),Point2D(1,0)))
    False
    """
    return l.origin.y == l.destination.y


def is_straight(l: LineSegment) -> bool:
    """
    Determines whether a line segment is a straight line, whether horizontal or vertical.
    >>> is_straight(LineSegment(Point2D(2,3),Point2D(1,3)))
    True
    >>> is_straight(LineSegment(Point2D(1,2),Point2D(1,3)))
    True
    >>> is_straight(LineSegment(Point2D(-1,32),Point2D(100,32)))
    True
    >>> is_straight(LineSegment(Point2D(1,2),Point2D(1,3)))
    True
    >>> is_straight(LineSegment(Point2D(-3,2),Point2D(-3,2134)))
    True
    >>> is_straight(LineSegment(Point2D(0,1),Point2D(1,0)))
    False
    """
    return is_vertical(l) or is_horizontal(l)


def is_rising(l: LineSegment) -> bool:
    """
    Determines whether a line segment is a diagonal line that is rising.
    >>> is_rising(LineSegment(Point2D(0,0),Point2D(3,3)))
    True
    >>> is_rising(LineSegment(Point2D(0,3),Point2D(3,0)))
    False
    >>> is_rising(LineSegment(Point2D(-3,2),Point2D(-3,2134)))
    False
    """
    return l.origin.x - l.destination.x == l.origin.y - l.destination.y


def is_falling(l: LineSegment) -> bool:
    """
    Determines whether a line segment is a diagonal line that is falling.
    >>> is_falling(LineSegment(Point2D(0,0),Point2D(3,3)))
    False
    >>> is_falling(LineSegment(Point2D(0,3),Point2D(3,0)))
    True
    >>> is_falling(LineSegment(Point2D(-3,2),Point2D(-3,2134)))
    False
    """
    return l.origin.x - l.destination.x == -(l.origin.y - l.destination.y)


def is_diagonal(l: LineSegment) -> bool:
    """
    Determines whether a line segment is a diagonal line, whether rising or falling.
    >>> is_diagonal(LineSegment(Point2D(0,0),Point2D(3,3)))
    True
    >>> is_diagonal(LineSegment(Point2D(0,3),Point2D(3,0)))
    True
    >>> is_diagonal(LineSegment(Point2D(-3,2),Point2D(-3,2134)))
    False
    """
    return abs(l.origin.x - l.destination.x) == abs(l.origin.y -
                                                    l.destination.y)


def straight_parallel_intersections(line1: LineSegment,
                                    line2: LineSegment) -> 'set[Point2D]':
    """
    For two parallel lines, this function returns their overlapping points.

    >>> straight_parallel_intersections(\
          LineSegment(Point2D(0,0),Point2D(0,5)),\
          LineSegment(Point2D(0,1),Point2D(0,3)))
    {P(0,1), P(0,2), P(0,3)}
    """
    vertical: bool = is_vertical(line1)

    if vertical and line1.origin.x != line2.origin.x or \
    not vertical and line1.origin.y != line2.origin.y:
        return {}

    irrelevant_coord = line1.origin.x if vertical else line1.origin.y

    l1_orig, l1_dest, l2_orig, l2_dest = (
        line1.origin.y, line1.destination.y, line2.origin.y,
        line2.destination.y) if vertical else (line1.origin.x,
                                               line1.destination.x,
                                               line2.origin.x,
                                               line2.destination.x)

    l1_hi, l1_lo = (l1_orig, l1_dest) if l1_orig > l1_dest else (l1_dest,
                                                                 l1_orig)
    l2_hi, l2_lo = (l2_orig, l2_dest) if l2_orig > l2_dest else (l2_dest,
                                                                 l2_orig)

    if (l1_hi < l2_lo or l1_lo > l2_hi):
        return {}
    else:
        relevant_spots = range(max(l1_lo, l2_lo), min(l1_hi, l2_hi) + 1)
        return {
            Point2D(irrelevant_coord, spot) if vertical else Point2D(
                spot, irrelevant_coord)
            for spot in relevant_spots
        }


def straight_right_angle_intersection(line1: LineSegment,
                                      line2: LineSegment) -> 'set[Point2D]':
    vertical_line, horizontal_line = (line1,
                                      line2) if is_vertical(line1) else (line2,
                                                                         line1)
    vert_x, horiz_y = vertical_line.origin.x, horizontal_line.origin.y

    horiz_bounds = (horizontal_line.origin.x, horizontal_line.destination.x)
    horiz_lo, horiz_hi = (min(*horiz_bounds), max(*horiz_bounds))

    vert_bounds = (vertical_line.origin.y, vertical_line.destination.y)
    vert_lo, vert_hi = (min(*vert_bounds), max(*vert_bounds))

    if (horiz_lo <= vert_x <= horiz_hi and vert_lo <= horiz_y <= vert_hi):
        return {Point2D(vertical_line.origin.x, horizontal_line.origin.y)}

    return {}


def straight_intersections(line1: LineSegment,
                           line2: LineSegment) -> 'set[Point2D]':
    """
    Returns the Point2D at which to straight lines intersect.

    >>> straight_intersections(\
      LineSegment(Point2D(0,1),Point2D(2,1)),\
      LineSegment(Point2D(1,0),Point2D(1,2)))
    {P(1,1)}
    >>> straight_intersections(\
      LineSegment(Point2D(1,0),Point2D(1,2)),\
      LineSegment(Point2D(0,1),Point2D(2,1)))
    {P(1,1)}
    >>> straight_intersections(\
      LineSegment(Point2D(0,1),Point2D(2,1)),\
      LineSegment(Point2D(1,0),Point2D(0,3)))
    Traceback (most recent call last):
    ...
    AssertionError: only straight lines allowed
    >>> straight_intersections(\
      LineSegment(Point2D(1,0),Point2D(0,3)),\
      LineSegment(Point2D(0,1),Point2D(2,1)))
    Traceback (most recent call last):
    ...
    AssertionError: only straight lines allowed
    """
    if not (is_straight(line1) and is_straight(line2)):
        raise AssertionError('only straight lines allowed')

    if (is_vertical(line1) and is_vertical(line2)
            or is_horizontal(line1) and is_horizontal(line2)):
        return straight_parallel_intersections(line1, line2)
    else:
        return straight_right_angle_intersection(line1, line2)


def diag_with_straight_intersections(line1: LineSegment,
                                     line2: LineSegment) -> 'set[Point2D]':
    pass  # TODO


def diag_intersections(line1: LineSegment,
                       line2: LineSegment) -> 'set[Point2D]':

    if (not is_diagonal(line1) or not is_diagonal(line2)):
        raise AssertionError('only diagonals allowed')

    if (is_rising(line1) == is_rising(line2)):
        rising, falling = (line1, line2) if is_rising(line1) else (line2,
                                                                   line1)
        pass  # TODO

    else:
        pass  # TODO


def intersections(line1: LineSegment, line2: LineSegment) -> 'set[Point2D]':
    if (is_straight(line1) and is_straight(line2)):
        return straight_intersections(line1, line2)
    elif (is_straight(line1) or is_straight(line2)):
        pass  # TODO
    else:
        pass  # TODO


def solve_part_one(file: str):
    segments = read_segments(file)
    relevant_segments = {
        segment
        for segment in segments if is_straight(segment)
    }
    intersections_to_check = {
        (line1, line2)
        for (line1, line2) in itertools.combinations(relevant_segments, 2)
        if line1 != line2
    }

    intersections = {
        intersection
        for (line1, line2) in intersections_to_check
        for intersection in straight_intersections(line1, line2)
        if intersection
    }
    return len(intersections)


class TestSample(unittest.TestCase):
    def test_sample(self):
        self.assertEqual(solve_part_one(sample_path), 5)


if __name__ == "__main__":
    doctest.testmod()
    unittest.TextTestRunner().run(
        unittest.TestLoader().loadTestsFromTestCase(TestSample))

    print(solve_part_one(input_path))
