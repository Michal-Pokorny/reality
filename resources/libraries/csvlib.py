import csv
import os

def write_into_csv_file(dir_name, file_name, header_row, data):
	if not os.path.exists(dir_name):
		os.makedirs(dir_name)
	path = dir_name + "/" + file_name
	file = open(path, 'w+', newline ='', encoding="utf-8")
	with file:
		write = csv.writer(file, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL)
		header = [header_row]
		write.writerows(header)
		write.writerows(data)