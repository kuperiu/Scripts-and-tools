#!/usr/bin/env python
from pymongo import MongoClient

def insert_zipcode(db):
        for x in range(2000, 3000):
		db.zipcodes.insert({"_id": x, "city": "WASHINGTON", "VG": "CA", "pop": x*100, "loc": [1,2]}) 

def connect_db():
	conn = MongoClient("localhost:27017")
	db = conn.worldmate
	return db	

if __name__ == "__main__":
	db = connect_db()
	insert_zipcode(db)
	print db.zipcodes.find()
