import csv

dict = {"dishes": {"0": [] }}
with open('pocky_menu.csv') as f:
	reader = csv.reader(f)
	for row in reader:
		dish = {
			"title": row[0],
			"category": list(row[1]),
			"link": row[2],
			"notes": row[3]
		}
		dict["dishes"]["0"].append(dish)

#from pprint import pprint
#pprint(dict)

import json

with open('pocky_menu_output.json', 'w') as f:
    json.dump(dict, f)
