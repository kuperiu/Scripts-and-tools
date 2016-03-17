#!/usr/bin/env python
import time, sys, json, csv, os
'''
This class converts a json object as a string from a file into a line in a csv file
1. to keep the csv orginze we'll use a global 2d array that will grow every time we'll get a new key
2. we'll use each line of the json file as an attribute and we'll process it
3. at the end we'll print the line to a csv file
'''
class Iron:
    full_array = []
    full_array.append([])
    full_array.append([])

    def __init__(self, line, file_name):
        self.line = line
        self.file_name = file_name

#write array to csv
    def csv_writer(self, arr):
        output_name = os.path.splitext(self.file_name)[0] + ".csv"
        with open(output_name , 'a') as file:
            writer = csv.writer(file, delimiter=',')
            writer.writerow(arr)

#format the global array before we'll add new values
    def format_array(self):
        counter = 0
        for i in Iron.full_array[1]:
            Iron.full_array[1][counter] = ""
            counter += 1

#add new keys and place the values in the array
    def add_key_to_full_array(self, decoded):
        for key in decoded:
            if key in self.full_array[0]:
                index = self.full_array[0].index(key)
                self.full_array[1][index] = decoded[key]
            else:
                self.full_array[0].append(key)
                self.full_array[1].append(decoded[key])

#format the line to json and process
    def decode_json(self):
        self.format_array()
        decoded = json.loads(self.line)
        self.add_key_to_full_array(decoded)


def main():
    file_name = sys.argv[1]
    with open(file_name) as f:
        for line in f:
            obj = Iron(line, file_name)
            obj.decode_json()
            obj.csv_writer(Iron.full_array[1])
if __name__ == '__main__':
  main()
