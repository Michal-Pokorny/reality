import csv

def write_into_csv_file(file_name, header_row, data):
	file = open(file_name, 'w+', newline ='', encoding="utf-8")
	with file:
		write = csv.writer(file, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL)
		header = [header_row]
		write.writerows(header)
		write.writerows(data)