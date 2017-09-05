import csv

keys = ["title", "category", "link", "notes"]

dict = {"dishes": {"0": [] }}
with open('pocky_menu.csv') as f:
	reader = csv.reader(f)
	for row in reader:
        dish = {}
        for i in range(len(keys)):
            key = keys[i]
            if key == "category":
                dish[key] = list(row[i])
            elif len(row[i]) > 0:
                dish[key] = row[i]
		dict["dishes"]["0"].append(dish)

#from pprint import pprint
#pprint(dict)

import json

with open('pocky_menu_output.json', 'w') as f:
    json.dump(dict, f)
