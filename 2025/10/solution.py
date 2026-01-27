from functools import cache
from itertools import combinations

def patterns(coeffs: list[tuple[int, ...]]) -> dict[tuple[int, ...], int]:
    out = {}
    num_buttons = len(coeffs)
    num_variables = len(coeffs[0])
    for pattern_len in range(num_buttons+1):  # 0,...,6
      for buttons in combinations(range(num_buttons), pattern_len): # buttons is all button combinations, (),(0,),(1,),...(0,1),(0,2),...(0,1,2,3,4,5)
          pattern = tuple(map(sum, zip((0,) * num_variables, *(coeffs[i] for i in buttons))))  # A tuple of total joltage increments in each position
          if pattern not in out:
              out[pattern] = pattern_len  # (2,2,3,3) => 6  ; joltages increase by 2,2,3,3 for 6 button presses.
    return out

# which lights are toggled---v-----v
# coeffs: [(0, 0, 0, 1), (0, 1, 0, 1), (0, 0, 1, 0), (0, 0, 1, 1), (1, 0, 1, 0), (1, 1, 0, 0)]
# goal: (3, 5, 4, 7)
#
# Pre-calc what joltage increments the provided buttons create when pressed in every combination, store the number of button presses with it.
#    e.g. Joltage changes (2, 1, 3, 2) "costs" 5 button presses.
#    the joltage changes are generated from combos of the buttons
# Then, for a goal joltage, e.g. (3,5,4,7)
#   if the goal is all zeros, return 0
#   Go through all the available joltage increment "patterns"...
#     If the inc would not make the joltage negative when subtracted,
#     and the inc has the same parity as the joltage, so when subtracted it will give an even joltage,
#      then make a new goal of half the adjusted joltage, and add [number_presses (pattern cost) + 2xsolve(new_goal)] to an array of answers
#  return the min of the array (when the recursions have all terminated)

# Goal: (9, 9, 3, 7, 8, 9, 7, 5, 9, 10) Answer: 13
def solve_single(coeffs: list[tuple[int, ...]], goal: tuple[int, ...]) -> int:
    pattern_costs = patterns(coeffs)  # Joltage button inc. pattern (2,2,3,3) costs 6 button presses.
    print(f'pattern_costs: {pattern_costs}')
    @cache
    def solve_single_aux(goal: tuple[int, ...]) -> int:
        if all(i == 0 for i in goal): return 0
        answer = 1000000
        for pattern, pattern_cost in pattern_costs.items():
            if all(i <= j and i % 2 == j % 2 for i, j in zip(pattern, goal)): # In this pattern, if all joltage incs < goals, and both have the same parity.
                new_goal = tuple((j - i)//2 for i, j in zip(pattern, goal)) # Subtract the inc of the goal and halve (E - E = E. O - O = E). This is the new goal.
                answer = min(answer, pattern_cost + 2 * solve_single_aux(new_goal))
        return answer
    return solve_single_aux(goal)

def solve(raw: str):
        answer = 0
        lines = raw.splitlines()
        for I, L in enumerate(lines, 1):
                _, *coeffs, goal = L.split()  # [##.#] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
                goal = tuple(int(i) for i in goal[1:-1].split(","))  # e.g. (3, 5, 4, 7)
                coeffs = [[int(i) for i in r[1:-1].split(",")] for r in coeffs] # e.g. [[3], [1, 3], [2], [2, 3], [0, 2], [0, 1]]
#                                                                         which light the botton toggles -v
                coeffs = [tuple(int(i in r) for i in range(len(goal))) for r in coeffs] # e.g. [(0, 0, 0, 1), (0, 1, 0, 1), (0, 0, 1, 0), (0, 0, 1, 1), (1, 0, 1, 0), (1, 1, 0, 0)]
                subanswer = solve_single(coeffs, goal)
                print(f'Line {I}/{len(lines)}: answer {subanswer}')
                answer += subanswer
        print(answer)

def tmp_soln(raw: str):
        answer = 0
        lines = raw.splitlines()
        for I, L in enumerate(lines, 1):
                _, *coeffs, goal = L.split()  # [##.#] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
                coeffs = [[int(i) for i in r[1:-1].split(",")] for r in coeffs] # e.g. [[3], [1, 3], [2], [2, 3], [0, 2], [0, 1]]
#                                                                         which light the botton toggles -v
                coeffs = [tuple(int(i in r) for i in range(len(goal))) for r in coeffs] # e.g. [(0, 0, 0, 1), (0, 1, 0, 1), (0, 0, 1, 0), (0, 0, 1, 1), (1, 0, 1, 0), (1, 1, 0, 0)]
                subanswer = solve_single(coeffs, goal)
                print(f'Line {I}/{len(lines)}: answer {subanswer}')
                answer += subanswer
        print(answer)

solve(open('tiny2.txt').read())
#solve(open('input.txt').read())
