import Util

def solve(rule):
    lines = Util.read_file("02")
    triples = [line.split(' ') for line in lines]

    valid = 0

    for triple in triples:
        [int1,int2]=[int(x) for x in triple[0].split('-')]
        letters=triple[1][:-1]
        password=triple[2]
        
        if rule(int1,int2,password,letters):
            valid+=1
    return valid

def part_one():
    return solve(rule_one)

def rule_one(int1,int2,password,letters):
    return int1 <= password.count(letters) <= int2

def part_two():
    return solve(rule_two)

def rule_two(int1,int2,password,letters):
    return (password[int1-1]==letters) != (password[int2-1]==letters)

print(part_two())
