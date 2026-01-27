# Advent of code. Day 1.
import re

# def fn(l):
#     line = l.rstrip()
#     right_num = re.search("[0-9][A-z]*\Z",line).group()[0]
#     left_num  = re.search("\A[A-z]*[0-9]",line).group()[-1]
#     return int(f"{left_num}{right_num}")

# def fn2(l):
#     line = l.rstrip()
#     left_num  = re.findall("\d",line)[0]
#     right_num = re.findall("\d",line)[-1]
#     return int(f"{left_num}{right_num}")

def fn3(line):
    left_num  = re.findall("\d",line)[0]
    right_num = re.findall("\d",line)[-1]
    return int(left_num + right_num)


def my_func(arg):
    matches = re.findall('\d',arg)
    return int( matches[0] + matches[-1] )

#print( sum( [fn(l) for l in open("input.txt") ] ) )
#print( sum( [fn2(l) for l in open("input.txt") ] ) )

#assert fn('1abc2') == 12

print( sum( [my_func(l) for l in open("input.txt")]) )
