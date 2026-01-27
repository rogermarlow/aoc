# Advent of code. Day 1.
import re, regex

val = {"one": "1",
       "two": "2",
       "three": "3",
       "four": "4",
       "five": "5",
       "six": "6",
       "seven": "7",
       "eight": "8",
       "nine": "9",
       "0": "0",
       "1": "1",
       "2": "2",
       "3": "3",
       "4": "4",
       "5": "5",
       "6": "6",
       "7": "7",
       "8": "8",
       "9": "9"}

def fn(l):
    m = regex.findall("one|two|three|four|five|six|seven|eight|nine|[0-9]",
                       l, overlapped=True)
    return int( val[m[0]] + val[m[-1]])

print( sum( [ fn(l) for l in open("input.txt")]) )