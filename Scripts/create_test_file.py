EAS = [
    {
        "name": "Data register direct",
        "abbr": "Dn",
        "syntax": "D{}",
        "fill_data": ['0', '1']
    },
    # {
    #     "name": "Address register direct",
    #     "abbr": "An",
    #     "syntax": "A{}",
    #     "fill_data": ['1', '2']
    # },
    {
        "name": "Address register indirect",
        "abbr": "(An)",
        "syntax": "(A{})",
        "fill_data": ['1', '2']
    },
    {
        "name": "Immediate addressing",
        "abbr": "#",
        "syntax": "#{}",
        "fill_data": ['$AA', '$77']
    },
    {
        "name": "Address Register Indirect with post incrementing",
        "abbr": "(An)+",
        "syntax": "(A{})+",
        "fill_data": ['1', '2']
    },
    {
        "name": "Address Register Indirect with pre decrementing",
        "abbr": "-(An)",
        "syntax": "-(A{})",
        "fill_data": ['1', '2']
    },
    {
        "name": "Absolute Long Address",
        "abbr": "ALA",
        "syntax": "{}.L",
        "fill_data": ['$A000', '$A0F0']
    },
    {
        "name": "Absolute Word Address",
        "abbr": "AWA",
        "syntax": "{}.W",
        "fill_data": ['$A000', '$A0F0']
    },
]

OPCODES = [
    'MOVE'
]

MODES = ['B', 'W', 'L']

combinations = []

# build legal combinations for operand 1 (source), operand 2 (destination)
for i in EAS:
    for j in EAS:
        if j['abbr'] != '#':
            combinations.append([i, j])

return_string = ""
# init file
return_string += "\torg $8000\t* start at this address\n"
return_string += "START\tNOP\t* first instruction NOP for testing\n"
# init address registers
return_string += "\tLEA $A000,A1\t* init Address registers\n"
return_string += "\tLEA $A0F0,A2\n"

# init data registers
return_string += "\tMOVE.B #5,D0\t* init data registers\n"
return_string += "\tMOVE.B #15,D1\n\n\n"

for op_code in OPCODES:
    for mode in MODES:
        return_string += '* Testing all EAs for ' + op_code + '.' + mode + '\n'
        for ea_combo in combinations:
            ea1 = ea_combo[0]
            ea2 = ea_combo[1]
            temp_str = '\t' + op_code + '.' + mode + '\t' + \
                       ea1['syntax'].format(ea1['fill_data'][0]) + ',' + \
                       ea2['syntax'].format(ea2['fill_data'][1]) + '\t' + \
                       '* ' + ea1['name'] + ' to ' + ea2['name'] + '\n'
            return_string += temp_str
        return_string += '\n\n\n'

return_string += '\tEND\tSTART'
with open('test_move.X68', 'w') as file:
    file.write(return_string)

