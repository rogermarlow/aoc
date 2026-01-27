from itertools import combinations
coeffs = [(0, 0, 0, 1), (0, 1, 0, 1), (0, 0, 1, 0), (0, 0, 1, 1), (1, 0, 1, 0), (1, 1, 0, 0)]
num_buttons = len(coeffs)
num_variables = len(coeffs[0])
# for pattern_len in range(num_buttons+1):
#     for buttons in combinations(range(num_buttons), pattern_len): # buttons goes through all possible combinations of button presses
#         print(f'buttons: {buttons}')
#         print( *(coeffs[i] for i in buttons) ) # joltage increments for this button combo
#         print(*zip((0,) * num_variables, *(coeffs[i] for i in buttons))) # zip the increments, plus a zero at the front. This is a way to go from a tuple of n to n tuples. So all increments to 0th joltage are in the first tuple
#         print(*map(sum, zip((0,) * num_variables, *(coeffs[i] for i in buttons))))
#         print(f'pattern: {tuple(map(sum, zip((0,) * num_variables, *(coeffs[i] for i in buttons))))}')

pattern = (2,2,3,3)
pattern_cost = 6
goal = (3,5,4,7)
print(*(i <= j and i % 2 == j % 2 for i, j in zip(pattern, goal)))
